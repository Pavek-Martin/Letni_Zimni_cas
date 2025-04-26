cls
# nastaveni casu v pocitaci posun na letni nebo zimni cas v ofline rezimu

$dnu_navic = 7
$d = "Sunday" # nedele pro Cechy
[string] $letos_rok = (Get-Date).Year
#$letos_rok = "2027" # testovaci radek

<#
posledni nedele v breznu a rijnu je pohyblivy udaj co se tyce cisla dne
napr. pro rok 2025 je to neděle 30. března 2025 a cislo dne je 89
ale pro rok 2026 je to neděle 29. března 2026 a cislo dne je 88
rijen, rovnez pohyblivy napr.
neděle 26. října 2025, 299
neděle 25. října 2026, 298
tohle to bylo zapotreby vzit v uvahu
#>

# --------------- brezen --------------------------
$start_cas_brezen = "03/24/" + $letos_rok + " 02:00:00"
#echo $start_cas_brezen
$brezen = [datetime] $start_cas_brezen
for ($aa = 0; $aa -le 7; $aa++ ) { # -le 7
$den_v_breznu = $brezen.AddDays(+$aa)
$rozdil_mesic_brezen = $den_v_breznu.AddDays($dnu_navic).Month
if ((( $den_v_breznu.Month -eq 3 ) -and ( $den_v_breznu.DayOfWeek -like $d ) -and ( $rozdil_mesic_brezen -eq $den_v_breznu.Month + 1 ))) {
break
}
}

#echo $den_v_breznu
#$posledni_nedele_brezen = $den_v_breznu.Day
#echo $posledni_nedele_brezen #int32
$posledni_nedele_brezen_den_v_roce = $den_v_breznu.DayOfYear # type int32
#echo $posledni_nedele_brezen_den_v_roce
#echo "$posledni_nedele_brezen_den_v_roce cislo dne, posledni nedele v Breznu"

# ----------------- rijen ----------------------------
$start_cas_rijen = "10/24/" + $letos_rok + " 03:00:00"
#echo $start_cas_rijen
$rijen = [datetime] $start_cas_rijen
for ($bb = 0; $bb -le 7; $bb++ ) { # -le 7
$den_v_rijnu = $rijen.AddDays(+$bb)
$rozdil_mesic_rijen = $den_v_rijnu.AddDays($dnu_navic).Month
if ((( $den_v_rijnu.Month -eq 10 ) -and ( $den_v_rijnu.DayOfWeek -like $d ) -and ( $rozdil_mesic_rijen -eq $den_v_rijnu.Month + 1 ))) {
break
}
}

#echo $den_v_rijnu
#$posledni_nedele_rijen = $den_v_rijnu.Day
#echo $posledni_nedele_rijen #int32
$posledni_nedele_rijen_den_v_roce = $den_v_rijnu.DayOfYear
#echo $posledni_nedele_rijen_den_v_roce
#echo "$posledni_nedele_rijen_den_v_roce cislo dne, posledni nedele v Rijnu"

<#
z predchozich informaci se vytvori "usek roku" z hodnotou 1,2 a nebo 3
od 1.1.lotosku do "$posledni_nedele_brezen_den_v_roce" "01:59:59" hodin je usek roku cislo (1)
od "$posledni_nedele_brezen_den_v_roce" "02:00:00" hodin je usek roku cislo (2) az do
"$posledni_nedele_rijen_den_v_roce" "03:00:00" kdy konci usek (2) a zasina usek (3)
az do konce kalendarniho roku 31.12. 23:59:59 pak opet zacina usek roku (1)
do souboru "historie" se pri kazdem spusteni programu zapise tato hodnota
pri dalsim spusteni se nacte a porovna se z aktualni honotou, podle toho se pak upravuje cas
hodina plus nebo hodina minus
pocitac predpoklada ze v okamziku upravi casu je v pocitaci spravne nastaven cas, tak jak ma byt
a odecte nepo pricte hodinu, pokud by tomu tak nebylo tak odecte nebo pricte hodinu stejne
zde se zadna kontrola neprovadi a udaj by pak v takovem pripade byl chybny
pri uplne prvni spusteni kdy jeste neexistuje soubor "historie" program pouze vytvori
tento soubor zapise do nej cislo "usek roku" a predcasne se ukonci
po dalsim spusteni jiz nacte tuto hodnotu z historie a zaroven zjisti hodnotu aktualni
a obe hodnototy porovna, paklize jsou stejne nedala nic, paklize jsou ruzne provadi prislusne
upravy pak zapise do souboru "historie" novou aktualni hodnotu a ceka na dalsi spusteni
pokud je hodnata historie stejna jako aktualni hodnota tak se samozdejme nezapisuje do souboru
"historie" znovu tentyz udaj
vyhodu to ma tu ze diky "useku roku" neni potreba pocitac poustet presne v den zmeny casu ale treba
az za dva dni potom apod. kdyby se na to zapomenlo tak se nic nestane a cas se upravi budto hned 
a nebo pozdeji dodatecne
#>

