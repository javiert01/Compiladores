%{
#include <string.h>
#include "analizadorS.tab.h"
int num_lineas = 1;
%}
%x comentario
%%
"/*"         BEGIN(comentario);

<comentario>[^*\n]*       /* come todo lo que no sea '*' */
<comentario>"*"+[^*/\n]*  /* come '*'s no seguidos por '/' */
<comentario>\n           {/*printf("Numero de linea: %d\n",num_lineas++);*/ num_lineas++;}
<comentario>"*"+"/"       BEGIN(INITIAL);
int |
float |
bool |
char |
string {
         return TIPO_DATO;
       }
if |
then |
else | 
while |
do |
input |
output |
"return"  {
           return PALABRA_RESERVADA;} 
true | 
false {return BOOL;}
";" {return END;}
"," |
":" |
"(" |
")" |
"[" |
"]" |
"{" |
"}" |
"+" |
"-" |
"*" |
"/" |
"<" |
">" |
"!" |
"&" |
"$" {return CAR_ESPECIAL;}
"=" {return ASIGNACION;}
"<=" | 
">=" |
"==" |
"!=" |
"&&" |
"||" {return OP_COMPUESTO;}
[a-zA-Z_]+[a-zA-Z0-9_]* {return ID;}
[-]?[0-9]+ |
[-]?[0-9]*[.][0-9]+ |
['].['] |
["].*["] {return VALOR;}
["/"]{2}.* {}
[\-]{2}.* {}
[" "] {}
\n {num_lineas++;}
. {printf("Error en linea %d\n ",num_lineas);}
%%
int main(int argc,char *argv[])

{
 char NomArch[30];
 printf("Ingrese nombre de archivo: ");
 gets(NomArch);
 if ((yyin = fopen(NomArch, "rt")) == NULL)
 {
   printf("\nNo se puede abrir el archivo: %s\n", NomArch);
 }
 else
 {
   yylex();
 }
 fclose(yyin);
 //printf("El numero de lineas del codigo es:%d\n",num_lineas-1);

}
 
