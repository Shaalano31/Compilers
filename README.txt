bison --yacc calc2.y -d
flex calc2.l
gcc y.tab.c lex.yy.c
a.exe