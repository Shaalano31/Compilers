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
"return"        return RETURN;
"const"         return CONSTANT;
"int"           return INT;
"bool"          return BOOLEAN;
"char"          return CHARACTER;
"float"         return FLOAT;
"double"        return DOUBLE;
"string"        return STRING;
"void"          return VOID;
">="            return GE;
"<="            return LE;
"=="            return EQ;
"!="            return NE;
"&&"            return AND;
"||"            return OR;
"++"            return INC;
"--"            return DEC;
"!"             return NOT;


0           {
                yylval.iValue = atoi(yytext);
                return DIGITS;
            }

[1-9][0-9]* {
                yylval.iValue = atoi(yytext);
                return DIGITS;
            }
[1-9][0-9]*.[0-9]+ {
                yylval.iValue = atoi(yytext);
                return FLOATDIGIT;
            }

[-()<>=*/;{}+.:,] {
                    return *yytext;
                }

[ \t\n]*        ;       /* skip whitespace */

[a-zA-Z]+  { 
                yylval.sIndex = *yytext-'a';
                return VARIABLE;
            }

.               yyerror("Unknown character");

%%

int yywrap(void) {
    return 1;
}
