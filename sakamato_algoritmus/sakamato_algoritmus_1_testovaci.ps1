#cls

$out_array = @()

# Sakamoto algoritmus
# 0 = nedele, 1 = pondeli, ..., 6 = sobota
function Get-DayOfWeek($year, $month, $day) {
# pole s posuny pro jednotlive mesice
$t = @( 0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4 )
# Pokud je mesic leden nebo unor, snizi rok o 1
if ($month -lt 3) { $year = $year - 1 }
# vypocita den v tydnu
$dow = ($year + [math]::Floor($year / 4) - [math]::Floor($year / 100) + [math]::Floor($year / 400) + $t[$month - 1] + $day) % 7
#write-host $dow 
#write-host ktery nepouziva pipeline se muze pouzit takhle primo uvnitr funkce a nebude nicemu prekazet narozdil od "echo"
return [int]$dow
}

#$rok = 2022
#Remove-Variable mesic -ErrorAction SilentlyContinue

$delka_args = $args.length
#echo "celkem args $delka_args" # int32 
if ($delka_args -eq 0) { #int32
echo "zadny argument"
sleep 1
Exit
}

$mesic = 1 # <<<<<<<<<<<<<< menit
[int32]$mesic = $args[0]
#echo $mesic.GetType()
#exit 1


for ( $rok = 1800; $rok -le 2200; $rok++ ){ # testovaci cyklus
#for ( $rok = 2025; $rok -le 2045; $rok++ ) { # toto je testovaci cyklus
# funguje uz i z prestupnejma rokama, samo o sobe ! asi radek cislo 11

#$pole_delka_mesice = @(31,28,31,30,31,30,31,31,30,31,30,31)
$pole_delka_mesice = @(31,99,31,30,31,30,31,31,30,31,30,31)
# upravi se unor (99) podle toho jesli je prestupny rok nebo ne
if (( $rok % 4 -eq 0 ) -and (( $rok % 100 -ne 0) -or ( $rok % 400 -eq 0 ))) {
$pole_delka_mesice[1]=29
}else{ $pole_delka_mesice[1]=28
}

#echo $pole_delka_mesice[1]
$pocet_dnu_v_mesici = $pole_delka_mesice[$mesic -1]

# vypocita den v tydnu, pro 31 brezna
# 0 = nedele, 1 = pondeli, ..., 6 = sobota
$den_v_tydnu = Get-DayOfWeek $rok $mesic $pocet_dnu_v_mesici
#echo $denVTydnu
$posledni_nedele_v_mesici = $pocet_dnu_v_mesici - $den_v_tydnu

$dd = [string]$rok
$dd += " "
$dd += [string]$posledni_nedele_v_mesici
$dd += "."
$dd += [string]$mesic
echo $dd
$out_array += $dd
#echo $pole_delka_mesice[1] # prestupny unor ?
}

# zapise vysledky do souboru z cisle mesice na konci
$out_file_name = "sakamato_"
$out_file_name += [string]$mesic
$out_file_name += ".txt"

Set-Content -Path $out_file_name -Encoding ASCII -Value $out_array
#echo ""
#echo $out_file_name

