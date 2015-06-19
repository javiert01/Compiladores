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

vector: TIPO_DATO DOS_PTOS ID COR_AB VALOR COR_CERR END
;

op_valor   	: MAYORQ
           	| MENORQ
           	| OP_COMPUESTO
;
	

expr 		: ID op_valor ID
		| ID op_valor VALOR
		| BOOL
;

sent_control_if 	: IF ABR_PAR expr CIERRA_PAR
			| IF ABR_PAR expr CIERRA_PAR 
;

sent_control_while	: WHILE ABR_PAR expr CIERRA_PAR
;

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
 

