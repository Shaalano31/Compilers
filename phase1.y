%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <stdarg.h>
    #include <stdbool.h>
    #include "symbol_table.h"
    
    
    /* prototypes */
        struct DataItem *opr(int oper, int nops, ...);
        struct DataItem *id(int i);
        struct DataItem *con(int value);
        void freeNode(struct DataItem *p);
        int ex(struct DataItem *p);
        int yylex(void);
        void yyerror(char *);
        struct DataItem* item;
        struct DataItem* dehk;
        int dataTypeVariable;
        
        int defaultInt = 0;
        float defaultFloat = 0.0;
        char* defaultBool;
        struct DataItem* FunctionInputs[20];
        int FuncCount = 0; 
    
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
%token WHILE IF RETURN FOR REPEAT UNTIL SWITCH CASE BREAK DEFAULT CONTINUE INC DEC INT BOOLEAN CHARACTER FLOAT CONSTANT DOUBLE STRING VOID PRINT TRUEE FALSEE NOTHING FUNCTION CALL FUNCNAME


%nonassoc IFX
%nonassoc ELSE

%left GE LE EQ NE '>' '<' AND OR NOT
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS

%type <nPtr> stmt expr stmt_list comparisons if while condition incrementation preincrementation for forincrementation declare identifier argument arguments functiondeclare switch function case repeatuntil
%%

program:
        program stmt       { ex($2); freeNode($2); }
        | program function { ex($2); freeNode($2); }
        | /* NULL */
        ;

stmt:
        ';'             { $$ = opr(';', 2, NULL, NULL); }
        | expr ';'      { $$ = $1; }
        | declare       //{ printf("declare \n");}
        | const         { printf("const \n");}
        | if            { printf("if \n");}
        | while         { printf("while \n");}
        | for           //{ printf("for \n");}
        | BREAK ';'     { printf("BREAK \n");}        
        | CONTINUE ';'  { printf("CONTINUE \n");}
        | repeatuntil   { printf("repeatuntil \n");}
        | switch        { printf("switch \n");}
        | PRINT expr ';'    {item = $2; //printf("data is %d", item->DataType);
                            switch (item->DataType)
                            {
                                case 1:
                                    printf("Char value is %s\n", item->dataChar);
                                    break;
                                case 2:
                                    printf("Int value is %d\n", item->data);
                                    break;
                                case 3:
                                    printf("Float value %f\n", item->dataFloat);
                                    break;
                                case 4:
                                    printf("Bool value %s\n", item->dataBool ? "true" : "false");
                                    break;
                            } 
                            }
        //| FunctionStmt  
        | VARIABLE '=' expr ';'   { 
                                    item = malloc(sizeof(struct DataItem));
                                    item = search($1);  
                                    if(item->DataType == $3->DataType)
                                    {
                                        $$ = opr('=', 2, id($1[0]), $3);
                                        printf("Compiled Successfuly, Matched Types\n");
                                    }
                                    else
                                        printf("Mismatched data types, Syntax error\n");
                                   }
        | FunctionStmt  {printf("function statement\n");}
                                
        | '{' stmt_list '}'     { $$ = $2; }
        ;

stmt_list:
          stmt                  { $$ = $1; }
        | stmt_list stmt        { $$ = opr(';', 2, $1, $2); }
        ;
identifier:
        INT                     {dataTypeVariable = 2; printf("Identifier: Int\n");} 
        | BOOLEAN               {dataTypeVariable = 4;printf("Identifier: Bool\n");}
        | CHARACTER             {dataTypeVariable = 1;printf("Identifier: Character\n");}
        | FLOAT                 {dataTypeVariable = 3;printf("Identifier: Float\n");}
        | DOUBLE                {dataTypeVariable = 3;printf("Identifier: Double\n");}
        | STRING                {dataTypeVariable = 1;printf("Identifier: String\n");}
        | VOID                  {dataTypeVariable = 5;printf("Identifier: Void\n");}
        ;

