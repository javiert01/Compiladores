%{
#include <string.h>
#include "analizadorS.tab.h"
num_lineas = 1;
%}
%x comentario
%%
"/*"         BEGIN(comentario);

<comentario>[^*\n]*       /* come todo lo que no sea '*' */
<comentario>"*"+[^*/\n]*  /* come '*'s no seguidos por '/' */
<comentario>\n           {/*printf("Numero de linea: %d\n",num_lineas++);*/ num_lineas++;}
<comentario>"*"+"/"       BEGIN(INITIAL);
int  {
           return T_INT;
     }
float  {
           return T_FLOAT;
       }
bool  {
           return T_BOOL;
      }
char  {
           return T_CHAR;
      }
string  {
           return T_STRING;
        }
main {
       return MAIN;
     }
if {
     return IF;
   }
then {
     return THEN;
   }
else {
     return ELSE;
   }
while {
     return WHILE;
   }
do {
     return DO;
   }
input {
     return INPUT;
   }
output {
     return OUTPUT;
   }
return {
     return RETURN;
   }  
true | 
false {
        return V_BOOL;
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

"$" {
     return CAR_ESPECIAL;
    }
"=" {
     return ASIGNACION;
    }
"+" {
      return SUM;
    }
"-" {
      return RES;
    }
"*" {
      return MULT;
    }
"/" {
     return DIV;
    }
"<" {
     return MAYOR;
    }
">" {
     return MENOR;
    }
"<=" {
     return MAYOR_IGUAL;
     } 
">=" {
     return MENOR_IGUAL;
    } 
"==" {
     return IGUAL;
    }
"!=" {
       return NO_IGUAL;
     }
"&&" |
"!"  |
"||" {
      return OP_LOG;
     }

[a-zA-Z_]+[a-zA-Z0-9_]*  {
                           return ID;
                         }
[-]?[0-9]+ { 
             return V_INT;
           }
[-]?[0-9]*[.][0-9]+ {
                      return V_FLOAT;
                    }
['].['] {
          return V_CHAR;
        }
["].*["] {
           return V_STRING;
         }
["/"]{2}.* {}
[\-]{2}.* {}
[" "] {}
\n {num_lineas++;}
. {printf("Error en linea %d\n ",num_lineas);}
%%
