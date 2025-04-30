#!/usr/bin/bash

# tento skript nespoustet samostatne ale spustit skript test.sh

# provadi na linuxu kontrolu vysledku scriptu pro PowerShell sakamato_8.ps1
# Sakamato algotitmus viz. napr. wikipedie - algoritmus pro urceni den v mesici
# posledni nedele v breznu dne apod. ( asi bud fungovat i na QL-ku )
# ke kontole pouziva linuxovej kalendar "cal" takze jistota spravnosti overeni vysledku :)

if [ -z "$1" ]
then
echo "mesic jako $1"
exit 1
fi

m=$1
#echo $m

for r in {1800..2200}; do
#echo "$r .$m"

# pouziva cal plus awk-cko
aa=$(cal $m $r | awk -F' ' '{print $1}')
# vezme prvni sloupec kalendare coz je nedele (angl.)
#echo $aa

# a z posledniho radky jeste vezme jenom 2 posledni znaky
# coz je cislo dne posledni nedele v mesici
bb=${aa:${#aa}-2:${#aa}}
#echo $bb

echo "$r $bb.$m"
done

# pouzito potom v test.sh
#powershell.exe -file sakamato_7.ps1 $m