declare:
        identifier VARIABLE ';'            { struct DataItem** nulldude; 
                                            //$$ = 
                                            if(insert(defaultInt,"a",defaultFloat, 1, $2, 0, dataTypeVariable, 0, nulldude, 0 ,0)==NULL)
                                                printf("Error, Variable with same name already declared.");
                                            else
                                            {
                                                $$ = opr(NOTHING, 0);
                                                printf("Compiled Successfuly, Matched Types, Inserted into Symbol Table Var: %s\n",$2);
                                            }

                                          }

        | identifier VARIABLE '=' expr ';'  
                                        {    
                                             dehk = malloc(sizeof(struct DataItem));
                                             dehk = $4 ;
                                             struct DataItem** nulldude;
                                             if(dataTypeVariable == $4->DataType)
                                                {
                                               
                                                
                                                if(insert(dehk->data,dehk->dataChar,dehk->dataFloat, dehk->dataBool, $2, 0, dataTypeVariable, 0, nulldude, 0,0 )==NULL)
                                                    printf("Error, Variable with same name already declared.");
                                                else
                                                {
                                                    printf("Compiled Successfuly, Matched Types, Inserted into Symbol Table Var: %s\n",$2);
                                                    $$ = opr('=', 2, id($2[0]), $4);
                                                }
                                                    
                                                }
                                             else
                                                printf("Mismatched data types, Variable not inserted\n");
                                                
                                        }
        ;

const:
        CONSTANT declare                { printf("constant\n"); updateConst($2);  }
        ;

expr:
        VARIABLE                  { item = malloc(sizeof(struct DataItem));
                                    dehk = search($1); 
                                    item = id($1[0]);   
                                    item->DataType = dehk->DataType;
                                    $$ = item; }
        |  DIGITS                 { item = malloc(sizeof(struct DataItem));
                                     item = con($1);
                                     item->data = $1;
                                     item->DataType = Int_Type;
                                     //item->dataChar = NULL;
                                     $$ = item;      }           
        | FLOATDIGIT              { item = malloc(sizeof(struct DataItem));
                                     item = con($1);
                                     item->dataFloat = $1;
                                     item->DataType = Float_Type;
                                     $$ = item;      }  
        | TRUEE                   { item = malloc(sizeof(struct DataItem));
                                     item = con(1);
                                     item->dataBool = 1;
                                     $$ = item;      }
        | FALSEE                   { item = malloc(sizeof(struct DataItem));
                                     item = con(0);
                                     item->dataBool = 0;
                                     $$ = item;      }
        | CAR                      { item = malloc(sizeof(struct DataItem));
                                     item = id($1[0]); 
                                     item->dataChar = $1;
                                     item->DataType = Char_Type;
                                     $$ = item;      }
                                     //printf("Catch\n");   }
        | '-' expr %prec UMINUS    { item = $2; 
                                     if(item->DataType == Int_Type ||item->DataType == Float_Type )
                                     {
                                        item = opr(UMINUS, 1, $2);
                                        printf("Compiled line Successfuly, Matched Types (-EXPR)\n");
                                     }
                                     else
                                        printf("Mismatched data types, Syntax error (-EXPR)\n");
                                     $$ = item;  
                                     }

        | expr   '+'   expr        { item = malloc(sizeof(struct DataItem));

                                    if($1->DataType == $3->DataType)
                                        {item = opr('+', 2, $1, $3); 
                                         printf("Compiled line Successfuly, Matched Types (EXPR + EXPR)\n");
                                         item->DataType=$1->DataType;
                                         }
                                    else
                                        printf("Mismatched data types, Syntax error (EXPR + EXPR)\n");
                                     $$ = item;
                                   }
        | expr   '-'   expr       { item = malloc(sizeof(struct DataItem));
 
                                    if($1->DataType == $3->DataType)
                                        {item = opr('-', 2, $1, $3); printf("Compiled line Successfuly, Matched Types (EXPR - EXPR)\n");item->DataType=$1->DataType;}
                                    else
                                        printf("Mismatched data types, Syntax error (EXPR - EXPR) \n");
                                   $$ = item;
                                   }
        | expr   '*'   expr       { item = malloc(sizeof(struct DataItem));
 
                                    if($1->DataType == $3->DataType)
                                        {item = opr('*', 2, $1, $3); printf("Compiled line Successfuly, Matched Types (EXPR * EXPR)\n");item->DataType=$1->DataType;}
                                    else
                                        printf("Mismatched data types, Syntax error  (EXPR * EXPR)\n");
                                   $$ = item;
                                   }
        | expr   '/'   expr       { item = malloc(sizeof(struct DataItem));

                                    if($1->DataType == $3->DataType)
                                       { 
                                               if($3->DataType == Int_Type)
                                        {
                                           if($3->data==0)
                                                printf("Error, Division By Zero\n");
                                           else
                                                {item = opr('/', 2, $1, $3); printf("Compiled line Successfuly, Matched Types (EXPR / EXPR)\n");item->DataType=$1->DataType;}

                                        }
                                        }
                                    else
                                        printf("Mismatched data types, Syntax error (EXPR / EXPR)\n");

                                        $$=item;

                                   }
        | '('   expr   ')'        { $$ = $2; }
        ;