Remove-Variable usek_roku, pole_file_historie_ulozit, pole_file_historie_nacteno,dr,hh,dr_historie -ErrorAction SilentlyContinue
Remove-Variable zapis_historii, cas_plus_hodina, cas_minus_hodina, file, out_1, out_2 -ErrorAction SilentlyContinue

$pole_file_historie_ulozit = @()

$dr = (get-date).DayOfYear # aktualni den v roce
$hh = (Get-Date).Hour # aktualni hodina atd.

###################    testovaci    ########################################

#$dr  = 333 # aktualni den v roce - testovaci radek 1 
#$hh = 1 # aktualni hodina - testovaci radek 2

############################################################################

#write-host -ForegroundColor Yellow "$dr aktualni cislo dne"

$usek_roku = 0 # kvuli kontrolam chyb napred priradi hodnotu nula, kdyby byla nekde chyba tak zuste nula
# a pride se podle toho na to, mohla by bejt hodnota $usek_roku = $null ale proc zbytecne prerusovat beh
# programu kvuli chybe neexistujici promenny, paklize by se v bloku podminek podtim nic nepriradilo

<# aritmetika operatory
-eq ==
-ne !=
-lt <
-gt >
-le <=
-ge >=
#>

# useku roku = 1 ?
if ( $dr -lt $posledni_nedele_brezen_den_v_roce ) { # <
# zacatek roku az jeden den pred posledni do nedele Brezen
#echo "usek 1-A"
$usek_roku = 1
} elseif (( $dr -eq $posledni_nedele_brezen_den_v_roce ) -and ( $hh -lt 2 )) { # == -and <
# je posledni nedele v breznu ale je mene nezli 02:00:00 hodin
#echo "usek 1-B"
$usek_roku = 1
# usek = 2 ?
} elseif (( $dr -eq $posledni_nedele_brezen_den_v_roce ) -and ( $hh -ge 2 )) { # == -and >=
# je posledni nedele v breznu a cas je rovny a nebo vyssi nez 02:00:00 hodin 
#echo "usek 2-A"
$usek_roku = 2
} elseif (( $dr -gt $posledni_nedele_brezen_den_v_roce ) -and ( $dr -lt $posledni_nedele_rijen_den_v_roce )) { # > -and <
# je poledni nedele Brezen +1 den az do posledni nedele rijen -1 den
$usek_roku = 2 
#echo "usek 2-B"
$usek_roku = 2
} elseif (( $dr -eq $posledni_nedele_rijen_den_v_roce ) -and ( $hh -lt 3 )) { # == -and <
# je posledni nedele rijen ale cas je mensi nezli 03:00:00
#echo "usek 2-C"
$usek_roku = 2
# usek = 3 ?
} elseif (( $dr -eq $posledni_nedele_rijen_den_v_roce ) -and ( $hh -ge 3 )) { # == -and >=
# je posleni nedele rijen a cas je rovny a nebo vyssi nez 03:00:00 hodin
# tady pozor, systemovi cas se zde vrati o hodinu zpatky, takze pri dalsim spusteni by program na zaklade jiz upraveneho
# systemoveho casu $hh = (Get-Date).Hour znovu nabizel ubrani jedne hodiny,( viz. predchozi elseif usek 2-C) toto je potrebna 
# programove osetrit aby k tomuto nemohlo dojit, do souboru historie se krome cisla useku roku (pri posledni spusteni)
# zapise jeste take cislo dne v roce, podminka pak bude : paklize je stejny den v roce v historii pri aktualnim spusteni programu 
# a v historii je usek roku cislo 3 a aktualni je cislo useku je 2 tak - nedelej nic 
# toto plati pouze hodinu vlastne,jenom do te doby nez plynouci systemovi cas zase o hodinu "dobehne" podminku :)
#echo "usek 3-A"
$usek_roku = 3
} elseif ( $dr -gt $posledni_nedele_rijen_den_v_roce ) { # >
# jakykoliv den v roce vyssi nez posledni nedele rijen
#echo "usek 3-B"
$usek_roku = 3
# tady se uz pak neresi presupnej rok tzn. 365 nebo 366 dni v roce
# ale proste jenom jestli je vyssi a prvniho ledna dalsiho roku se pak cislo dne opet vrati $dr=1
# promenna cislo dne v roce je zde vlasne urcujici a myslim ze vsemu hodne pomaha a vse se tim podstatne zjednodusilo
# a proto take byla pouzita
}else{
echo "chyba usek roku" # pro $usek_uroku zustal v hodnote "0"
sleep 10
Exit
}

