cls

Remove-Variable * -ErrorAction SilentlyContinue
# vymaze vsechny uzivatelske promenne ( pro pripad opakovaneno spusteni v editoru )

<# 
delka roku presne : 365.2422
gregorian:
kazdy 4ty rok je prestupny
kazdy 100ty neni prestupny
a kazdy 400ty, je prestupny
#>

$pole_roky_output = @()
[double] $delka_rok_presne = 365.2422 # delka roku, presne

$suma_roky = 0
$suma_dny = 0

$min = 1700
#$max = (( 1700 + 10 ))
#$max = 2200
$max = (( $min + 3300 )) # tady je moznost si jeste hrat stim druhym cislem 3300

<#
-eq == 
-ne !=
-lt <
-gt >
-le <=
-ge >=
#>

for ( $rok = $min; $rok -lt $max; $rok++ ){ # od zacatku roku 1700 az do konce roku 2199 ( nebo 4999)

if (( $rok % 4 -eq 0) -and (( $rok % 100 -ne 0 ) -or ( $rok % 400 -eq 0 ))) {
# prestupny rok
[string] $out_1 = $rok
$out_1 += " pr."
echo $out_1
$pole_roky_output += $out_1
$suma_dny = $suma_dny + 366
} else {
# neprestupny rok
echo $rok
$pole_roky_output += $rok
$suma_dny = $suma_dny + 365
}
$suma_roky++

} 

$out_11 =  "------------------------------------"
echo $out_11
$pole_roky_output += $out_11

$out_2 = [string] $suma_roky + " # pocet let"
echo $out_2
$pole_roky_output += $out_2

$out_3 = [string] $(( $suma_roky * 365 )) + " # pocet dnu, bez niceho ( jenom roky * 365 )"
echo $out_3
$pole_roky_output += $out_3
echo ""
$pole_roky_output += ""

$out_4 = [string] $suma_dny + " # celkem dnu se spravnym zapoctem vsech prestupnych a neprestupnych let"
echo $out_4
$pole_roky_output += $out_4
# Juliana jsem preskocil a tohle by mel teda u rovnou ten Rehor XIII
$out_5 =  [string] $(( $suma_roky * $delka_rok_presne )) + " # pocet let krat presna delka roku tj. " + $delka_rok_presne
echo $out_5
$pole_roky_output += $out_5
echo ""
$pole_roky_output += ""

#echo $pole_roky_output.Length

$filename_output = "prestupne_roky_"
$filename_output += [string] $min
$filename_output += "-"
$filename_output += [string] $max
$filename_output += "_ps.txt"

Set-Content -Path $filename_output -Encoding ASCII -Value $pole_roky_output
echo "vysledek zapsan do souboru $filename_output"
sleep 30

