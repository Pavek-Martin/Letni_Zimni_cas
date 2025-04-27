cls

$d = "Sunday" # nedele pro Cechy
[string] $letos_rok = (Get-Date).Year
$letos_rok = "2030" # testovaci radek

for ( $r= 1800; $r -le 2200; $r++ ){
$letos_rok = $r
#}

# ----------------- rijen 
$start_cas_rijen = "10/24/" + $letos_rok + " 03:00:00"
#echo $start_cas_rijen
$rijen = [datetime] $start_cas_rijen
for ($bb = 1; $bb -le 7; $bb++ ) {
$den_v_rijnu = $rijen.AddDays(+$bb)
if (( $den_v_rijnu.Month -eq 10 ) -and ( $den_v_rijnu.DayOfWeek -like $d )) {
break
}
}

echo $den_v_rijnu
#$posledni_nedele_rijen = $den_v_rijnu.Day
#echo $posledni_nedele_rijen #int32
$posledni_nedele_rijen_den_v_roce = $den_v_rijnu.DayOfYear
#echo $posledni_nedele_rijen_den_v_roce
#echo "$posledni_nedele_rijen_den_v_roce cislo dne, posledni nedele v Rijnu"


}
sleep 10


