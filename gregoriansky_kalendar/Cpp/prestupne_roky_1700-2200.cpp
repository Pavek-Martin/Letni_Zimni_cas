#include <iostream>
#include <fstream>
#include <stdlib.h>

using namespace std;

/*
delka roku 365,2422 ( chyba 11 minut )
kazdy 4ty rok je prestupny
kazdy 100ty neni prestupny
a kazdy 400sty, prestupny je
*/
  	
int main(){
	
	ofstream stream;
	string filename_output = "prestupne_roky_1700-2200_Cpp.txt";
	
		stream.open(filename_output); //otevreni souboru
	    if (stream){
	    for ( int rok = 1700; rok <= 2200; rok++ ){
	    if (( rok % 4 == 0 ) && (( rok % 100 != 0) || ( rok % 400 == 0 ))) {
        // pouzita funkce modulo ( celociselny zbytek po deleni )
        cout<<rok<<" PR."<<endl;
        stream<<rok<<" PR."<<endl;
	    } else {
	    cout<<rok<<endl;	
	    stream<<rok<<endl;
		}
		}
		
		cout<<endl<<"vysledky zapsany do souboru "<<'"'<<filename_output<<'"'<<endl;
		stream.close(); // uzavreni souboru
	    } else
		cout<<"soubor "<<'"'<<filename_output<<'"'<<" se nepodarilo otevrit !"<<endl; 
		
	system("pause");
	return 0;
}


