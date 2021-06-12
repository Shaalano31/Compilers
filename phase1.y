%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <stdarg.h>
    #include "symbol_table.h"
    #include <stdbool.h>
    #include "calc2.h"
    
    /* prototypes */
        // nodeType *declare(int value, char value2, int datatype);
        // nodeType *opr(int oper, int nops, ...);
        // nodeType *id(int i);
        // nodeType *con(int value);
        void freeNode(nodeType *p);
        int ex(nodeType *p);
        int yylex(void);
        void yyerror(char *);
        struct DataItem* item;
        struct DataItem* dehk;
        int dataTypeVariable;
        
        int defaultInt = 0;
        //char* defaultChar = 'a';
        float defaultFloat = 0.0;
        char* defaultBool;
    
    //struct DataItem* SymbolTable[20]; 
    int sym[5];
%}

%union {
    int iValue;                 /* integer value */
    char sIndex[30];                /* symbol table index */
    char* str;
    double iFloat;
    bool boole;
    struct DataItem *nPtr;         /* node pointer */
};
%token <iValue>DIGITS 
%token <sIndex>VARIABLE 
%token <iFloat>FLOATDIGIT
%token <str>CAR
//%token <boole>BOOL_VALUES
%token WHILE IF RETURN FOR REPEAT UNTIL SWITCH CASE BREAK DEFAULT CONTINUE INC DEC INT BOOLEAN CHARACTER FLOAT CONSTANT DOUBLE STRING VOID PRINT TRUEE FALSEE


%nonassoc IFX
%nonassoc ELSE

%left GE LE EQ NE '>' '<' AND OR NOT
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS

%type <nPtr> stmt expr stmt_list comparisons if while condition incrementation preincrementation for forincrementation declare identifier
%%

program:
        program stmt        //{ ex($2); freeNode($2); }
        | program function
        | /* NULL */
        ;

stmt:
        ';'             //{ $$ = opr(';', 2, NULL, NULL); }
        | expr ';'      //{ $$ = $1; }
        | declare       { printf("declare \n");}
        | const         { printf("const \n");}
        | if            { printf("if \n");}
        | while         { printf("while \n");}
        | for           //{ printf("for \n");}
        | BREAK ';'     { printf("BREAK \n");}        
        | CONTINUE ';'  { printf("CONTINUE \n");}
        | repeatuntil   { printf("repeatuntil \n");}
        | switch        { printf("switch \n");}
        | PRINT expr ';'    {item = $2; printf("data is %d", item->DataType);
                            switch (item->DataType)
                            {
                                case 1:
                                    printf("Printed value1 %s\n", item->dataChar);
                                    break;
                                case 2:
                                    printf("Printed value2 %d\n", item->data);
                                    break;
                                case 3:
                                    printf("Printed value3 %f\n", item->dataFloat);
                                    break;
                                case 4:
                                    printf("Print bool %s\n", item->dataBool ? "true" : "false");
                                    break;
                            } 
                            }
        //| FunctionStmt  
        | VARIABLE '=' expr ';'  { display();

        dehk = malloc(sizeof(struct DataItem));
                                   dehk = $3;
                                   update(dehk->data,dehk->dataChar,dehk->dataFloat, dehk->dataBool, $1);
                                   display();}
        | '{' stmt_list '}'     { $$ = $2; }
        ;

stmt_list:
          stmt                  { $$ = $1; }
        | stmt_list stmt        //{ $$ = opr(';', 2, $1, $2); }
        ;

identifier:
        INT                     {dataTypeVariable = 2;} 
        | BOOLEAN               {dataTypeVariable = 4;}
        | CHARACTER             {dataTypeVariable = 1;}
        | FLOAT                 {dataTypeVariable = 3;}
        | DOUBLE                { printf("This is double \n");}
        | STRING                { printf("This is string \n");}
        | VOID                  { printf("This is void \n");}
        ;

declare:
        identifier VARIABLE ';'            { enum DataTypes* nulldude; 
                                            $$ = insert(defaultInt,"a",defaultFloat, 1, $2, 0, dataTypeVariable, 0, nulldude, 0 ); display(); }

        | identifier VARIABLE '=' expr ';'  { printf("declare\n"); dehk = malloc(sizeof(struct DataItem));
                                             dehk = $4 ;
                                             enum DataTypes* nulldude;
                                             $$ = insert(dehk->data,dehk->dataChar,dehk->dataFloat, dehk->dataBool, $2, 0, dataTypeVariable, 0, nulldude, 0 ); }
        ;

const:
        CONSTANT declare                { printf("constant\n"); updateConst($2);  }
        ;

