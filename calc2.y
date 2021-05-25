%{
    #include <stdio.h>
    void yyerror(char *);
    int yylex(void);

    int sym[26];
%}

%token DIGITS VARIABLE INT BOOLEAN CHARACTER FLOAT CONSTANT DOUBLE STRING
%token WHILE IF PRINT AND OR FOR REPEAT UNTIL SWITCH CASE BREAK DEFAULT CONTINUE
%nonassoc ELSE INC DEC
%left '+' '-' 
%left '*' '/'
%left GE LE EQ NE '>' '<' ASSIGNMENT

%%

program:
        program stmt
        | /* NULL */
        ;

stmt:        
        declare 
        | const
        | if
        | while
        | for
        | case
        | repeatuntil
        | switch
        | '{' stmt_list '}'
        ;

stmt_list:
          stmt                  
        | stmt_list stmt
        ;

declare:
        INT   VARIABLE ';'                { printf("This is int \n"); }
        | BOOLEAN   VARIABLE ';'          { printf("This is bool \n"); }
        | CHARACTER   VARIABLE ';'        { printf("This is char \n"); }
        | FLOAT   VARIABLE ';'            { printf("This is float \n"); }    
        ;

const:
        CONSTANT declare                { printf("this is a constant \n"); }
        ;

assignment:
            INT '=' INT  ';'            { printf("assignment \n"); }
            ;

expr:
          DIGITS                                      { printf("digit "); }
        | VARIABLE                                    { printf("var "); }
        | expr   '+'   expr         { printf("expr + expr \n"); }
        | expr   '-'   expr         { printf("expr - expr \n"); }
        | expr   '*'   expr         { printf("expr * expr \n"); }
        | expr   '/'   expr         { printf("expr / expr \n"); }
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
        | VARIABLE                                        { printf("testing \n"); }
        | condition AND condition { printf("andddd \n"); }
        | condition OR condition  { printf("orrrr \n"); }
        ;

if:
        IF '(' condition ')' stmt        { printf("if condition \n"); }
        | IF '(' condition ')' stmt ELSE stmt       { printf("else condition \n"); }
        ;

while:
        WHILE '(' condition ')' stmt   { printf("while \n"); }
        ;     

incrementation:
        VARIABLE INC
        | VARIABLE DEC
        | VARIABLE "=" expr
        ;

for: 
        FOR '(' declare condition ';' incrementation ')' stmt   { printf("for \n"); }
        ;

repeatuntil:
        REPEAT stmt UNTIL condition                             { printf("repear until\n"); }
        ;

case:
        CASE DIGITS':' stmt BREAK ';'
        ;

switch:
        SWITCH '(' VARIABLE ')' stmt                     
        ;

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
    yyparse();
}
