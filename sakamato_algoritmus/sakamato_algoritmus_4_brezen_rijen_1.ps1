cls


$rok = 2025

$pole_delka_mesice = @(31,99,31,30,31,30,31,31,30,31,30,31)
# upravi se unor (99) podle toho jesli je prestupny rok nebo ne
if (( $rok % 4 -eq 0 ) -and (( $rok % 100 -ne 0) -or ( $rok % 400 -eq 0 ))) {
$pole_delka_mesice[1]=29
}else{ $pole_delka_mesice[1]=28
}

echo $pole_delka_mesice[1] # prstupny rok ?

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

$mesic = 3
$pocet_dnu_v_mesici = $pole_delka_mesice[$mesic -1]
$den_v_tydnu = Get-DayOfWeek $rok $mesic $pocet_dnu_v_mesici
$posledni_nedele_v_mesici = $pocet_dnu_v_mesici - $den_v_tydnu
echo "nedele $posledni_nedele_v_mesici.$mesic.$rok"

$mesic = 10
$pocet_dnu_v_mesici = $pole_delka_mesice[$mesic -1]
$den_v_tydnu = Get-DayOfWeek $rok $mesic $pocet_dnu_v_mesici
$posledni_nedele_v_mesici = $pocet_dnu_v_mesici - $den_v_tydnu
echo "nedele $posledni_nedele_v_mesici.$mesic.$rok"

sleep 10

