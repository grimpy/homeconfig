#include<dos.h>
#include<conio.h>
#include<iostream.h>
long Do,re,mi,fa,sol,la,si;
char k;

void geluid(void);
void oktaaf(int okt);
void main()
{
    int okt=1;
    do{
        clrscr();
        cout<<"Uw oktaaf="<<okt<<" druk + of - om te verhogen//verlagen";
        oktaaf(okt);
        geluid();
        if(k=='+')okt++;
        if(k=='-')okt--;
    }
    while(k!=27);
    cout<<"\nGedaan met spelen!!!";
    getch();
}
void geluid(void){
    int l=125;
    k=getch();
    if (k=='q'){sound(Do);delay(l);nosound();}
    if (k=='s'){sound(re);delay(l);nosound();}
    if (k=='d'){sound(mi);delay(l);nosound();}
    if (k=='f'){sound(fa);delay(l);nosound();}
    if (k=='g'){sound(sol);delay(l);nosound();}
    if (k=='h'){sound(la);delay(l);nosound();}
    if (k=='j'){sound(si);delay(l);nosound();}
}

void oktaaf(int okt)
{
    if (okt==1)
        {Do=8372;re=9397;mi=10548;fa=11175;sol=12544;la=14080;si=15804;}
    if (okt==2)
        {Do=4186;re=4699;mi=5274;fa=5588;sol=6272;la=7040;si=7902;}
    if (okt==3)
        {Do=2093;re=2349;mi=2637;fa=2794;sol=3136;la=3520;si=3951;}
    if (okt==4)
        {Do=1047;re=1175;mi=1319;fa=1397;sol=1568;la=1760;si=1976;}
    if (okt==5)
        {Do=523;re=587;mi=659;fa=698;sol=784;la=880;si=988;}
    if (okt==6)
        {Do=131;re=147;mi=165;fa=175;sol=196;la=220;si=247;}
    if (okt==7)
        {Do=65;re=73;mi=82;fa=87;sol=98;la=110;si=123;}
;}

