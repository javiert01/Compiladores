%{
#include <stdlib.h>
#include <stdio.h>
#define YYSTYPE char*
extern FILE *yyin;
%}

%token TIPO_DATO ID ASIGNACION VALOR END PALABRA_RESERVADA BOOL CAR_ESPECIAL OP_COMPUESTO DOS_PTOS PAR_AB PAR_CERR COMA
CORCH_AB CORCH_CERR LLAV_AB LLAV_CERR OPERADOR OP_AR OP_REL OP_LOG IF THEN DO WHILE ELSE INPUT OUTPUT RETURN

%%
linea: '\n'
      | error '\n' {yyerrorok;}
;
variable: TIPO_DATO DOS_PTOS ID
;
var_global : variable END
           
;
vector : variable CORCH_AB VALOR CORCH_CERR
;
funcion : encabezado bloque_comando
;
encabezado : TIPO_DATO DOS_PTOS ID PAR_AB lista PAR_CERR
           | TIPO_DATO DOS_PTOS ID PAR_AB PAR_CERR
;
lista : variable
       | lista COMA variable
;
listaDecl : var_global
          | listaDecl '\n' var_global
;
bloque_comando : LLAV_AB secuencia LLAV_CERR
;
secuencia : 
           | com_sim 
           | secuencia END com_sim
;
com_sim : atrb 
        | control_flujo
        | listaDecl
        | llamada_func
        | bloque_comando
        | op_salida
        | op_entrada
        | op_retorno
;
atrb: variable ASIGNACION expr
     | variable CORCH_AB expr CORCH_CERR ASIGNACION expr 
;

expr : expr_ar
     | expr_log
;
expr_ar : VALOR OP_AR VALOR
         | VALOR OP_AR ID
         | ID OP_AR ID
         | ID OP_AR VALOR
         | expr_ar OP_AR expr_ar
;
expr_log : expr_ar OP_REL expr_ar
          | expr_log OP_LOG expr_log
          | VALOR OP_REL VALOR
          | VALOR OP_REL ID
          | ID OP_REL ID
          | ID OP_REL VALOR
;
control_flujo : IF PAR_AB expr_log PAR_CERR THEN com_sim
              | IF PAR_AB expr_log PAR_CERR THEN com_sim ELSE com_sim
              | WHILE PAR_AB expr_log PAR_CERR DO com_sim
              | DO com_sim WHILE PAR_AB expr_log PAR_CERR
;
llamada_func : ID PAR_AB ID PAR_CERR 
;
op_entrada: INPUT PAR_AB ID PAR_CERR END
; 
op_salida : OUTPUT PAR_AB expr PAR_CERR END
          | OUTPUT PAR_AB VALOR PAR_CERR END
;
op_retorno : RETURN PAR_AB expr PAR_CERR END
           | RETURN VALOR END
           | RETURN ID END
;


%%
int main(int argc,char **argv) {
   if(argc>1)
     yyin=fopen(argv[1],"rt");
   else
   yyin=fopen("codigo.txt","rt");
   yyparse();
   return 0;
}

yyerror (char *s)
{
  printf ("Error Sintactico %s\n", s);
}

int yywrap()  
{  
   return 1;  
}   
 
