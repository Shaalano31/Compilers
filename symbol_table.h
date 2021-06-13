#pragma once
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

#define SIZE 20

//enum DataTypes {NULL_TYPE=-1,Char_Type = 0, Int_Type = 1, Float_Type = 2, Bool_Type = 3 , Void_Type = 4};
enum DataTypes {NULL_TYPE,Char_Type, Int_Type, Float_Type, Bool_Type, Void_Type};
typedef enum { typeCon, typeId, typeOpr } nodeEnum;

/* constants */
typedef struct {
    int value;                  /* value of constant */
} conNodeType;

/* identifiers */
typedef struct {
    int i;                      /* subscript to sym array */
} idNodeType;

/* operators */
typedef struct {
    int oper;                   /* operator */
    int nops;                   /* number of operands */
    struct DataItem *op[1];	/* operands, extended at runtime */
} oprNodeType;

typedef struct nodeTypeTag {
    nodeEnum type;              /* type of node */

    union {
        conNodeType con;        /* constants */
        idNodeType id;          /* identifiers */
        oprNodeType opr;        /* operators */
    };
} nodeType;

struct DataItem {
   int data;
   char* dataChar;
   float dataFloat;
   bool dataBool;

   char* Variable_Name;
   bool isConstant;   
   enum DataTypes DataType;
   bool isFunction;
   struct DataItem* Inputs[4]; 
   enum DataTypes Output; 

   nodeType nodeType;

};

struct DataItem* SymbolTable[SIZE]; 
struct DataItem* FuncSymbolTable[SIZE]; 

struct DataItem* dummyItem;
struct DataItem* item;

extern long long compute_hash(char* s);
extern struct DataItem* insertTable2(char* Variable_Name, enum DataTypes DataType);

extern int hashCode(int key);


extern void display(int no_params);
extern void display2();
extern struct DataItem *search(char* Variable_Name);


extern void updateConst(struct DataItem* item);


extern void update(int data,char* dataChar, float dataFloat, bool dataBool,char* Variable_Name);


extern struct DataItem* insert(int data,char* dataChar, float dataFloat, bool dataBool, char* Variable_Name,bool isConstant,enum DataTypes DataType,bool isFunction,struct DataItem* Inputs[SIZE], enum DataTypes Output ,int no_params);
