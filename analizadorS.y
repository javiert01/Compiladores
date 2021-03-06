%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#define YYSTYPE char*
extern FILE *yyin;
extern FILE *yyout;
extern char *yytext;
extern int yyleng;
extern int num_lineas;
%}

%token ASIGNACION CAR_ESPECIAL COMA CORCH_AB CORCH_CERR DOS_PTOS DO END ELSE ID IF INPUT LLAV_AB LLAV_CERR MAYOR MENOR MAYOR_IGUAL MENOR_IGUAL IGUAL NO_IGUAL SUM MENOS MULT DIV NOT OR AND OUTPUT PALABRA_RESERVADA PAR_AB PAR_CERR RETURN THEN WHILE MAIN V_INT V_FLOAT V_STRING V_BOOL V_CHAR T_INT T_FLOAT T_STRING T_BOOL T_CHAR  

%start programa

%%
programa : principal funciones 
         | principal 
;
principal : T_INT MAIN PAR_AB PAR_CERR LLAV_AB bloque_comando LLAV_CERR
;
bloque_comando : '\n'
            |
            | lineas {$$=$1;}
            | lineas error {yyerrok; } 
;
lineas : lineas cmd_simple {$$=$1,$2;} 
       | cmd_simple {$$=$1;}
;
cmd_simple : atribucion END {$$=$1;}
           | control_flujo  {$$=$1;}
           | llamada_func END {$$=$1;}
           | declar_var END   {$$=$1;}
           | declar_vec END   {$$=$1;}
           | return END       {$$=$1;}
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
    | tipo_dato DOS_PTOS ID
;
valor : V_INT {$$ = strdup(yytext);} 
      | V_FLOAT
      | V_STRING 
      | V_BOOL 
      | V_CHAR
;
declar_var : tipo_dato DOS_PTOS ID {$$=$1,$2,$3;}
           | tipo_dato DOS_PTOS ID asignar_valor
;
declar_vec : tipo_dato DOS_PTOS ID CORCH_AB V_INT CORCH_CERR
           | tipo_dato DOS_PTOS ID CORCH_AB V_INT CORCH_CERR asignar_valor
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
     | expr_log
;
expr_artm : expr_comun
          | expr_comun expr_complemento 
;
expr_comun : valor tipo_op valor {fprintf(yyout,"li $a0 %s \nsw $a0 0($sp) \naddiu $sp $sp -4 \nli $a0 %s \nlw $t1 4($sp) \n%s $a0 $t1 $a0\naddiu $sp $sp 4\n",$1,$3,$2);} 
           | valor tipo_op ID 
           | ID tipo_op valor
           | ID tipo_op ID
;
tipo_op : MENOS {$$="sub";}
        | SUM {$$="add";}
        | MULT
        | DIV
;
expr_complemento : expr_complemento operador_com
                 | operador_com
;
operador_com : tipo_op valor {fprintf(yyout,"sw $a0 0($sp) \naddiu $sp $sp -4 \nli $a0 %s \nlw $t1 4($sp) \n%s $a0 $t1 $a0\naddiu $sp $sp 4\n",$2,$1);} 
             | tipo_op ID
;
atribucion : ID ASIGNACION c_valor
           | ID CORCH_AB V_INT CORCH_CERR ASIGNACION c_valor
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
condicion_simple : IF PAR_AB expr_log PAR_CERR THEN bloque_comando {fprintf(yyout,"beq $a0 1 true_branch \nfalse_branch: b end_if \ntrue_branch:%s\nend_if",$6);} 
;
expr_log : valor op_relacional valor {fprintf(yyout,"li $a0 %s \nsw $a0 0($sp) \naddiu $sp $sp -4 \nli $a0 %s \nlw $t1 4($sp) \n%s $a0 $t1 $a0\naddiu $sp $sp 4\n",$1,$3,$2);}
         | ID op_relacional ID
         | ID op_relacional valor
         | valor op_relacional ID
         | expr_log op_logico expr_log
;
op_relacional : MAYOR {$$="sgt";}
             | MENOR {$$="slt";}
             | MAYOR_IGUAL {$$="sge";}
             | MENOR_IGUAL {$$="sle";}
             | IGUAL {$$="seq";}
             | NO_IGUAL {$$="sne";}
;  
op_logico : AND {$$="and";}
          | OR {$$="or";}
          | NOT
;
condicion_else : ELSE bloque_comando
;
expr_while : WHILE PAR_AB expr_log PAR_CERR 
;
expr_do : DO bloque_comando
;
funciones : funciones funcion 
          | funcion 
;
funcion : tipo_dato ID PAR_AB parametros PAR_CERR LLAV_AB bloque_comando LLAV_CERR
;
return: RETURN ID
      | RETURN valor
;

%%
int main(int argc,char **argv) {
   if(argc>1)
     yyin=fopen(argv[1],"rt");
   else
   yyin=fopen("codigo1.txt","rt");
   yyout = fopen("codigoGenerado.txt", "w");
   yyparse();
   return 0;
}
yyerror (char *s)
{
  printf ("%s\n", s);
  printf ("Error en lÃ­nea: %d\n",num_lineas);
}
int yywrap()  
{  
   return 1;  
} 