comparisons:
          expr GE expr          {   if($1->DataType == $3->DataType){
                                        item = malloc(sizeof(struct DataItem));
                                        item = opr(GE, 2, $1, $3);
                                        item->DataType = 4;
                                        $$ = item;
                                        printf("Compiled line Successfuly, Matched Types (EXPR >= EXPR)\n");
                                        }
                                    else
                                        printf("Mismatched data types, Syntax error (EXPR >= EXPR)\n");
                                }
        | expr LE expr          { 

                                    if($1->DataType == $3->DataType)
                                    {
                                        item = malloc(sizeof(struct DataItem));
                                        item = opr(LE, 2, $1, $3);
                                        item->DataType = 4;
                                        $$ = item;
                                        printf("Compiled line Successfuly, Matched Types (EXPR <= EXPR)\n");
                                    }
                                    else
                                        printf("Mismatched data types, Syntax error (EXPR <= EXPR)\n");
                                }
        | expr NE expr         { 
                                    if($1->DataType == $3->DataType)
                                    {
                                        item = malloc(sizeof(struct DataItem));
                                        item = opr(NE, 2, $1, $3);
                                        item->DataType = 4;
                                        $$ = item;
                                        printf("Compiled line Successfuly, Matched Types (EXPR != EXPR)\n");
                                    }
                                    else
                                        printf("Mismatched data types, Syntax error (EXPR != EXPR)\n");
                                }
        | expr EQ expr          {   printf("%d... %d\n", $1->DataType, $3->DataType );
                                    if($1->DataType == $3->DataType)
                                    {
                                        item = malloc(sizeof(struct DataItem));
                                        item = opr(EQ, 2, $1, $3);
                                        item->DataType = 4;
                                        $$ = item;
                                        printf("Compiled line Successfuly, Matched Types (EXPR == EXPR)\n");
                                    }
                                    else
                                        printf("Mismatched data types, Syntax error (EXPR == EXPR)\n");
                                }
        | expr '<' expr         { 
                                    if($1->DataType == $3->DataType)
                                    {
                                        item = malloc(sizeof(struct DataItem));
                                        item = opr('<', 2, $1, $3);
                                        item->DataType = 4;
                                        $$ = item;
                                        printf("Compiled line Successfuly, Matched Types (EXPR < EXPR)\n");
                                    }
                                    else
                                        printf("Mismatched data types, Syntax error (EXPR < EXPR)\n");
                                }
        | expr '>' expr         { 
                                    if($1->DataType == $3->DataType)
                                    {
                                        item = malloc(sizeof(struct DataItem));
                                        item = opr('>', 2, $1, $3);
                                        item->DataType = 4;
                                        $$ = item;
                                        printf("Compiled line Successfuly, Matched Types (EXPR > EXPR)\n");
                                    }
                                    else
                                        printf("Mismatched data types, Syntax error (EXPR > EXPR)\n");
                                }
        ;

