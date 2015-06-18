%{
#include <stdlib.h>
#include <stdio.h>
#define YYSTYPE char*
%}

%token TIPO_DATO ID ASIGNACION VALOR END

%%
declar_var : TIPO_DATO ID END
           | TIPO_DATO ID ASIGNACION VALOR END
           | TIPO_DATO ID ASIGNACION ID END
;

%%
int main() {
   yyparse();
}

yyerror (char *s)
{
  printf ("%s\n", s);
}

int yywrap()  
{  
   return 1;  
}  
 
