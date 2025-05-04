#cls

#$rok = 1980
$rok = Read-Host "Zadejte rok"
$rok = [int]$rok

#
$pole_delka_mesice = @(31,99,31,30,31,30,31,31,30,31,30,31)
# upravi se unor (99) podle toho jesli je prestupny rok nebo ne
if (( $rok % 4 -eq 0 ) -and (( $rok % 100 -ne 0) -or ( $rok % 400 -eq 0 ))) {
$pole_delka_mesice[1]=29
}else{ $pole_delka_mesice[1]=28
}

$prestupny_rok = $pole_delka_mesice[1]
echo "unor $rok = $prestupny_rok dnu" # prstupny rok ?

# Sakamoto algoritmus
# 0 = nedele, 1 = pondeli, ..., 6 = sobota
function Get-DayOfWeek($year, $month, $day) {
# pole s posuny pro jednotlive mesice
$t = @( 0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4 )
# Pokud je mesic leden nebo unor, snizi rok o 1
if ($month -lt 3) { $year = $year - 1 } # dulezite !
# vypocita den v tydnu
$dow = ($year + [math]::Floor($year / 4) - [math]::Floor($year / 100) + [math]::Floor($year / 400) + $t[$month - 1] + $day) % 7
#write-host $dow 
#write-host ktery nepouziva pipeline se muze pouzit takhle primo uvnitr funkce a nebude nicemu prekazet narozdil od "echo"
return [int]$dow
}


# brezen
$mesic_1 = 3
$pocet_dnu_v_mesici_brezen = $pole_delka_mesice[$mesic_1 -1]
$den_v_tydnu_1 = Get-DayOfWeek $rok $mesic_1 $pocet_dnu_v_mesici_brezen
$posledni_nedele_v_breznu = $pocet_dnu_v_mesici_brezen - $den_v_tydnu_1
# spocita cislo dne, sice je na to uz primo hotova funkce ale chtel jsem si to zkusit sam
# cislo den brezen ( no jo no tak asi by bezelo i na QL-ku )
$cislo_dne_brezen = 0
for ( $aa = 0; $aa -le $mesic_1 -2; $aa++ ) { $cislo_dne_brezen += $pole_delka_mesice[$aa] }
$cislo_dne_brezen += $posledni_nedele_v_breznu
#echo $cislo_dne_brezen"<"
echo "nedele $posledni_nedele_v_breznu.$mesic_1.$rok cislo dne je $cislo_dne_brezen"


# rijen
$mesic_2 = 10
$pocet_dnu_v_mesici_rijen = $pole_delka_mesice[$mesic_2 -1]
$den_v_tydnu_2 = Get-DayOfWeek $rok $mesic_2 $pocet_dnu_v_mesici_rijen
$posledni_nedele_v_rijnu = $pocet_dnu_v_mesici_rijen - $den_v_tydnu_2
# cislo den rijen
$cislo_dne_rijen = 0
for ( $bb = 0; $bb -le $mesic_2 -2; $bb++ ) { $cislo_dne_rijen += $pole_delka_mesice[$bb] }
$cislo_dne_rijen += $posledni_nedele_v_rijnu
#echo $cislo_dne_rijen"<<"
echo "nedele $posledni_nedele_v_rijnu.$mesic_2.$rok cislo dne je $cislo_dne_rijen"

sleep 60


