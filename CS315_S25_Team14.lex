%option yylineno

%{
#include <stdio.h>
%}

DIGIT        [0-9]
LETTER       [a-zA-Z]
ID           {LETTER}({LETTER}|{DIGIT})*
NUMBER       {DIGIT}+(\.{DIGIT}+)?([eE][-+]?{DIGIT}+)?  
STRING_LITERAL  \"[^\"]*\"  
WS           [ \t]+
NEWLINE      \n  

%x MULTI_COMMENT  

%%

"REAL"            { return REAL; }
"root"            { return ROOT; }
"main"            { return MAIN; }
"if"              { return IF; }
"elif"            { return ELIF; }
"else"            { return ELSE; }
"do"              { return DO; }
"while"           { return WHILE; }
"for_each"        { return FOR_EACH; }
"for"             { return FOR; }
"func"            { return FUNC; }
"return"          { return RETURN; }
"print"           { return PRINT; }
"input"           { return INPUT; }
"in"              { return IN; }

"+"               { return PLUS; }
"-"               { return MINUS; }
"*"               { return MUL; }
"/"               { return DIV; }
"%"               { return MOD; }
"^"               { return EXPONENT; }
"&"               { return REFERANCE; }
"&&"              { return AND; }
"||"              { return OR; }
"!"               { return NOT; }
"=="              { return EQ; }
"!="              { return NEQ; }
">="              { return GEQ; }
">>"              { return INPUT_OP; }
"<="              { return LEQ; }
">"               { return GT; }
"<"               { return LT; }

"("               { return LP; }
")"               { return RP; }
"{"               { return LCURLY; }
"}"               { return RCURLY; }
"["               { return LBRACE; }
"]"               { return RBRACE; }
","               { return COMMA; }
";"               { return SEMI; }

"="               { return ASSIGN; }

{NUMBER}          { yylval.fval = atof(yytext); return NUMBER; }
("pi"|"e")        { return IRRATIONAL_NUMBER; }
{ID}              { yylval.sval = strdup(yytext); return IDENTIFIER; }
{STRING_LITERAL}  { yylval.sval = strdup(yytext); return STRING_LITERAL; }

"%%"([^%\n]|%[^%])*"%%"  { /* ignore single-line comments */ }

"%+%"             { BEGIN(MULTI_COMMENT); }
<MULTI_COMMENT>"%+%"       { BEGIN(INITIAL); }
<MULTI_COMMENT>\n          { yylineno++; }
<MULTI_COMMENT>.            { /* ignore comment content */ }

{WS}              { /* Ignore Whitespace */ }
{NEWLINE}         { /* yylineno auto-updated by lex */ }

%%
int yywrap() {return 1;}
