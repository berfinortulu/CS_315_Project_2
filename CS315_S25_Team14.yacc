%{
#include <stdio.h>
%}

%union {
    float fval;
    char* sval;
}

%token REAL ROOT MAIN IF ELIF ELSE DO WHILE FOR_EACH FOR FUNC RETURN PRINT INPUT IN
%token PLUS MINUS MUL DIV MOD EXPONENT REFERANCE AND OR NOT EQ NEQ GEQ LEQ GT LT
%token LP RP LCURLY RCURLY LBRACE RBRACE COMMA SEMI ASSIGN INPUT_OP
%token IRRATIONAL_NUMBER
%token NEWLINE
%token MULTI_LINE_COMMENT_START MULTI_LINE_COMMENT_END COMMENT

%token <fval> NUMBER
%token <sval> IDENTIFIER STRING_LITERAL

%left OR
%left AND
%left EQ NEQ
%left GT LT GEQ LEQ
%left PLUS MINUS
%left MUL DIV MOD
%right EXPONENT
%right NOT

%nonassoc IDENTIFIER_PREC

%%

program: global_declarations MAIN LP RP LCURLY stmt_list RCURLY global_declarations
       ;

global_declarations: global_declaration global_declarations
                   | /* empty */
                   ;

global_declaration: func_def
                  | var_declaration SEMI
                  ;       

stmt_list: stmt stmt_list
         | /* empty */
         ;

stmt: var_declaration SEMI
    | arr_declaration SEMI 
    | assignment SEMI
    | print_stmt SEMI
    | input_stmt SEMI
    | conditional_stmt
    | loop_stmt
    | func_def
    | function_call SEMI
    | return_stmt SEMI
    ;

var_declaration: REAL IDENTIFIER opt_assignment opt_identifier_list
               ;

opt_assignment: ASSIGN expression
              | /* empty */
              ;

opt_identifier_list: COMMA identifier_with_opt_assignment opt_identifier_list
                   | /* empty */
                   ;

identifier_with_opt_assignment: IDENTIFIER opt_assignment
                              ;

arr_declaration:  REAL IDENTIFIER LBRACE NUMBER RBRACE
		| REAL IDENTIFIER LBRACE RBRACE ASSIGN LBRACE expression_list RBRACE
		| REAL IDENTIFIER LBRACE NUMBER RBRACE ASSIGN LBRACE expression_list RBRACE
		;

assignment: IDENTIFIER ASSIGN expression
          | IDENTIFIER LBRACE expression RBRACE ASSIGN expression /* Array assignment */
          ;

print_stmt: PRINT LP expression_list RP
          ;

input_stmt: IDENTIFIER ASSIGN INPUT_OP
          | INPUT LP STRING_LITERAL INPUT_OP IDENTIFIER RP
          ;

expression: NUMBER
          | IRRATIONAL_NUMBER
          | STRING_LITERAL
          | IDENTIFIER  %prec IDENTIFIER_PREC 
          | IDENTIFIER LBRACE expression RBRACE 
          | IDENTIFIER LP argument_list RP 
          | expression PLUS expression
          | expression MINUS expression
          | expression MUL expression
          | expression DIV expression
          | expression MOD expression
          | expression EXPONENT expression
          | ROOT LP argument_list RP 
          | PLUS expression %prec NOT   
          | MINUS expression %prec NOT  
          | LP expression RP
          ;

expression_list: expression
		| expression COMMA expression_list
		;

conditional_stmt: IF LP condition RP LCURLY stmt_list RCURLY elif_stmt else_stmt
                ;

elif_stmt: ELIF LP condition RP LCURLY stmt_list RCURLY elif_stmt
         | /* empty */
         ;

else_stmt: ELSE LCURLY stmt_list RCURLY
         | /* empty */
         ;

boolean_expr: boolean_expr OR boolean_expr
            | boolean_expr AND boolean_expr
            | NOT expression
            | NOT boolean_expr
            | expression EQ expression
            | expression NEQ expression
            | expression GT expression
            | expression LT expression
            | expression GEQ expression
            | expression LEQ expression
            | LP boolean_expr RP
            ;

condition: expression
         | boolean_expr
         ;

loop_stmt: WHILE LP condition RP LCURLY stmt_list RCURLY
         | FOR_EACH LP REAL IDENTIFIER IN IDENTIFIER RP LCURLY stmt_list RCURLY
         | FOR_EACH LP IDENTIFIER IN IDENTIFIER RP LCURLY stmt_list RCURLY
         | FOR LP assignment SEMI condition SEMI assignment RP LCURLY stmt_list RCURLY
         | FOR LP var_declaration SEMI condition SEMI assignment RP LCURLY stmt_list RCURLY
         | DO LCURLY stmt_list RCURLY WHILE LP condition RP SEMI
         ;

func_def: FUNC IDENTIFIER LP param_list RP LCURLY stmt_list RCURLY
        ;

param_list: param COMMA param_list
          | param
          | /* empty */
          ;

param: REAL IDENTIFIER
     | REAL REFERANCE IDENTIFIER  
     ;

function_call: IDENTIFIER LP argument_list RP
             ;

argument_list: argument
             | argument COMMA argument_list
             | /* empty */
             ;

argument: expression
        | array_argument
        ;

array_argument: IDENTIFIER LBRACE RBRACE
              ;

return_stmt: RETURN expression
	   | RETURN
	   ;

%%

#include "lex.yy.c"

extern int yylineno;

void yyerror(char *s) {
	fprintf(stderr, "Error on line %d: %s\n", yylineno, s);
}

int main() {
    if (yyparse() == 0){
        printf("Input program is valid\n");
    } else {
        printf("Input program is invalid\n");
    }
    return 0;
}
