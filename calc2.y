%{
    #include <stdio.h>
    void yyerror(char *);
    int yylex(void);

    int sym[26];
%}

%token DIGITS VARIABLE INT BOOLEAN CHARACTER FLOAT CONSTANT DOUBLE STRING
%token WHILE IF PRINT
%nonassoc ELSE
%left '+' '-'
%left '*' '/'
%left GE LE EQ NE '>' '<' ASSIGNMENT

%%

program:
        program assignment '\n'
        | /* NULL */
        ;

stmt:
        declare 
        | const
        | VARIABLE "=" expr
        ;

declare:
        INT VARIABLE ';'                { printf("This is int \n"); }
        | BOOLEAN VARIABLE ';'          { printf("This is bool \n"); }
        | CHARACTER VARIABLE ';'        { printf("This is char \n"); }
        | FLOAT VARIABLE ';'            { printf("This is float \n"); }    
        ;

const:
        CONSTANT declare                { printf("this is a constant \n"); }
        ;

assignment:
            INT '=' INT  ";"            { printf("assignment \n"); }
            ;

expr:
          DIGITS                { printf("digit "); }
        | VARIABLE              { printf("var "); }
        | expr '+' expr         { printf("expr + expr \n"); }
        | expr '-' expr         { printf("expr - expr \n"); }
        | expr '*' expr         { printf("expr * expr \n"); }
        | expr '/' expr         { printf("expr / expr \n"); }
        | expr '<' expr         { printf("expr < expr \n"); }
        | expr '>' expr         { printf("expr > expr \n"); }
        | expr GE expr          { printf("expr GE expr \n"); }
        | expr LE expr          { printf("expr LE expr \n"); }
        | expr NE expr          { printf("expr NE expr \n"); }
        | expr EQ expr          { printf("expr EQ expr \n"); }
        | '(' expr ')'          { printf("(expr)\n"); }
        ;
         

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
    yyparse();
}
