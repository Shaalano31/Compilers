bison --yacc phase1.y -d
flex phase1.l
gcc calc2b.c y.tab.c lex.yy.c
a.exe