%{
#include <stdlib.h>
#include <stdio.h>
#define YYSTYPE char*
extern FILE *yyin;
%}

%token ASIGNACION CAR_ESPECIAL COMA CORCH_AB CORCH_CERR DOS_PTOS DO 
END ELSE ID IF INPUT LLAV_AB LLAV_CERR MAYOR MENOR MAYOR_IGUAL MENOR_IGUAL IGUAL NO_IGUAL SUM RES MULT DIV 
OP_LOG OUTPUT PALABRA_RESERVADA PAR_AB PAR_CERR RETURN THEN WHILE MAIN V_INT V_FLOAT V_STRING V_BOOL V_CHAR 
T_INT T_FLOAT T_STRING T_BOOL T_CHAR  

%%
programa : principal funciones
         | principal
;
principal : T_INT MAIN PAR_AB PAR_CERR LLAV_AB cmd_simples LLAV_CERR
;
cmd_simples : cmd_simple
            | /* comando vacio*/
;
cmd_simple : atribucion END 
           | control_flujo 
           | llamada_func END
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
           | tipo_dato DOS_PTOS ID atribucion
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
  printf ("Error Sintactico %s\n", s);
}
int yywrap()  
{  
   return 1;  
} 

void yyerror (const char *s)
{
  fprintf(stderr, "%s line: %d",s, yylloc.first_line);
}

//desde esta linea
//prueba con yyerror para mostrar error en linea
//********************//
/*void yyerror(char *s)
{
  va_list ap;
  va_start(ap, s);
  
  if(yylloc.first_line)
  {
    fprintf(stderr, "%d.%d-%d.%d: error: ", yylloc.first_line, yylloc.first_column,
	    yyloc.last_line, yylloc.last_column);
	    
  }
  vfprintf(stderr, s, ap);
  fprintf(stderr, "\n");
}

void lyyerror(YYLTYPE t, char *s)
{
  va_list ap;
  va_start(ap, s);
  
  if(t.first_line)
  {
    fprintf(stderr, "%d.%d-%d.%d: error: ", t.first_line, t.first_column,
	    t.last_line, t.last_column);
	    
  }
  vfprintf(stderr, s, ap);
  fprintf(stderr, "\n");
}
void yyerror (char *s)
{
  fprintf (stderr, "Error Sintactico en linea %d:  %s\n", yylineno, s);
}
yyerror (char *s)
{
  printf ("Error Sintactico %s\n", s);
}*/
////*************************///////////
