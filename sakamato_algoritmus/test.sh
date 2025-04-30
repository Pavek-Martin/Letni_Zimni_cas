#!/usr/bin/bash

# spustit tonto skript a nepoustet samostatne script kontrola.sh

# smazne pro jistotu vsechny soubor z priponou "txt" v adrsari
rm *.txt
sleep 1
ls
sleep 3

# generuje pres linuxovej kalandar "cal" textovy soubory ktery pak slouzej jako kontolni soubory
# pro porovni vystupu z PowerShellu
for x in {1..12};do ./kontrola.sh $x > "cal_"$x".txt"
# tady vola script kontrola.sh ( proto drivejsi upozorneni )

powershell.exe -file sakamato_algoritmus_1.ps1 $x; done
# pozn. prikaz "poweshell" funguje jenom na pocitaci z windows a emulatorem Ubuntu, kde se da z Ubuntu zavolat i PowerShell
# takze tady radek zakomentovat a vyresit jinde nejak jinak...

# jenom vizualni kontorola jesli maji soubory stejny pocet radku
cat cal_1.txt | wc -l
cat sakamato_1.txt | wc -l
sleep 3

# generuje textove soubory z vysledky v PowerShellu, sakamato_1.txt - sakamato_12.txt
for y in {1..12};do dos2unix "sakamato_"$y".txt"; done

for z in {1..12};do echo $z; diff "cal_"$z".txt" "sakamato_"$z".txt"; done
