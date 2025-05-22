cls

<#
takle to vlastne vypada z prestupnejma vterinama, zpatky o vterinu se rozhodne jit neda
doporucuju video na Youtube z kanalu Commputherphile, ktere se jmenuje "Unix time stamp"
a nebo tak nejkak podobne
#>

echo "Unix time stamp se meni kazdou vterinu inkrementaci o +1"
echo "zacatek epochy nastal podle ruznych zdroju dne 1.1.1970 o pulnoci"

for ( $i = 1; $i -lt 30; $i++ ) {
$stamp = [DateTimeOffset]::Now.ToUnixTimeseconds()
echo $stamp
sleep -Milliseconds 500
}

