%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <stdarg.h>
    #include <stdbool.h>
    #include "symbol_table.h"
    
    
    /* prototypes */
        struct DataItem *opr(int oper, int nops, ...);
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
%token WHILE IF RETURN FOR REPEAT UNTIL SWITCH CASE BREAK DEFAULT CONTINUE INC DEC INT BOOLEAN CHARACTER FLOAT CONSTANT DOUBLE STRING VOID PRINT TRUEE FALSEE


%nonassoc IFX
%nonassoc ELSE

%left GE LE EQ NE '>' '<' AND OR NOT
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS

%type <nPtr> stmt expr stmt_list comparisons if while condition incrementation preincrementation for forincrementation declare identifier argument arguments functiondeclare
%%

program:
        program stmt        //{ ex($2); }
        | program function
        | /* NULL */
        ;

stmt:
        ';'             //{ $$ = opr(';', 2, NULL, NULL); }
        | expr ';'      //{ $$ = $1; }
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
                                        printf("Compiled Successfuly, Matched Types\n");
                                    else
                                        printf("Mismatched data types, Syntax error\n");
                                   }
        | FunctionStmt  {printf("function statement\n");}
                                
        | '{' stmt_list '}'     //{ $$ = $2; }
        ;

stmt_list:
          stmt                 // { $$ = $1; }
        | stmt_list stmt        //{ $$ = opr(';', 2, $1, $2); }
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
                                            $$ = insert(defaultInt,"a",defaultFloat, 1, $2, 0, dataTypeVariable, 0, nulldude, 0 ,0);
                                            if($$==NULL)
                                                printf("Error, Variable with same name already declared.");
                                            else
                                                printf("Compiled Successfuly, Matched Types, Inserted into Symbol Table Var: %s\n",$2);
                                          }

        | identifier VARIABLE '=' expr ';'  
                                        {    
                                             dehk = malloc(sizeof(struct DataItem));
                                             dehk = $4 ;
                                             struct DataItem** nulldude;
                                             if(dataTypeVariable == $4->DataType)
                                                {
                                                
                                                $$ = insert(dehk->data,dehk->dataChar,dehk->dataFloat, dehk->dataBool, $2, 0, dataTypeVariable, 0, nulldude, 0,0 ); 
                                                if($$==NULL)
                                                    printf("Error, Variable with same name already declared.");
                                                else
                                                    printf("Compiled Successfuly, Matched Types, Inserted into Symbol Table Var: %s\n",$2);
                                                }
                                             else
                                                printf("Mismatched data types, Variable not inserted\n");
                                                
                                        }
        ;

const:
        CONSTANT declare                { printf("constant\n"); updateConst($2);  }
        ;

expr:
        VARIABLE                  { $$ = search($1); }
        |  DIGITS                 { item = malloc(sizeof(struct DataItem));
                                     item->data = $1;
                                     item->DataType = Int_Type;
                                     //item->dataChar = NULL;
                                     $$ = item;      }           
        | FLOATDIGIT              { item = malloc(sizeof(struct DataItem));
                                     item->dataFloat = $1;
                                     item->DataType = Float_Type;
                                     $$ = item;      }  
        | TRUEE                   { item = malloc(sizeof(struct DataItem));
                                     item->dataBool = 1;
                                     $$ = item;      }
        | FALSEE                   { item = malloc(sizeof(struct DataItem));
                                     item->dataBool = 0;
                                     $$ = item;      }
        | CAR                      { item = malloc(sizeof(struct DataItem));
                                     item->dataChar = $1;
                                     item->DataType = Char_Type;
                                     $$ = item;      }
                                     //printf("Catch\n");   }
        | '-' expr %prec UMINUS    { item = $2; 
                                     if(item->DataType == Int_Type ||item->DataType == Float_Type )
                                        printf("Compiled line Successfuly, Matched Types (-EXPR)\n");
                                     else
                                        printf("Mismatched data types, Syntax error (-EXPR)\n");
                                     $$ = item;  
                                     }

        | expr   '+'   expr        { item = malloc(sizeof(struct DataItem));

                                    if($1->DataType == $3->DataType)
                                        {printf("Compiled line Successfuly, Matched Types (EXPR + EXPR)\n");item->DataType=$1->DataType;}
                                    else
                                        printf("Mismatched data types, Syntax error (EXPR + EXPR)\n");
                                     $$ = item;
                                   }
        | expr   '-'   expr       { item = malloc(sizeof(struct DataItem));
 
                                    if($1->DataType == $3->DataType)
                                        {printf("Compiled line Successfuly, Matched Types (EXPR - EXPR)\n");item->DataType=$1->DataType;}
                                    else
                                        printf("Mismatched data types, Syntax error (EXPR - EXPR) \n");
                                   $$ = item;
                                   }
        | expr   '*'   expr       { item = malloc(sizeof(struct DataItem));
 
                                    if($1->DataType == $3->DataType)
                                        {printf("Compiled line Successfuly, Matched Types (EXPR * EXPR)\n");item->DataType=$1->DataType;}
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
                                                {printf("Compiled line Successfuly, Matched Types (EXPR / EXPR)\n");item->DataType=$1->DataType;}

                                        }
                                        }
                                    else
                                        printf("Mismatched data types, Syntax error (EXPR / EXPR)\n");

                                        $$=item;

                                   }
        | '('   expr   ')'        { $$ = $2; }
        ;