# tisk
#write-host -ForegroundColor Yellow "$usek_roku aktualni usek roku"
$pole_file_historie_ulozit += $usek_roku
$pole_file_historie_ulozit += $dr
#echo $hh # slozilo pri testovani
#echo $dr # slozilo pri testovani

# nastaveni cest a nazvu souboru historie
$cesta_soubor_historie = "C:\Users\DELL\Documents\zaloha\"
#$cesta_soubor_historie = "R:\"
#$nazev_souboru_historie = "historie.txt"
$nazev_souboru_historie = "historie_letni_zimni_cas.txt"
$file = $cesta_soubor_historie + $nazev_souboru_historie
#echo $file"<<"

# existuje jiz soubor historie ? paklize ne tak vytvor novy zapis do nej aktualni cislo usek roku 
# a aktualni cislo dne, ukonci program a v tomto stavu cekej na dalsi spusteni
# paklize soubor historie jiz existuje, nacti znej data, porovnej je z aktualnimi daty a podle toho postupuj dale
# az bude vse hotove zapis, ale pouze v pripade rozdilu historie-aktualni nova data do souboru historie a ukonci program
if ( -not ( Test-Path $file )) {
Set-Content $file -Encoding ASCII -Value $pole_file_historie_ulozit
#echo "aktualni data ulozena do souboru : $file"
#echo "novy soubor historie"
sleep 1
Exit
}

# soubor historie jiz existuje, nacti znej udaje a prirad je promenym a proved porovanni z aktualnim stavem
$pole_file_historie_nacteno = @()
if ( Test-Path $file ) {
$pole_file_historie_nacteno += Get-Content -Path $file
[int32] $usek_roku_historie = $pole_file_historie_nacteno[0]
[int32] $dr_historie = $pole_file_historie_nacteno[1]
#Write-Host -ForegroundColor Cyan "$dr_historie historie cislo dne"
#Write-Host -ForegroundColor Cyan "$usek_roku_historie historie usek roku"
}

<# vyhodnoceni co se ma udelat z systemovim casem, rozhodnu jsem se nakonec jenom pro hlaseni, nebude se samo z nicim hejbat
   ono to vyzaduje administratorsky prava a mohlo by to delat bordel, zustene jenom vyset nesmrtelny onko s upozornenim
   aby si uzivat cas upravil sam.
      vsechny stavy ktere moho nastat histroie vs. aktualni cislo roku vzdy ( historie-aktualni )
1-1 - nedelej nic
1-2 - pridej k systemovemu casu +1 hodina ( historie=1, aktualni=2 )
1-3 - program byl naposledy spusten v useku roku 1 pak preskocil cely usek 2 a nyni je aktualni usek roku 3
      cas se tedy mezi tim 2x posunul, tam ale zase i zpatky, takze nedej nic
      (nepravdepodobne ale je treba osetrit programove vsechny existujici mozne stavy)

