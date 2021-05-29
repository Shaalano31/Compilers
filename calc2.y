%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <stdarg.h>
    
    void yyerror(char *);
    int yylex(void);

    int sym[26];
%}

%union {
    int iValue;                 /* integer value */
    char sIndex;                /* symbol table index */
              /* node pointer */
};
%token <iValue>DIGITS <sIndex>VARIABLE INT BOOLEAN CHARACTER FLOAT CONSTANT DOUBLE STRING VOID
%token WHILE IF RETURN FOR REPEAT UNTIL SWITCH CASE BREAK DEFAULT CONTINUE INC DEC FLOATDIGIT

%nonassoc IFX
%nonassoc ELSE

%left GE LE EQ NE '>' '<' AND OR NOT
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
        ';'             { printf("semi \n");}
        | expr ';'      { printf("expr semi \n");}
        | declare       { printf("declare \n");}
        | const         { printf("const \n");}
        | if            { printf("if \n");}
        | while         { printf("while \n");}
        | for           { printf("for \n");}
        | BREAK ';'     { printf("BREAK \n");}        
        | CONTINUE ';'  { printf("CONTINUE \n");}
        | repeatuntil   { printf("repeatuntil \n");}
        | switch        { printf("switch \n");}
        |FunctionStmt  
        | VARIABLE '=' expr ';'  { printf("VARIABLE '=' expr; \n");}
        |'{' stmt_list '}'     { printf("DONE \n");}
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
        | VOID                  { printf("This is void \n");}
        ;

declare:
        identifier VARIABLE ';'         { printf("var is declared \n");}        
        | identifier VARIABLE '=' expr ';' { printf("var is declared with inital value \n");}
        ;

const:
        CONSTANT declare                { printf("this is a constant \n"); }
        ;

expr:
          DIGITS     { printf("digit "); }
        | FLOATDIGIT                              { printf("FLOATDIGIT "); } 
        | VARIABLE                                    { printf("var "); }
        | expr   PLUS   expr         { printf("expr + expr \n"); }
        | expr   '-'   expr         { printf("expr - expr \n"); }
        | expr   '*'   expr         { printf("expr * expr \n"); }
        | expr   '/'   expr         { printf("expr / expr \n"); }
        | incrementation ';'        { printf("incrementation\n"); }
        | '('   expr   ')'          { printf("(expr)\n"); }
        ;

comparisons:
          expr GE expr          { printf("expr GE expr \n"); }
        | expr LE expr          { printf("expr LE expr \n"); }
        | expr NE expr          { printf("expr NE expr \n"); }
        | expr EQ expr          { printf("expr EQ expr \n"); }
        | expr '<' expr         { printf("expr < expr \n"); }
        | expr '>' expr         { printf("expr > expr \n"); }
        | NOT expr              { printf("NOT expr \n"); }
        ;

condition:
        comparisons               { printf("compp \n"); }
        | VARIABLE                { printf("testing \n"); }
        | condition AND condition { printf("andddd \n"); }
        | condition OR condition  { printf("orrrr \n"); }
        ;

if:
        IF '(' condition ')' stmt %prec IFX         { printf("if condition \n"); }
        | IF '(' condition ')' stmt ELSE stmt       { printf("else condition \n"); }
        ;

while:
        WHILE '(' condition ')' stmt   
        ;

incrementation:
        VARIABLE INC             { printf("var++ \n"); }
        | VARIABLE DEC                  { printf("var-- \n"); }

        ;
preincrementation:
             VARIABLE "=" expr  { printf("VARIABLE = expr \n"); }
            | INC VARIABLE       { printf("++var \n"); }
            | DEC VARIABLE      { printf("--var \n"); }
            ;
forincrementation:
              incrementation
              |preincrementation
              ;

for:
        FOR '(' declare condition ';' forincrementation ')' stmt  
        ;

repeatuntil:
        REPEAT stmt UNTIL condition          
        ;

case:
        CASE DIGITS':' stmt BREAK ';' case
        |
        ;


switch:
        SWITCH '(' VARIABLE ')' case
        ;

argument:
        identifier VARIABLE arguments { printf("argument\n"); }
        |
        ;


arguments:  ',' identifier VARIABLE arguments { printf("arguments\n"); }
		|
		;
FunctionStmt:
                 
                 RETURN VARIABLE ';'
                | RETURN DIGITS ';'
                | RETURN ';'
                ;
function:
        identifier VARIABLE '(' argument ')'  stmt    { printf("Function\n"); }
        ;

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
    yyparse();
}
