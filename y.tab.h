
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     DIGITS = 258,
     VARIABLE = 259,
     FLOATDIGIT = 260,
     CAR = 261,
     WHILE = 262,
     IF = 263,
     RETURN = 264,
     FOR = 265,
     REPEAT = 266,
     UNTIL = 267,
     SWITCH = 268,
     CASE = 269,
     BREAK = 270,
     DEFAULT = 271,
     CONTINUE = 272,
     INC = 273,
     DEC = 274,
     INT = 275,
     BOOLEAN = 276,
     CHARACTER = 277,
     FLOAT = 278,
     CONSTANT = 279,
     DOUBLE = 280,
     STRING = 281,
     VOID = 282,
     PRINT = 283,
     TRUEE = 284,
     FALSEE = 285,
     IFX = 286,
     ELSE = 287,
     NOT = 288,
     OR = 289,
     AND = 290,
     NE = 291,
     EQ = 292,
     LE = 293,
     GE = 294,
     UMINUS = 295
   };
#endif
/* Tokens.  */
#define DIGITS 258
#define VARIABLE 259
#define FLOATDIGIT 260
#define CAR 261
#define WHILE 262
#define IF 263
#define RETURN 264
#define FOR 265
#define REPEAT 266
#define UNTIL 267
#define SWITCH 268
#define CASE 269
#define BREAK 270
#define DEFAULT 271
#define CONTINUE 272
#define INC 273
#define DEC 274
#define INT 275
#define BOOLEAN 276
#define CHARACTER 277
#define FLOAT 278
#define CONSTANT 279
#define DOUBLE 280
#define STRING 281
#define VOID 282
#define PRINT 283
#define TRUEE 284
#define FALSEE 285
#define IFX 286
#define ELSE 287
#define NOT 288
#define OR 289
#define AND 290
#define NE 291
#define EQ 292
#define LE 293
#define GE 294
#define UMINUS 295




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 33 "phase1.y"

    int iValue;                 /* integer value */
    char sIndex[30];                /* symbol table index */
    char* str;
    double iFloat;
    bool boole;
    struct DataItem *nPtr;         /* node pointer */



/* Line 1676 of yacc.c  */
#line 143 "y.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


