#include <iostream> // pro system("pause");
#include <ctime> // pro vytvoreni Unix time stampu
#include <windows.h> // pro Sleep();

using namespace std;

int main() {
	cout<<"Unix time stamp se meni kazdou vterinu inkrementaci o +1"<<endl;
	cout<<"zacatek epochy nastal podle ruznych zdroju dne 1.1.1970 o pulnoci"<<endl;
	

for ( int a = 1 ; a <= 30; a++) {	

    time_t stamp = time(0); // toto je linux stamp
    cout<<stamp<<endl;
  
    Sleep(500); // ceka 0.5 vteriny
}
	system("pause");
	return 0;
}

