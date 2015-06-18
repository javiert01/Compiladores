%{
#include <stdlib.h>
#include <stdio.h>
#define YYSTYPE char*
%}

%token TIPO_DATO ID ASIGNACION VALOR END DOS_PTOS COR_AB COR_CERR 

%%
var_global: TIPO_DATO DOS_PTOS ID END
           | TIPO_DATO ID ASIGNACION VALOR END
           | TIPO_DATO ID ASIGNACION ID END
;

vector: TIPO_DATO DOS_PTOS ID COR_AB VALOR COR_CERR END;

%%
int main() {
   yyparse();
}

yyerror (s)
     char *s;
{
  fprintf (stderr, "%s\n", s);
}

int yywrap()  
{  
   return 1;  
}  
 