expr:
        VARIABLE                  {$$ = search($1);}
        |  DIGITS                 { item = malloc(sizeof(struct DataItem));
                                     item->data = $1;
                                     $$ = item;      }           
        | FLOATDIGIT              { item = malloc(sizeof(struct DataItem));
                                     item->dataFloat = $1;
                                     $$ = item;      }  
        | TRUEE                   { item = malloc(sizeof(struct DataItem));
                                     item->dataBool = 1;
                                     $$ = item;      }
        | FALSEE                   { item = malloc(sizeof(struct DataItem));
                                     item->dataBool = 0;
                                     $$ = item;      }
        | CAR                      { item = malloc(sizeof(struct DataItem));
                                     item->dataChar = $1;
                                     $$ = item;      }
                                     //printf("Catch\n");   }
        // | '-' expr %prec UMINUS   //      { $$ = opr(UMINUS, 1, $2); }
        // | expr   '+'   expr       //  { $$ = opr('+', 2, $1, $3); }
        // | expr   '-'   expr       //  { $$ = opr('-', 2, $1, $3); }
        // | expr   '*'   expr       //  { $$ = opr('*', 2, $1, $3); }
        // | expr   '/'   expr       //  { $$ = opr('/', 2, $1, $3); }
        // | incrementation          // { $$ = $1; }
        // | '('   expr   ')'        //  { $$ = $2; }
        ;

comparisons:
          expr GE expr          //{ $$ = opr(GE, 2, $1, $3); }
        | expr LE expr          //{ $$ = opr(LE, 2, $1, $3); }
        | expr NE expr          //{ $$ = opr(NE, 2, $1, $3); }
        | expr EQ expr          //{ $$ = opr(EQ, 2, $1, $3); }
        | expr '<' expr         //{ $$ = opr('<', 2, $1, $3); }
        | expr '>' expr         //{ $$ = opr('>', 2, $1, $3); }
        //| NOT expr              { printf("NOT expr \n"); }
        ;

condition:
        comparisons                  //{ $$ = $1; }                        
        | VARIABLE                   //{ $$ = id($1); }
        | condition AND condition    //{ $$ = opr(AND, 2, $1, $3); }
        | condition OR condition     //{ $$ = opr(OR, 2, $1, $3); }
        ;

if:
        IF '(' condition ')' stmt %prec IFX         //{ $$ = opr(IF, 2, $3, $5); }
        | IF '(' condition ')' stmt ELSE stmt       //{ $$ = opr(IF, 3, $3, $5, $7); }
        ;

while:
        WHILE '(' condition ')' stmt            //{ $$ = opr(WHILE, 2, $3, $5); }
        ;

incrementation:
        VARIABLE INC             //{ $$ = opr(INC, 1, id($1));}
        | VARIABLE DEC           //{ $$ = opr(DEC, 1, id($1));}
        ;

preincrementation:
             VARIABLE "=" expr  //{ $$ = opr('=', 2, id($1), $3); }
            | INC VARIABLE      //{ $$ = opr(INC, 1, id($2));}
            | DEC VARIABLE      //{ $$ = opr(DEC, 1, id($2));}
            ;
forincrementation:
              incrementation
              | preincrementation
              ;

for:
        FOR '(' declare condition ';' forincrementation ')' stmt  //{ $$ = opr(FOR, 4, $3, $4, $6, $8); }
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


// nodeType *declare(int value, char value2, int datatype) {
//     nodeType *p;

//     /* allocate node */
//     if ((p = malloc(sizeof(nodeType))) == NULL)
//         yyerror("out of memory");

// //     printf("CON\n");
// //     printf("Type is %d\n", datatype);
//     p->type = typeData;
//     p->typeVar = datatype;
//     switch(p->typeVar){
//             case Int_Type: 
//                 p->con.value = value; 
//                 p->type = typeCon;
//                 printf("Declare int is %d\n", p->con.value); 
//                 break;
//             case Char_Type: 
//                 p->con.valueChar = value2; 
//                 printf("Declare char is %c\n", p->con.valueChar); 
//                 break;
//     }
    
//     return p;
// }

// nodeType *con(int value) {
//     nodeType *p;

//     /* allocate node */
//     if ((p = malloc(sizeof(nodeType))) == NULL)
//         yyerror("out of memory");

//     /* copy information */
// //     printf("CON\n");
// //     printf("Type is %d\n", typeCon);
// //     printf("Value is %d\n", value);
//     p->type = typeCon;
//     p->con.value = value;

//     return p;
// }

// DataItem *opr(int oper, int nops, ...) {
//     va_list ap;
//     nodeType *p;
//     int i;

//     /* allocate node, extending op array */
//     if ((p = malloc(sizeof(nodeType) + (nops-1) * sizeof(nodeType *))) == NULL)
//         yyerror("out of memory");

//     /* copy information */
//     p->type = typeOpr;
//     p->opr.oper = oper;
//     p->opr.nops = nops;
//     p->typeVar =Int_Type;
//     va_start(ap, nops);
//     for (i = 0; i < nops; i++)
//         p->opr.op[i] = va_arg(ap, nodeType*);
//     va_end(ap);
//     return p;
// }

// void freeNode(nodeType *p) {
//     int i;

//     if (!p) return;
//     if (p->type == typeOpr) {
//         for (i = 0; i < p->opr.nops; i++)
//             freeNode(p->opr.op[i]);
//     }
//     free (p);
// }


void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
    yyparse();
}