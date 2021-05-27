%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <stdarg.h>
    void yyerror(char *);
    int yylex(void);

    int sym[26];
%}

%token DIGITS VARIABLE INT BOOLEAN CHARACTER FLOAT CONSTANT DOUBLE STRING VOID
%token WHILE IF RETURN FOR REPEAT UNTIL SWITCH CASE BREAK DEFAULT CONTINUE INC DEC

%nonassoc IFX
%nonassoc ELSE

%left GE LE EQ NE '>' '<' AND OR
%left PLUS '-'
%left '*' '/'
%nonassoc UMINUS
%%

program:
        program stmt
        | program function
        | /* NULL */
        ;

stmt:
        ';'{ printf("semi \n");}
        | expr ';' { printf("expr semi \n");}
        | declare  { printf("declare \n");}
        | const    { printf("const \n");}
        | if
        | while
        | for
        | case
        | repeatuntil
        | switch

        | VARIABLE '=' expr ';'
        | RETURN VARIABLE ';' { printf("return \n");}
        | '{' stmt_list '}'     { printf("DONE \n");}
        ;

stmt_list:
          stmt
        | stmt_list stmt
        ;

identifier:
        INT                     { printf("This is int \n");}
        | BOOLEAN               { printf("This is bool \n");}
        | CHARACTER             { printf("This is char \n");}
        | FLOAT                 { printf("This is float \n");}
        | DOUBLE                { printf("This is double \n");}
        | STRING                { printf("This is string \n");}
        | VOID
        ;

declare:
        identifier VARIABLE ';'
        | identifier VARIABLE '=' expr ';'
        ;

const:
        CONSTANT declare                { printf("this is a constant \n"); }
        ;

expr:
          DIGITS                                      { printf("digit "); }
        | VARIABLE                                    { printf("var "); }
        | expr   PLUS   expr         { printf("expr + expr \n"); }
        | expr   '-'   expr         { printf("expr - expr \n"); }
        | expr   '*'   expr         { printf("expr * expr \n"); }
        | expr   '/'   expr         { printf("expr / expr \n"); }
        | incrementation ';'
        | '('   expr   ')'          { printf("(expr)\n"); }
        ;

comparisons:
          expr GE expr          { printf("expr GE expr \n"); }
        | expr LE expr          { printf("expr LE expr \n"); }
        | expr NE expr          { printf("expr NE expr \n"); }
        | expr EQ expr          { printf("expr EQ expr \n"); }
        | expr '<' expr         { printf("expr < expr \n"); }
        | expr '>' expr         { printf("expr > expr \n"); }
        ;

condition:
        comparisons                                   { printf("compp \n"); }
        | VARIABLE                                    { printf("testing \n"); }
        | condition AND condition { printf("andddd \n"); }
        | condition OR condition  { printf("orrrr \n"); }
        ;

if:
        IF '(' condition ')' stmt %prec IFX         { printf("if condition \n"); }
        | IF '(' condition ')' stmt ELSE stmt       { printf("else condition \n"); }
        ;

while:
        WHILE '(' condition ')' stmt   { printf("while \n"); }
        ;

incrementation:
        VARIABLE INC
        | VARIABLE DEC

        ;
preincrementation:
              VARIABLE "=" expr
            | INC VARIABLE
            | DEC VARIABLE
            ;
forincrementation:
              incrementation
              |preincrementation
              ;

for:
        FOR '(' declare condition ';' forincrementation ')' stmt   { printf("for \n"); }
        ;

repeatuntil:
        REPEAT stmt UNTIL condition            { printf("repear until\n"); }
        ;

case:
        CASE DIGITS':' stmt BREAK ';'
        ;

switch:
        SWITCH '(' VARIABLE ')' stmt
        ;

argument:
        identifier VARIABLE arguments { printf("argument\n"); }
        |
        ;


arguments:  ',' identifier VARIABLE arguments { printf("arguments\n"); }
		|
		;

function:
        identifier VARIABLE '(' argument ')'  stmt    { printf("function\n"); }
        ;

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
    yyparse();
}
