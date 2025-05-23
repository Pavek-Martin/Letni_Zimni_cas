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

#$suma_roky = 0
#$suma_dny = 0

$min = 2025
#$max = (( 1700 + 20 ))
#$max = 2401
#$max = (( $min + $(( 3300 * 1 )) )) # tady je moznost si jeste hrat stim druhym cislem 3300

for ( $max = 2025 ; $max -lt ((2025 + 6600)); $max++) { # + 2000
echo $max
$pole_roky_output += $max

$suma_roky = 0
$suma_dny = 0

#$max = (( $min + $t ))
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
#echo $out_1
#$pole_roky_output += $out_1
$suma_dny = $suma_dny + 366
} else {
# neprestupny rok
#echo $rok
#$pole_roky_output += $rok
$suma_dny = $suma_dny + 365
}
$suma_roky++

} 

$out_11 =  "------------------------------------"
#echo $out_11
#$pole_roky_output += $out_11

$out_2 = [string] $suma_roky + " # pocet let"
echo $out_2
$pole_roky_output += $out_2

$out_3 = [string] $(( $suma_roky * 365 )) + " # pocet dnu, bez niceho ( jenom roky * 365 )"
#echo $out_3
#$pole_roky_output += $out_3
#echo ""
#$pole_roky_output += ""

$out_4 = [string] $suma_dny + " # celkem dnu se spravnym zapoctem vsech prestupnych a neprestupnych let"
echo $out_4
$pole_roky_output += $out_4
# Juliana jsem preskocil a tohle by mel teda u rovnou ten Rehor XIII
$out_5 =  [string] $(( $suma_roky * $delka_rok_presne )) + " # pocet let krat presna delka roku tj. " + $delka_rok_presne
echo $out_5
$pole_roky_output += $out_5
#echo ""
#$pole_roky_output += ""

$v1 = (( $suma_roky * $delka_rok_presne ))
#echo $v1
if ( $suma_dny -gt $v1 ) {$r = $suma_dny - $v1; echo "a"}
if ( $v1 -gt $suma_dny ) {$r = $v1 - $suma_dny; echo "b"}
if ( $v1 -eq $suma_dny ) {$r = 0; echo "c"}

echo $r
$pole_roky_output += $r
$pole_roky_output += ""

if ( $r -ge 1.0 ){
#echo $max
#break # nastavenej podminkou break, paklize by byl rozdil vetsi nezli 1.0 dne
}

echo ""
$r=0
$v1=0

} # for t


#echo $pole_roky_output.Length

$filename_output = "rok_2104.txt" # rok 2104 je zrovna prestupnej ( kdyby nebyl tak by byl vysledek 0.1338 misto 1.1338 )
#$filename_output += [string] $min
#$filename_output += "-"
#$filename_output += [string] $max
#$filename_output += "_ps.txt"

Set-Content -Path $filename_output -Encoding ASCII -Value $pole_roky_output
echo "vysledek zapsan do souboru $filename_output"
sleep 30