2-1 - stejna situace jako predchozi, naposledy spusteno v useku 2 a preskocen cely usek 3, nyni usek 1, -1 hodina
2-2 - nedej nic
2-3 - cas se posunul z useku 2 do useku 3 odeber systemovemu casu -1 hodina, predpoklada se ze v pocitaci je spravni cas
      takovy jaky ma byt v okamziku zmenny, toto osetreno neni a ani nemuze byt ( totez pri +1 hodina )
      TADY POZOR, jak jiz bylo popisovano drive pri opakovenem spusteni programu do jedne hodiny !!

3-1 - zacal novy rok, nedelej nic 
3-2 - preskocen cely usek roku 1, prechod ze zimniho casu na letni, odeber systemovemu casu -1 hodina
      ( samozdrejeme nepravdepodobny ale...)
3-3 - nedelej nic
 problem o kterym vim ale nejni kritickej je ten ze cislo dne v useku 3-2 je kazdy rok jiny, takze pakli by byla v historii
 hodnota useku 3-2 napr. z roku 2025 a nova aktualni hodnota 3-2 by byla napr. pro rok 2026 tak by se nesplnila podminka
 na radku 242 uvedeno pod tim ( takze hodinu krize ale pravdepoodbnost ze by ktomu doslo je nepatrna ale uvadim to jako
 hodne obtizne osetritelnou chybu ktera zustala, tady sem si lamal hlavu opravdu marne
 } elseif ((( $usek_roku_historie -eq 3 ) -and ( $usek_roku -eq 2 ) -and ( $dr_historie -ne $dr )))
ps: podminka ($dr_historie -ne $dr) by vlastne splnena byla ten den by byl ruznej ale z jineho duvodu viz. prilozeni soubory *.txt
#>

$zapis_historii = 0 
# bude zapisovat jenom kdyz je potreba, tzn. pouze v pripade zmen a nebude se zapisouvat 2x totez
$cas_plus_hodina = 0
$cas_minus_hodina = 0

if (( $usek_roku_historie -eq 1 ) -and ( $usek_roku -eq 2 )){
#echo "1-2"
$zapis_historii = 1
$cas_plus_hodina = 1
} elseif (( $usek_roku_historie -eq 2 ) -and ( $usek_roku -eq 1 )) {
#echo "2-1"
$zapis_historii = 1
$cas_minus_hodina = 1
} elseif (( $usek_roku_historie -eq 2 ) -and ( $usek_roku -eq 3 )) {
#echo "2-3"
$zapis_historii = 1
$cas_minus_hodina = 1
#} elseif (( $usek_roku_historie -eq 3 ) -and ( $usek_roku -eq 2 )) {
} elseif ((( $usek_roku_historie -eq 3 ) -and ( $usek_roku -eq 2 ) -and ( $dr_historie -ne $dr ))) { # == -and == -and !=
# tady je ochrana proti opakovanymu odecteni hodiny, kdy se program pustil znova !!
#echo "3-2 pozor -1 hodina systemovej cas"
$zapis_historii = 1
$cas_minus_hodina = 1
}

# hlaseni o zmene casu
if ( $zapis_historii -eq 1 ) {
Set-Content $file -Encoding ASCII -Value $pole_file_historie_ulozit
#echo "  ZApasano"
sleep 1
}else{
#echo "  NEzapsano"
}

#$cas_minus_hodina = 0 # testovaci radek 
#$cas_plus_hodina = 1 # testovaci radek

# jenom zobrazuje upozorneni, zmena casu vyzaduje prava admim. a do toho se my nechtelo... ( urob si sam )
# kdyby se to nekomu nelibylo at si to predela, me vyhovuje takto
if ( $cas_plus_hodina -eq 1 ) {
# -1 hodina
echo ""
$out_1 = "{0:dd.MM.yyyy ve HH.mm.ss}" -f $den_v_breznu
Write-host -ForegroundColor Red "   dne $out_1 hodiny, se preslo na letni cas +1 hodina, upravte si proto prosim systemovy cas !"
Read-Host -Prompt "   Press ENTER to exit"
}

if ( $cas_minus_hodina -eq 1 ) { 
# +1 hodina
echo ""
$out_2 = "{0:dd.MM.yyyy ve HH.mm.ss}" -f $den_v_rijnu
Write-host -ForegroundColor Red "   dne $out_2 hodiny, se preslo na zimni cas -1 hodina, upravte si proto prosim systemovy cas !"
Read-Host -Prompt "   Press ENTER to exit"
}

