%{
#include "stdio.h"
#include "stdlib.h"
int i;
int valorcad;
int valoriden;
char *charaux;
int auxi=0;
int auxic=0;
int auxis=0; //cadenas
int componente5=0;  //aux símbolos especiales
int componente2=0; //asignación
int componente3=0; //relacionales
int componente4=0;
int componente1=0; //Palabras Reservadas
FILE *archlex;


typedef struct clase{
	char* componente;
	float valor;
	struct clase *sig;
	int clas;
}Clase;
typedef Clase* ptr_Clase;
	ptr_Clase in[9]={NULL}; //inicio clases
	ptr_Clase fi[9]={NULL}; //fin clases


typedef struct token{
	int clase;
	float valor;
	struct token *sig;
}Token;
typedef Token* ptr_Token;

Token* intok;
ptr_Token fntok;
Clase* add(Clase *final,char *b){
	final->sig=(Clase*)malloc(sizeof(Clase));
	final->sig->componente=b;
	final->sig->sig=NULL;
	final=final->sig;
	return final;
}

Token* creaToken(int clase,float valor,ptr_Token tok){
	Token* aux;
	aux=tok;
	aux->sig=(Token*)malloc(sizeof(Token));
	aux->sig->clase=clase;
	aux->sig->valor=valor;
	aux->sig->sig=NULL;
	aux=aux->sig;
	return aux;	
}

Clase* addt(Clase *final,char *b){

	char *straux = (char*) calloc(sizeof(char), strlen(b)+1); 
	final->sig=(Clase*)malloc(sizeof(Clase));
	straux = strcpy(straux, b);
	final->sig->clas=final->clas;
	final->sig->componente=straux;
	if (final->clas==8/*cadenas*/) final->sig->valor=++auxis; 
    //else if (final->clas==)
    //Símbolos especiales
	    else if (final->clas==5||final->clas==2) final->sig->valor=(float)(*b); 
		    //relacionales
			    else if (final->clas==3) final->sig->valor=++componente3;
			    //aritméticos 
				    else if (final->clas==4) final->sig->valor=++componente4; 
				    //palabras reservadas
				    	else if (final->clas==1) final->sig->valor=++componente1; 
						    /*identificadores*/
							else final->sig->valor=++auxi;
	final->sig->sig=NULL;
	final=final->sig;

	return final;
}
int search(Clase *inicio, char *buscado){
     int i=0;
     ptr_Clase aux;
     aux=(Clase*)malloc(sizeof(Clase));
     aux=inicio->sig;
	     while(aux!=NULL){

	     	if (strcmp(buscado,aux->componente)==0) return 1;
			else 
			aux=aux->sig;
	     }
	 return 0;
}


void printTok(ptr_Token tok){
printf("Imprimiendo Tokens:\n");
ptr_Token aux=(Token*)malloc(sizeof(Token));
    aux=tok->sig;
	while(aux->sig!=NULL){
		printf("(%d,%.1f)\n",aux->clase,aux->valor);
		aux=aux->sig;		
	}
}
void print(Clase *inicio){
     ptr_Clase aux;
     aux=(Clase*)malloc(sizeof(Clase));
     aux=inicio->sig;
     printf(   "valor        componente	 	    Tipo   \n");
	     while(aux!=NULL){
	        printf("%.2f         %s\n",aux->valor,aux->componente);
	   		aux=aux->sig;
	     }
}
Clase *addtcons(ptr_Clase final,char *b){
	char *straux = (char*) calloc(sizeof(char), strlen(b)+1); 
	final->sig=(Clase*)malloc(sizeof(Clase));
	straux = strcpy(straux, b);
	final->sig->componente=straux;
	final->sig->clas=final->clas;
	final->sig->valor=atof(b);
	if (final->sig->valor==0 && final->sig->componente!=0) final->sig->valor=(int) *straux;
	printf("valor=%.2f\n",final->sig->valor);
	final->sig->sig=NULL;
	final=final->sig;
	return final;
}

/*Función para imprimir tokens*/
/*char ffoken(float valor){
	
}*/
%}
iden [a-z]+
palRes (ENT|ESCRIBE|HAZ|LEE|MIENTRAS|REAL|SI|SINO)
opAsig =
opRel (<=|>=|<|>|!=|==)
opArit (DIVIDE|MAS|MENOS|MULTIPLICA)
simEsp (,|;|\[|\]|\)|\()
ent [1-9]
consEnt ({ent}({ent}|0)*)|0
consReal (0?\.({consEnt}|0)*)|({consEnt}\.({consEnt}|0)*)
consCad \".*\"
esp [ ]
salto \n
com $$(.*)
%%
{iden} {printf("%s es un identificador (clase 0)\n",yytext);
	if (search(in[0],yytext)==1); //encontró coincidencia
		else fi[0]=addt(fi[0],yytext);
	fntok=creaToken(fi[0]->clas,fi[0]->valor,fntok);
	fprintf(archlex,"a");
	//print(in[0]);
}
{palRes} {
		//printf("%s es una palabra reservada (clase 1)\n",yytext);
	  	fntok=creaToken(fi[1]->clas,fi[1]->valor,fntok);
}
{opAsig} {
		//printf("%s es un operador de asignación (clase 2)\n",yytext);
		  fntok=creaToken(fi[2]->clas,fi[2]->valor,fntok);
         	  fprintf(archlex,"%c",(char)fi[2]->valor);
}
{opRel} {
		//printf("%s es un operador relacional (clase 3)\n",yytext);
		  fntok=creaToken(fi[3]->clas,fi[3]->valor,fntok);

}
{opArit} {
		//printf("%s es un operador aritmético (clase 4)\n",yytext);
			fntok=creaToken(fi[4]->clas,fi[4]->valor,fntok);
}	
{simEsp} {
		//printf("%s es un símbolo especial (clase 5)\n",yytext);
			fntok=creaToken(fi[5]->clas,fi[5]->valor,fntok);
         	  	fprintf(archlex,"%c",(char)fi[5]->valor);
}
{consEnt} {
		//printf("%s es una constante entera (clase 6)\n",yytext);
	if (search(in[6],yytext)==1); //encontró coincidencia
	else fi[6]=addtcons(fi[6],yytext);
	fntok=creaToken(fi[6]->clas,fi[6]->valor,fntok);
	fprintf(archlex,"c");
}
{consReal} {
		//printf("%s es una constante real (clase 7)\n",yytext);
	if (search(in[7],yytext)==1); //encontró coincidencia
	else fi[7]=addtcons(fi[7],yytext);
	fntok=creaToken(fi[7]->clas,fi[7]->valor,fntok);
	fprintf(archlex,"n");
}
{consCad} {
		//printf("%s es una constante cadena (clase 8)\n",yytext);
			if (search(in[8],yytext)==1); //encontró coincidencia
			else fi[8]=addt(fi[8],yytext);
			fntok=creaToken(fi[8]->clas,fi[8]->valor,fntok);
			fprintf(archlex,"s");
}	
{esp} {}
{com} {/*printf("%s es Comentario\n",yytext);*/}
{salto} {}
. {printf("Error: %s no pertenece\n",yytext);
}
%%
int main(int argc, char *argv[]){

    archlex = fopen("lex.txt","w");
	//Creando token inicial
    intok=(Token*)malloc(sizeof(Token));
    fntok=intok;
	/*Creando tablas clases*/
	for (i=0;i<9;i++){
	in[i]=(Clase*)malloc(sizeof(Clase));
	in[i]->clas=i;
	fi[i]=in[i];
	}
	/*Clase 1 Palabras reservadas*/
	fi[1]=addt(fi[1],"ENT");
	fi[1]=addt(fi[1],"ESCRIBE");
	fi[1]=addt(fi[1],"HAZ");
	fi[1]=addt(fi[1],"LEE");
	fi[1]=addt(fi[1],"REAL");
	fi[1]=addt(fi[1],"SI");
	fi[1]=addt(fi[1],"SINO");
	/*Clase 2: Operador de asignación*/
	fi[2]=addt(fi[2],"=");
	/*Clase 3: Operadores relacionales*/
	fi[3]=addt(fi[3],">"); 
	fi[3]=addt(fi[3],">=");
	fi[3]=addt(fi[3],"<");	
	fi[3]=addt(fi[3],"<=");
	fi[3]=addt(fi[3],"==");
	fi[3]=addt(fi[3],"!=");
	/*Clase 4: Operadores de artméticos*/
	fi[4]=addt(fi[4],"DIVIDE");
	fi[4]=addt(fi[4],"MAS");
	fi[4]=addt(fi[4],"MENOS");
	fi[4]=addt(fi[4],"MULTIPLICA");
	/*Clase 5: Símbolos especiales*/
	fi[5]=addt(fi[5],"[");
	fi[5]=addt(fi[5],"]");
	fi[5]=addt(fi[5],"(");
	fi[5]=addt(fi[5],")");
	fi[5]=addt(fi[5],";");
	fi[5]=addt(fi[5],",");

	yyin=fopen(argv[1],"r");
		yylex();
		for(i=0;i<9;i++){
		printf("Mostrando clase %d\n",i);
		print(in[i]);
		}	
	printTok(intok);

}
