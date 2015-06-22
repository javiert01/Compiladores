%{
#include <stdlib.h>
#include <stdio.h>
#define YYSTYPE char*
extern FILE *yyin;
extern char *yytext;
extern int num_lineas;
%}

%token ASIGNACION CAR_ESPECIAL COMA CORCH_AB CORCH_CERR DOS_PTOS DO 
END ELSE ID IF INPUT LLAV_AB LLAV_CERR MAYOR MENOR MAYOR_IGUAL MENOR_IGUAL IGUAL NO_IGUAL SUM RES MULT DIV OP_LOG OUTPUT PALABRA_RESERVADA PAR_AB PAR_CERR RETURN THEN WHILE MAIN V_INT V_FLOAT V_STRING V_BOOL V_CHAR T_INT T_FLOAT T_STRING T_BOOL T_CHAR  

%start programa

%%
programa : principal funciones
         | principal
;
principal : T_INT MAIN PAR_AB PAR_CERR LLAV_AB cmd_simples LLAV_CERR
;
cmd_simples : '\n'
            | cmd_simple {printf("%s >>Linea Correcta\n",yytext);}
            | error  { yyerrok;  } cmd_simple
;
cmd_simple : atribucion END 
           | control_flujo 
           | llamada_func END
           | declar_var END
           | declar_vec END
;
llamada_func : ID PAR_AB parametros PAR_CERR
;
parametros : par_f
           | /* vacio */
;
par_f : par COMA par
      | par
;
par : valor 
    | ID
;
valor : V_INT 
      | V_FLOAT
      | V_STRING 
      | V_BOOL 
      | V_CHAR
;
declar_var : tipo_dato DOS_PTOS ID
           | tipo_dato DOS_PTOS ID asignar_valor
;
declar_vec : tipo_dato DOS_PTOS ID CORCH_AB V_INT CORCH_CERR
;
tipo_dato : T_INT
          | T_FLOAT
          | T_BOOL
          | T_CHAR
          | T_STRING
;
asignar_valor : ASIGNACION expr_asg
              | ASIGNACION valor
              | ASIGNACION ID
;
expr_asg : expr_artm
     | llamada_func
;
expr_artm : expr_comun
          | expr_comun expr_complemento 
;
expr_comun : valor tipo_op valor
           | valor tipo_op ID 
           | ID tipo_op valor
           | ID tipo_op ID
;
tipo_op : SUM
        | RES
        | MULT
        | DIV
;
expr_complemento : expr_complemento operador_com
                 | operador_com
;
operador_com : tipo_op valor
             | tipo_op ID
;
atribucion : ID ASIGNACION c_valor
;
c_valor : valor
        | expr_asg
        | ID
;
control_flujo : condicion_if
              | condicion_while
;
condicion_if : condicion_simple
             | condicion_simple condicion_else
;
condicion_while : expr_while expr_do
                | expr_do expr_while 
;
condicion_simple : IF PAR_AB expr_log PAR_CERR THEN cmd_simples
;
expr_log : valor op_relacional valor
         | ID op_relacional ID
         | ID op_relacional valor
         | valor op_relacional ID
;
op_relacional : MAYOR
             | MENOR
             | MAYOR_IGUAL
             | MENOR_IGUAL
             | IGUAL
             | NO_IGUAL
;  
condicion_else : ELSE cmd_simples
;
expr_while : WHILE PAR_AB expr_log PAR_CERR 
;
expr_do : DO cmd_simples
;
funciones : funciones funcion
          | funcion
;
funcion : tipo_dato ID PAR_AB parametros PAR_CERR LLAV_AB cmd_simples LLAV_CERR
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
  extern int yylineno;
  printf ("%s\n", s);
  printf ("Error en línea: %d\n",num_lineas);
}
int yywrap()  
{  
   return 1;  
} 
