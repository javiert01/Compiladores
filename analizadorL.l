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
int|float|bool|char|string {
                             return TIPO_DATO;
                           }
if|then|else|while |
do|input|output|return  {
                           return PALABRA_RESERVADA;
                        }  
true | 
false {
        return BOOL;
      }
";" {
      return END;
    }
":" {
      return DOS_PTOS;
    }
"[" { 
      return CORCH_AB;
    }
"]"  { 
      return CORCH_CERR;
    }
"," { return COMA;
    }
"(" { 
      return PAR_AB;
    }
")" { 
      return PAR_CERR;
    }
"{" {
      return LLAV_AB;
    }
"}" {
      return LLAV_CERR;
    }
"+" |
"-" |
"*" |
"/" |
"<" |
">" |
"!" |
"&" |
"$" {
     return CAR_ESPECIAL;
    }
"=" {
     return ASIGNACION;
    }
"<=" | 
">=" |
"==" |
"!=" |
"&&" |
"||" {
      return OP_COMPUESTO;
     }
[a-zA-Z_]+[a-zA-Z0-9_]*  {
                           return ID;
                         }
[-]?[0-9]+ |
[-]?[0-9]*[.][0-9]+ |
['].['] |
["].*["] {
           return VALOR;
         }
["/"]{2}.* {}
[\-]{2}.* {}
[" "] {}
\n {num_lineas++;}
. {printf("Error en linea %d\n ",num_lineas);}
%%

//este es un comentario nuevo
//este es un nuevo comentario XD
