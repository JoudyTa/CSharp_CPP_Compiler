%{
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
    #include<ctype.h>
    // #include"lex.yy.c"
    
    void yyerror(const char *s);
    int yylex();
    int yywrap();
%}

%token VOID CHARACTER PRINTFF SCANFF INT FLOAT CHAR FOR IF ELSE TRUE FALSE NUMBER FLOAT_NUM ID LE GE EQ NE GT LT AND OR STR ADD MULTIPLY DIVIDE SUBTRACT UNARY INCLUDE RETURN DO WHILE SWITCH COMMA

%%
include:headers program
;

program: function  main '(' ')' '{' body return '}' 
;


function: main '(' parameter ')' '{' body return '}' function
|
;

parameter: datatype ID init  
|parameter COMMA parameter
|
;
    


headers: headers headers
| INCLUDE
;

main: datatype ID
;

datatype: INT 
| FLOAT 
| CHAR
| VOID
;

for:FOR '(' statement ';' condition ';' statement ')' '{' body '}'
| FOR '(' statement ';' condition ';' statement ')' statement ';'
;
if:IF '(' condition ')' '{' body '}' else
| IF '(' condition ')' '{'body'}'
| IF '(' condition ')' statement ';'
body: for
| if
| statement ';' 
| body body
| PRINTFF '(' STR ')' ';'
| SCANFF '(' STR ',' '&' ID ')' ';'
| ID '('rePa ')' ';'
| ID '(' ')' ';'
|
;
rePa:value
|rePa COMMA rePa
;

else: ELSE '{' body '}'
|
;

condition: value relop value 
| TRUE 
| FALSE
;

statement: datatype ID init {printf("Number Value= %d\n");}
| ID '=' expression 
| ID relop expression
| ID UNARY 
| UNARY ID
;

declaration: datatype ID '=' value
| datatype ID '=' expression 
| datatype ID
;

init: '=' value 
|
;

expression: expression arithmetic expression
| value
;

arithmetic: ADD 
| SUBTRACT 
| MULTIPLY
| DIVIDE
;

relog: OR 
| AND
;

logical: logical relog logical 
|value
|expression 
;

relop: LT
| GT
| LE
| GE
| EQ
| NE
;

value: NUMBER {printf("Number Value= %d\n");}
| FLOAT_NUM
| CHARACTER
| ID
| ID '('rePa ')'';'
| ID '(' ')'';'
;

return: RETURN value ';' 
|RETURN expression ';'
|RETURN ';'
;

%%

int main() {
  return  yyparse();
}

void yyerror(const char* msg) {
    fprintf(stderr, "%s\n", msg);
}