%{
#include <stdlib.h>
#include <stdio.h>
#define YYSTYPE char*
%}

%token TIPO_DATO ID ASIGNACION VALOR END PALABRA_RESERVADA BOOL CAR_ESPECIAL OP_COMPUESTO

%%
declar_var : TIPO_DATO ID END '\n'
           | TIPO_DATO ID ASIGNACION VALOR END '\n'
           | TIPO_DATO ID ASIGNACION ID END '\n' {printf("\n >>Declaracion de Variable\n");}
;

%%
int main(int argc,char *argv[])

{
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
