cls

$d = "Sunday" # nedele pro Cechy
[string] $letos_rok = (Get-Date).Year
$letos_rok = "2030" # testovaci radek

for ( $r= 1800; $r -le 2200; $r++ ){
$letos_rok = $r
#}


# --------------- brezen
$start_cas_brezen = "03/24/" + $letos_rok + " 02:00:00"
#echo $start_cas_brezen
$brezen = [datetime] $start_cas_brezen
for ($aa = 1; $aa -le 7; $aa++ ) { # -le 7
$den_v_breznu = $brezen.AddDays(+$aa)
if (( $den_v_breznu.Month -eq 3 ) -and ( $den_v_breznu.DayOfWeek -like $d )) {
break
}
}

echo $den_v_breznu
#$posledni_nedele_brezen = $den_v_breznu.Day
#echo $posledni_nedele_brezen #int32
$posledni_nedele_brezen_den_v_roce = $den_v_breznu.DayOfYear # type int32
#echo $posledni_nedele_brezen_den_v_roce
#echo "$posledni_nedele_brezen_den_v_roce cislo dne, posledni nedele v Breznu"


}
sleep 10
