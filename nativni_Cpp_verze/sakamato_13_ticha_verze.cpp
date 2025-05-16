#include <ctime>
#include <iostream>
#include <bits/stdc++.h>
#include <windows.h> // pro funkci delay();

/* toto je ticha varze programu a dela vse na pozadi, ozve se pouze v pripade chyby a nebo hlaseni o zmene casu
zmena nazvu souboru historie pripadne i doplneni cesty k nemu ja na radku 127
teto radek v pripade potreby upravte dle sveho a program znovu prekompilujte
takto bez uprav program funguje takze bude vytvaret soubor historie na stejnem miste kde jako je tento program
obe verze delaj uplne to sami akorat ze "ticha" verze ma zakomentovani prislusny radky kde by se jinak neco vypisovalo
*/

using namespace std;

// funkce Sakamoto algorithm
int day_of_the_week(int y, int m, int d) {
    // array with leading number of days values
    int t[] = { 0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4 };
    // if month is less than 3 reduce year by 1
    if (m < 3)
    y -= 1;
    return ((y + y / 4 - y / 100 + y / 400 + t[m - 1] + d) % 7);
}

int main(int argc, char** argv) {
   
   // zjisteni aktualniho datumu, ted
   time_t now = time(0);
   tm *ltm = localtime(&now);
   int year = 1900 + ltm->tm_year;
   int month = 1 + ltm->tm_mon;
   int d = ltm->tm_mday;
   int h = ltm->tm_hour;
   
   // #################  testovaci  ###############################
   //d = 1; // testovaci radek, den
   //month = 1; // testovaci radek, mesic
   //h = 1; // testovaci radek
   //year = 2027; // testovaci radek, rok
   // #############################################################

   // pole pocet dnu v mesicich
   	int a[]={0,31,28,31,30,31,30,31,31,30,31,30,31};
   	//       0  1  2                            12
   	
	if (( year % 4 == 0 ) && (( year % 100 != 0) || ( year % 400 == 0 ))) {
    //cout<<"rok "<<year<<" je prestupni rok"<<endl;
    a[2]=29; // prestupny unor
	}
	
   	int day = a[month];
	int cislo_dne_dnes = 0;  
	// zjisti aktualni cislo dne, dnesni
	for ( int aa = 0; aa <= month -1; aa++) {
		//cout<<a[aa]<<endl;
		cislo_dne_dnes += a[aa];
	}
	
	cislo_dne_dnes += d;
	
	// #################  testovaci  ###############################
	//cislo_dne_dnes = 334; // testovaci radek, cislo dne dnes
	//h = 3; // hodina ted
	// #############################################################
	
	//cout<<"Dnes dnes je "<<d<<"."<<month<<"."<<year<<endl;
    //cout<<h<<" hodin"<<endl;
	//cout<<"cislo dne je "<<cislo_dne_dnes<<endl<<endl;

    // posledni nedele v breznu
    // brezen 31 dnu a rijen taky 31 dnu ( day=31 )
	day = 31, month = 3; // brezen ma 31 dnu a cislo mesice je 3
	int offset_brezen = 0, posledni_nedele_v_breznu = 0, cislo_dne_brezen = 0; // deklarace az zde
	offset_brezen = (day_of_the_week(year, month, day));
	posledni_nedele_v_breznu = a[month] - offset_brezen;
	//cout<<"posledni nedele v breznu "<<posledni_nedele_v_breznu<<"."<<month<<"."<<year<<endl;
    
	// cislo dne, posledni nedele brezen, pro aktualni rok
		for ( int bb = 0; bb <= month -1; bb++) {
		cislo_dne_brezen += a[bb];
	}
	
	cislo_dne_brezen += posledni_nedele_v_breznu;
	//cout<<"cislo dne, posledni nedele v breznu je "<<cislo_dne_brezen<<endl<<endl;
	
	// posledni nedele v rijnu
	day = 31, month = 10; // rijen ma 31 dnu a cislo mesice je 10
	int offset_rijen = 0, posledni_nedele_v_rijnu = 0, cislo_dne_rijen = 0; // musi bejt =0 jinak, blblo
	offset_rijen = (day_of_the_week(year, month, day));
	posledni_nedele_v_rijnu = a[month] - offset_rijen;
	//cout<<"posledni nedele v rijnu "<<posledni_nedele_v_rijnu<<"."<<month<<"."<<year<<endl;
	
	   // cislo dne, posledni nedele rijen, pro aktualni rok
		for ( int cc = 0; cc <= month -1; cc++) {
	   //cout<<a[cc]<<endl;
		cislo_dne_rijen += a[cc];
	}
	
	cislo_dne_rijen += posledni_nedele_v_rijnu;
	//cout<<"cislo dne, posledni nedele v rijnu je "<<cislo_dne_rijen <<endl<<endl;
	
	// urceni aktualniho useku roku
	// h, cislo_dne_dnes, cislo_dne_brezen, cislo_dne_rijen, // pouzite promenne, rekapitulace

	int usek_roku = 0; // nastavena nula pro kontorolu za blokem podminek
	//cout<<"aktualne je :"<<endl;
	if (cislo_dne_dnes < cislo_dne_brezen){usek_roku = 1;}
	if (cislo_dne_dnes == cislo_dne_brezen && h < 2){usek_roku = 1;}
	if (cislo_dne_dnes == cislo_dne_brezen && h >= 2){usek_roku = 2;}
	if (cislo_dne_dnes > cislo_dne_brezen && cislo_dne_dnes < cislo_dne_rijen){usek_roku = 2;}
    if (cislo_dne_dnes == cislo_dne_rijen && h < 3){usek_roku = 2;}
    if (cislo_dne_dnes == cislo_dne_rijen && h >= 3){usek_roku = 3;}
    if (cislo_dne_dnes > cislo_dne_rijen){usek_roku = 3;}
	
	// testovaci radek, chyba "usek_roku" zustal po pruchodu vsema podminkama v hodnote "0"
	if (usek_roku == 0 ){cout<<"chyba, nebylo mozne urcit usek_roku"<<endl;
	system("pause");
	exit(1); // chybovej exit 1
	}
	
	//cout<<"usek_roku = "<<usek_roku<<endl<<endl;
	
	// overeni existence souboru historie, nacteni hodnot soubor historie paklize soubor jiz existuje
	// a nebo zapis aktualnich hodno pokud soubor jrste neexistuje a predcasne ukonceni porogramu
	
	// toto bude nazev souboru historie, ve stejnem adresari jako "exe", tzn. bez cesty
    const string filename = "historie_letni_zimni_cas.txt";  // nazev souboru historie lze menit
    // menit umisteni kde se bude ukladat soubor historie lze i pres zastupce programu v sekci upravy
    // radek "Spustit v :" ( viz screenshoty ve slozce "jpg" )
    int hist_usek_roku = 0, hist_cislo_dne = 0; // deklarace promennych pro nacteni ze souboru historie
    
    // zkusi otevrit soubor pro cteni
    ifstream infile(filename);
    
    if (!infile.is_open()) { // nelze otevzit soubor
        // Soubor neexistuje, vytvor novy a zapis do nej aktualni zjistene hodnoty
        // Otevreni souboru pro zapis.
        ofstream outfile(filename);
        if (outfile.is_open()) {
            
            outfile<<usek_roku<<endl<<cislo_dne_dnes<<endl; // zapise dve hodnoty, pod sebou
			outfile.close(); // uzavre soubor pro zapis
			
	        //cout<<"byl vytvoren novi soubor \""<<filename<<"\""<<endl;
            //cout<<"zapsano do souboru :"<<endl;
            //cout<<"hist_usek_roku = "<<usek_roku<<endl;
            //cout<<"hist_cislo_dne = "<<cislo_dne_dnes<<endl<<endl;
            //cout<<"nyni, spust program znova"<<endl;
            Sleep(1000); // sleep 1
   
        } else {
            cout<<"chyba pri zapisu do souboru historie !"<<endl; // ochrana proti Read-Only
            cout<<"program predcasne ukoncen"<<endl;
            system("pause");
			return 1; // 1 = chyba
        }
    } else {
    	
        // soubor jiz existuje a nacte znej hodnoty
        //cout<<"nacten soubor \""<<filename<<"\""<<endl;
        infile>>hist_usek_roku>>hist_cislo_dne ; // nacita radky ( takto nacte dva radky pod sebou !)
        infile.close(); // zavre soubor, pro cteni
        
        //cout<<"hist_usek_roku = "<<hist_usek_roku<<endl;
        //cout<<"hist_cislo_dne = "<<hist_cislo_dne<<endl;
    }
    
    /* 
	dalsi vyhodnoceni, porovnani aktualniho z obsahem nactenim ze souboru historie
	a informace o pripadne zmene casu na letni a nebo na zimni cas
	do souboru historie se bude zapisovat pouze v pripade zmen a nebude se zapisovat 2x to same
	proto zavedana promenna "zapis_historii"
	*/
    
	int zapis_historii = 0, cas_plus_hodina = 0, cas_minus_hodina = 0;
    // usek_roku, cislo_dne_dnes, hist_usek_roku, hist_cislo_dne // rekapitulace prommenych
    
    if (hist_usek_roku == 1 && usek_roku == 2){zapis_historii = 1; cas_plus_hodina = 1;}
	if (hist_usek_roku == 2 && usek_roku == 1){zapis_historii = 1; cas_minus_hodina = 1;}
	if (hist_usek_roku == 2 && usek_roku == 3){zapis_historii = 1; cas_minus_hodina = 1;}
	
	// tady je ochrana proti opakovanymu odecteni hodiny, kdy se program pustil znova do jedny hodiny !
	if (hist_usek_roku == 3 && usek_roku == 2 && hist_cislo_dne != cislo_dne_dnes){
	//cout<<"3-2"<<endl; // pozor -1 hodina systemovej cas ( po dobu jedny hodiny )
	// takze porovnava i cislo dne a paklize je stejny tak -1 hodina uz "dnes" probehla (ale pozor, viz. nize)
	zapis_historii = 1; cas_minus_hodina = 1;}
	
	// pokud nastal novej rok tzn. hist_usek_roku=3 a usek_roku=1, zapis do historie novy aktualni informace
	if (hist_usek_roku == 3 && usek_roku == 1){cout<<endl<<"nastal novy rok"<<endl; zapis_historii = 1;}
	
	/* pozn. neni osetrena situace "3-2" kdyz by posledni zapis do historie probehl napr. v "usek_roku=3" 
	pro rok "2025" a znovu byl program spusten az v "usek_roku=2" ale az v nasledujicim roce tedy "2026"
	cislo den posledni nedele v rijnu je pro kazdy rok jine takze by byla splnena podminka
	( hist_cislo_dne != cislo_dne_dnes ) ale z jineho duvodu nez je zamysleno jako ochrana
	proti opakovanemu spusteni do jedne hodiny ktrera je kriticka kvuli posunuti systemoveho casu..
	program se musi spustit napred kdykoliv v "usek_roku=1" v roku "2026" aby zapsal do historie
	ze nastal novy rok a pak cekal na "usek_roku=2"
	program je dalany tak aby se poustel pravidelne pri kazdem startu pocitace a jeho zastupce
	by umisten (jak jsem psal jiz jinde) v nabidce "Po spusteni"
	"C:\Users\DELL\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\"
	paklize by nekomu tato skutecnost vadila tak resenim by bylo pridat do souboru historie jeste
	treti radek z cislem roku napr. "2025" a v programu vytvorit dalsi podminky, ktere by osetrili
	vsechny mozne stavy ktere pri spousteni a ukladani do historii jeste mohou nastat
	ja jsem se spokojil z touto funkcionalitou, pri mem planovanem zpusobu pouzivani...
	*/
		
	// zaverecne vyhodnoceni a pripadne zobrazeni vysledku a zapis do souboru historie
	//cout<<endl;
	//cout<<"konecne vyhodnoceni :"<<endl;
	//cout<<"zapis_historii = "<<zapis_historii<<endl;
	//cout<<"cas_minus_hodina = "<<cas_minus_hodina<<endl;
	//cout<<"cas_plus_hodina = "<<cas_plus_hodina<<endl<<endl;
	
	if ( zapis_historii == 1) {
        // Otevreni souboru pro zapis.
        ofstream outfile(filename);
        if (outfile.is_open()) { // ochrana proti Read-Only
            
            outfile<<usek_roku<<endl<<cislo_dne_dnes<<endl; // zapise dve hodnoty, pod sebou
			outfile.close(); // uzavre soubor pro zapis
			
            //cout<<"nove zapsano do souboru historie :"<<endl;
            //cout<<"usek_roku = "<<usek_roku<<endl;
            //cout<<"cislo_dne = "<<cislo_dne_dnes<<endl;
            
			// ceka vterinu ale jen v pripade ze zapisuje ho historie ze nastal novy rok
			// jinak pri hlaseni +- hodina je jeste "pause" takze zobrazi vse najednou a ceka
			if ( hist_usek_roku == 3 && usek_roku == 1 ){
			Sleep(1000);
			}

        } else {
            cout<<"chyba pri zapisu do souboru historie !"<<endl; // kvuli Read-Only apod.
            cout<<"program predcasne ukoncen"<<endl;
            system("pause"); // zustane "vyset" ze je chyba
			return 1; // 1 = chyba
        }	
	}
	
	
	// hlaseni a zmene casu +1 hodina
	if ( cas_plus_hodina == 1) {
		cout<<endl;
		cout<<"dne "<<posledni_nedele_v_breznu<<".3"<<"."<<year;
		cout<<" ve 2 hodiny, se preslo na letni cas +1 hodina, upravte si proto prosim systemovy cas !";
		cout<<endl<<endl;
		system("pause");
	}
	
	// hlaseni a zmene casu -1 hodina
	if ( cas_minus_hodina == 1) {
		cout<<endl;
		cout<<"dne "<<posledni_nedele_v_rijnu<<".10"<<"."<<year;
		cout<<" ve 3 hodiny, se preslo na zimni cas -1 hodina, upravte si proto prosim systemovy cas !";
		cout<<endl<<endl;
	    system("pause");
	}
	
    // konec main loopu
	//system("pause");
	return 0;
}