condition:
        comparisons                  { $$ = $1; }                        
        | VARIABLE                   { $$ = id($1[0]); }
        | condition AND condition    //{ $$ = opr(AND, 2, $1, $3); }
        | condition OR condition     //{ $$ = opr(OR, 2, $1, $3); }
        ;

if:
        IF '(' condition ')' stmt %prec IFX         { $$ = opr(IF, 2, $3, $5); }
        | IF '(' condition ')' stmt ELSE stmt       { $$ = opr(IF, 3, $3, $5, $7); }
        ;

while:
        WHILE '(' condition ')' stmt            {  
                                                   $$ = opr(WHILE, 2, $3, $5);     
                                                }
        ;

incrementation:
        VARIABLE INC             { item = malloc(sizeof(struct DataItem));
                                  item = search($1);
                                  if(item->DataType == Int_Type | item->DataType == Float_Type)
                                        printf("Variable Increment, Matched Int or Float\n");
                                  else
                                         printf("Syntax Error, Cannot Increment other types that Int or Float \n");
                                 }
        | VARIABLE DEC           {  item = malloc(sizeof(struct DataItem));
                                  item = search($1);
                                  if(item->DataType == Int_Type | item->DataType == Float_Type)
                                        printf("Variable Decrement, Matched Int or Float\n");
                                  else
                                         printf("Syntax Error, Cannot Decrement other types that Int or Float \n");
                                         }
        ;

preincrementation:

             VARIABLE "=" expr  { 
                                    item = malloc(sizeof(struct DataItem));
                                    item = search($1);  
                                    if(item->DataType == $3->DataType)
                                        printf("Compiled line Successfuly, Matched Types (VAR = EXPR)\n");
                                    else
                                        printf("Mismatched data types, Syntax error (VAR = EXPR)\n");
                                   }
            | INC VARIABLE      { item = malloc(sizeof(struct DataItem));
                                  item = search($2);
                                  if(item->DataType == Int_Type | item->DataType == Float_Type)
                                        printf("Variable Increment, Matched Int or Float\n");
                                  else
                                         printf("Syntax Error, Cannot Increment other types that Int or Float \n");
                                 }
            | DEC VARIABLE      {  item = malloc(sizeof(struct DataItem));
                                  item = search($2);
                                  if(item->DataType == Int_Type | item->DataType == Float_Type)
                                        printf("Variable Decrement, Matched Int or Float\n");
                                  else
                                         printf("Syntax Error, Cannot Decrement other types that Int or Float \n");
                                         }
            ;
forincrementation:
              incrementation
              | preincrementation
              ;

for:
        FOR '(' declare condition ';' forincrementation ')' stmt  { printf("For loop matched\n"); $$ = opr(FOR, 4, $3, $4, $6, $8);}
        ;

repeatuntil:
        REPEAT stmt UNTIL '(' condition ')'     { printf("Repeat Until matched\n"); $$ = opr(REPEAT, 2, $2, $5);}   
        ;

case:
        CASE DIGITS':' stmt BREAK ';' case      {$$ = opr(CASE, 3, con($2), $4, $7); }
        |                                       { $$ = opr(NOTHING, 0); }
        ;


switch:
        SWITCH '(' VARIABLE ')' '{' case DEFAULT ':' stmt BREAK ';''}' { $$ = opr(SWITCH, 3, id($3[0]), $6, $9); }
        ;

