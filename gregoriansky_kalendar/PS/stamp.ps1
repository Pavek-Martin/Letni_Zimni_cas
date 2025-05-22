cls
<#
takle to vlastne vypada z prestupnejma vterinama, zpatky o vterinu se rozhodne jit neda
vice muze povodet napr. toto video https://www.youtube.com/watch?v=-ypwkDR0MtI
nebo zde tato stranka
https://www.unixtimestamp.com/
#>

echo "Unix time stamp se meni kazdou vterinu inkrementaci o +1"
echo "zacatek epochy nastal podle ruznych zdroju dne 1.1.1970 o pulnoci"

for ( $i = 1; $i -lt 30; $i++ ) {
$stamp = [DateTimeOffset]::Now.ToUnixTimeseconds()
echo $stamp
sleep -Milliseconds 500
}

