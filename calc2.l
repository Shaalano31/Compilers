    /* calculator #1 */
%{
    #include "y.tab.h"
    #include <stdlib.h>
    void yyerror(char *);
%}

%%

"while"         return WHILE;
"if"            return IF;
"else"          return ELSE;
"print"         return PRINT;


"const"         return CONSTANT;
"int"           return INT;        
"bool"          return BOOLEAN;
"char"          return CHARACTER;
"float"         return FLOAT;
"double"        return DOUBLE;
"string"        return STRING;
">="            return GE;
"<="            return LE;
"=="            return EQ;
"!="            return NE;
"="             return ASSIGNMENT;


[0-9]+      {
                yylval = atoi(yytext);
                return DIGITS;
            }

[-()<>=+*/;{}.\n] {
                    return *yytext;
                }

[ \t]   ;       /* skip whitespace */

[a-zA-Z]*   {
                yylval = *yytext;
                return VARIABLE;
            }

.               yyerror("Unknown character");

%%

int yywrap(void) {
    return 1;
}