argument:
        identifier VARIABLE arguments { if($3!=NULL){
                                        struct DataItem* item;
                                        item =insertTable2($2 ,dataTypeVariable);
                                        if(item == NULL) 
                                        {
                                            printf("Variable with same name already declared as global (FUNCTION ARGUMENTS)\n");
                                        }
                                        else
                                        {
                                            FunctionInputs[FuncCount]=malloc(sizeof(struct DataItem)); 
                                            FunctionInputs[FuncCount] ->Variable_Name=(char*) malloc(sizeof(char)*30); 
                                            strcpy( FunctionInputs[FuncCount] ->Variable_Name,$2 ); 
                                            FunctionInputs[FuncCount]->DataType= dataTypeVariable; 
                                            FuncCount++;
                                            //printf("argument\n");
                                            }
                                            $$=item;
                                         }
                                    }
                                        |{struct DataItem* item=malloc(sizeof(struct DataItem));
                                             $$=item;
                                             }
        ;


arguments:  ',' identifier VARIABLE arguments { 
                                                struct DataItem* item =insertTable2($3 ,dataTypeVariable);
                                                if(item == NULL) 
                                                {
                                                    printf("Variable with same name already declared as global (FUNCTION ARGUMENTS)\n");
                                                    
                                                }
                                                else
                                                {
                                                FunctionInputs[FuncCount]=malloc(sizeof(struct DataItem)); 
                                                FunctionInputs[FuncCount] ->Variable_Name=(char*) malloc(sizeof(char)*30); 
                                                strcpy( FunctionInputs[FuncCount] ->Variable_Name,$3);
                                                FunctionInputs[FuncCount] ->DataType= dataTypeVariable; 
                                                FuncCount++; 
                                                //printf("argumentsss\n");
                                                }
                                                $$=item;
                                            }
	    |                                   {struct DataItem* item=malloc(sizeof(struct DataItem));
                                             $$=item;
                                             }
		;

 FunctionStmt:              
                  RETURN expr ';'  
                 | RETURN ';'      
                 ;

functiondeclare:
                 identifier VARIABLE '(' argument ')' { 
                                                        if($4!=NULL)
                                                        {
                                                            item=malloc(sizeof(struct DataItem));
                                                            item=insert(defaultInt,"a",defaultFloat, 1, $2, 0, dataTypeVariable, true, FunctionInputs,dataTypeVariable ,FuncCount);
                                                            item=opr(FUNCNAME, 1, id($2[0]));
                                                            FuncCount=0;
                                                            $$ = item;
                                                        }
                                                        else
                                                            $$=NULL;
                                                      }
                 ;

function:
         functiondeclare stmt  {    
                                            if($1!=NULL)
                                            {
                                                $$ = opr(FUNCTION, 2, $1, $2);
                                                printf("Function\n"); 
                                            }
                                                 
      
                                }
        ;

%%


struct DataItem *con(int value) {
    struct DataItem *p;

    /* allocate node */
    if ((p = malloc(sizeof(struct DataItem))) == NULL)
        yyerror("out of memory");

    /* copy information */
    p->nodeType.type = typeCon;
    p->nodeType.con.value = value;

    return p;
}

struct DataItem *id(int i) {
    struct DataItem *p;

    /* allocate node */
    if ((p = malloc(sizeof(struct DataItem))) == NULL)
        yyerror("out of memory");

    /* copy information */
    //printf("ID %d\n", i);
    p->nodeType.type = typeId;
    p->nodeType.id.i = i;

    return p;
}

struct DataItem *opr(int oper, int nops, ...) {
    va_list ap;
    struct DataItem *p;
    int i;

    /* allocate node, extending op array */
    if ((p = malloc(sizeof(struct DataItem) + (nops-1) * sizeof(struct DataItem *))) == NULL)
        yyerror("out of memory");

    /* copy information */
    p->nodeType.type = typeOpr;
    p->nodeType.opr.oper = oper;
    p->nodeType.opr.nops = nops;
    va_start(ap, nops);
    for (i = 0; i < nops; i++)
        p->nodeType.opr.op[i] = va_arg(ap, struct DataItem*);
    va_end(ap);
    return p;
}

void freeNode(struct DataItem *p) {
    int i;

    if (!p) return;
    if (p->nodeType.type == typeOpr) {
        for (i = 0; i < p->nodeType.opr.nops; i++)
            freeNode(p->nodeType.opr.op[i]);
    }
    free (p);
}


void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
    yyparse();
}