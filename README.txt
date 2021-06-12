bison --yacc phase1.y -d
flex phase1.l
gcc y.tab.c symbol_table.c lex.yy.c
a.exe