comparisons:
          expr GE expr          {   if($1->DataType == $3->DataType)
                                        printf("Compiled line Successfuly, Matched Types (EXPR >= EXPR)\n");
                                    else
                                        printf("Mismatched data types, Syntax error (EXPR >= EXPR)\n");
                                }
        | expr LE expr          { 

                                    if($1->DataType == $3->DataType)
                                        printf("Compiled line Successfuly, Matched Types (EXPR <= EXPR)\n");
                                    else
                                        printf("Mismatched data types, Syntax error (EXPR <= EXPR)\n");
                                }
        | expr NE expr         { 
                                    if($1->DataType == $3->DataType)
                                        printf("Compiled line Successfuly, Matched Types (EXPR != EXPR)\n");
                                    else
                                        printf("Mismatched data types, Syntax error (EXPR != EXPR)\n");
                                }
        | expr EQ expr          { 
                                    if($1->DataType == $3->DataType)
                                        printf("Compiled line Successfuly, Matched Types (EXPR == EXPR)\n");
                                    else
                                        printf("Mismatched data types, Syntax error (EXPR == EXPR)\n");
                                }
        | expr '<' expr         { 
                                    if($1->DataType == $3->DataType)
                                        printf("Compiled line Successfuly, Matched Types (EXPR < EXPR)\n");
                                    else
                                        printf("Mismatched data types, Syntax error (EXPR < EXPR)\n");
                                }
        | expr '>' expr         { 
                                    if($1->DataType == $3->DataType)
                                        printf("Compiled line Successfuly, Matched Types (EXPR > EXPR)\n");
                                    else
                                        printf("Mismatched data types, Syntax error (EXPR > EXPR)\n");
                                }
        ;

condition:
        comparisons                  //{ $$ = $1; }                        
        | VARIABLE                   //{ $$ = id($1); }
        | condition AND condition    //{ $$ = opr(AND, 2, $1, $3); }
        | condition OR condition     //{ $$ = opr(OR, 2, $1, $3); }
        ;

if:
        IF '(' condition ')' stmt %prec IFX         { printf("If Condition Matched\n"); }
        | IF '(' condition ')' stmt ELSE stmt       { printf("If Else Condition Matched\n"); }
        ;

while:
        WHILE '(' condition ')' stmt            {  
                                                  printf("While Loop Matched\n");      
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
        FOR '(' declare condition ';' forincrementation ')' stmt  { printf("For loop matched\n"); }
        ;

repeatuntil:
        REPEAT stmt UNTIL '(' condition ')'     { printf("Repeat Until matched\n"); }   
        ;

case:
        CASE DIGITS':' stmt BREAK ';' case       
        |
        ;


switch:
        SWITCH '(' VARIABLE ')' case
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
                                            $$=insert(defaultInt,"a",defaultFloat, 1, $2, 0, dataTypeVariable, true, FunctionInputs,dataTypeVariable ,FuncCount);
                                            FuncCount=0;
                                            }
                                            else
                                            $$=NULL;
                                            }
                 ;

function:
         functiondeclare stmt  {   
                                            if($1!=NULL)
                                                 printf("Function\n"); 
      
                                }
        ;

%%


/* 
struct DataItem *opr(int oper, int nops, ...) {
    va_list ap;
    struct DataItem *p;
    int i;
    if ((p = malloc(sizeof(struct DataItem) + (nops-1) * sizeof(struct DataItem *))) == NULL)
        yyerror("out of memory");

    //p->type = typeOpr;
    //p->DataType = Int_Type;
    p->opr.oper = oper;
    p->opr.nops = nops;
    //p->typeVar =Int_Type;
    va_start(ap, nops);
    for (i = 0; i < nops; i++)
        p->opr.op[i] = va_arg(ap, struct DataItem*);
    va_end(ap);
    return p;
}

// void freeNode(nodeType *p) {
//     int i;

//     if (!p) return;
//     if (p->type == typeOpr) {
//         for (i = 0; i < p->opr.nops; i++)
//             freeNode(p->opr.op[i]);
//     }
//     free (p);
// } 
*/


void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
    yyparse();
}