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
"for"           return FOR;
"repeat"        return REPEAT;
"until"         return UNTIL;
"switch"        return SWITCH;
"case"          return CASE;
"break"         return BREAK;
"default"       return DEFAULT;
"continue"      return CONTINUE;
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
"&&"            return AND;
"||"            return OR;
"++"            return INC;
"--"            return DEC;


[0-9]+      {
                yylval = atoi(yytext);
                return DIGITS;
            }

[-()<>=+*/;{}.:] {
                    return *yytext;
                }

[ \t\n]*        ;       /* skip whitespace */

[a-zA-Z]+   {
                yylval = *yytext;
                return VARIABLE;
            }

.               yyerror("Unknown character");

%%

int yywrap(void) {
    return 1;
}
