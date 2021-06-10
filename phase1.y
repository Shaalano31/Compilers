%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <stdarg.h>
    #include "calc2.h"
    
    /* prototypes */
        nodeType *opr(int oper, int nops, ...);
        nodeType *id(int i);
        nodeType *con(int value);
        void freeNode(nodeType *p);
        int ex(nodeType *p);
        int yylex(void);
        void yyerror(char *);
    

    int sym[26];
%}

%union {
    int iValue;                 /* integer value */
    char sIndex;                /* symbol table index */
    nodeType *nPtr;         /* node pointer */
};
%token <iValue>DIGITS 
%token <sIndex>VARIABLE 
%token <iValue>FLOATDIGIT
%token WHILE IF RETURN FOR REPEAT UNTIL SWITCH CASE BREAK DEFAULT CONTINUE INC DEC INT BOOLEAN CHARACTER FLOAT CONSTANT DOUBLE STRING VOID BOOL_VALUES


%nonassoc IFX
%nonassoc ELSE

%left GE LE EQ NE '>' '<' AND OR NOT
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS

%type <nPtr> stmt expr stmt_list comparisons if while condition incrementation preincrementation for declare forincrementation
%%

program:
        program stmt        { ex($2); freeNode($2); }
        | program function
        | /* NULL */
        ;

stmt:
        ';'             { $$ = opr(';', 2, NULL, NULL); }
        | expr ';'      { $$ = $1; }
        | declare       { printf("declare \n");}
        | const         { printf("const \n");}
        | if            { printf("if \n");}
        | while         { printf("while \n");}
        | for           //{ printf("for \n");}
        | BREAK ';'     { printf("BREAK \n");}        
        | CONTINUE ';'  { printf("CONTINUE \n");}
        | repeatuntil   { printf("repeatuntil \n");}
        | switch        { printf("switch \n");}
        //| FunctionStmt  
        | VARIABLE '=' expr ';' { $$ = opr('=', 2, id($1), $3); }
        |'{' stmt_list '}'     { $$ = $2; }
        ;

stmt_list:
          stmt                  { $$ = $1; }
        | stmt_list stmt        { $$ = opr(';', 2, $1, $2); }
        ;

identifier:
        INT                     //{ printf("This is int \n");}
        | BOOLEAN               { printf("This is bool \n");}
        | CHARACTER             { printf("This is char \n");}
        | FLOAT                 { printf("This is float \n");}
        | DOUBLE                { printf("This is double \n");}
        | STRING                { printf("This is string \n");}
        | VOID                  { printf("This is void \n");}
        ;

declare:
        identifier VARIABLE ';'            { printf("var is declared \n");}        
        | identifier VARIABLE '=' expr ';' { $$ = opr('=', 2, id($2), $4); }
        ;

const:
        CONSTANT declare                { printf("this is a constant \n"); }
        ;

expr:
          DIGITS                        { $$ = con($1); }
        | FLOATDIGIT                    { $$ = con($1); } 
        | VARIABLE                      { $$ = id($1); }
        | '-' expr %prec UMINUS         { $$ = opr(UMINUS, 1, $2); }
        | expr   '+'   expr         { $$ = opr('+', 2, $1, $3); }
        | expr   '-'   expr         { $$ = opr('-', 2, $1, $3); }
        | expr   '*'   expr         { $$ = opr('*', 2, $1, $3); }
        | expr   '/'   expr         { $$ = opr('/', 2, $1, $3); }
        | incrementation           { $$ = $1; }
        | '('   expr   ')'          { $$ = $2; }
        ;

comparisons:
          expr GE expr          { $$ = opr(GE, 2, $1, $3); }
        | expr LE expr          { $$ = opr(LE, 2, $1, $3); }
        | expr NE expr          { $$ = opr(NE, 2, $1, $3); }
        | expr EQ expr          { $$ = opr(EQ, 2, $1, $3); }
        | expr '<' expr         { $$ = opr('<', 2, $1, $3); }
        | expr '>' expr         { $$ = opr('>', 2, $1, $3); }
        //| NOT expr              { printf("NOT expr \n"); }
        ;

condition:
        comparisons                  { $$ = $1; }                        
        | VARIABLE                   { $$ = id($1); }
        | condition AND condition    { $$ = opr(AND, 2, $1, $3); }
        | condition OR condition     { $$ = opr(OR, 2, $1, $3); }
        ;

if:
        IF '(' condition ')' stmt %prec IFX         { $$ = opr(IF, 2, $3, $5); }
        | IF '(' condition ')' stmt ELSE stmt       { $$ = opr(IF, 3, $3, $5, $7); }
        ;

while:
        WHILE '(' condition ')' stmt            { $$ = opr(WHILE, 2, $3, $5); }
        ;

incrementation:
        VARIABLE INC             { $$ = opr(INC, 1, id($1));}
        | VARIABLE DEC           { $$ = opr(DEC, 1, id($1));}
        ;

preincrementation:
             VARIABLE "=" expr  { $$ = opr('=', 2, id($1), $3); }
            | INC VARIABLE      { $$ = opr(INC, 1, id($2));}
            | DEC VARIABLE      { $$ = opr(DEC, 1, id($2));}
            ;
forincrementation:
              incrementation
              | preincrementation
              ;

for:
        FOR '(' declare condition ';' forincrementation ')' stmt  { $$ = opr(FOR, 4, $3, $4, $6, $8); }
        ;

repeatuntil:
        REPEAT stmt UNTIL '(' condition ')'     
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

// FunctionStmt:              
//                  RETURN VARIABLE ';'
//                 | RETURN DIGITS ';'
//                 | RETURN ';'
//                 ;

function:
        identifier VARIABLE '(' argument ')'  stmt    { printf("Function\n"); }
        ;

%%


nodeType *con(int value) {
    nodeType *p;

    /* allocate node */
    if ((p = malloc(sizeof(nodeType))) == NULL)
        yyerror("out of memory");

    /* copy information */
    p->type = typeCon;
    p->con.value = value;

    return p;
}

nodeType *id(int i) {
    nodeType *p;

    /* allocate node */
    if ((p = malloc(sizeof(nodeType))) == NULL)
        yyerror("out of memory");

    /* copy information */
    p->type = typeId;
    p->id.i = i;

    return p;
}

nodeType *opr(int oper, int nops, ...) {
    va_list ap;
    nodeType *p;
    int i;

    /* allocate node, extending op array */
    if ((p = malloc(sizeof(nodeType) + (nops-1) * sizeof(nodeType *))) == NULL)
        yyerror("out of memory");

    /* copy information */
    p->type = typeOpr;
    p->opr.oper = oper;
    p->opr.nops = nops;
    va_start(ap, nops);
    for (i = 0; i < nops; i++)
        p->opr.op[i] = va_arg(ap, nodeType*);
    va_end(ap);
    return p;
}

void freeNode(nodeType *p) {
    int i;

    if (!p) return;
    if (p->type == typeOpr) {
        for (i = 0; i < p->opr.nops; i++)
            freeNode(p->opr.op[i]);
    }
    free (p);
}


void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
    yyparse();
}