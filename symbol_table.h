#pragma once
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

#define SIZE 20

//enum DataTypes {NULL_TYPE=-1,Char_Type = 0, Int_Type = 1, Float_Type = 2, Bool_Type = 3 , Void_Type = 4};
enum DataTypes {NULL_TYPE,Char_Type, Int_Type, Float_Type, Bool_Type, Void_Type};

typedef struct {
   int oper;                   /* operator */
   int nops;                   /* number of operands */
   struct DataItem *op[1];    /* operands, extended at runtime */
   
} oprNodeType;

struct DataItem {
   int data;
   char* dataChar;
   float dataFloat;
   bool dataBool;

   char* Variable_Name;
   bool isConstant;   
   enum DataTypes DataType;
   bool isFunction;
   struct DataItem* Inputs[SIZE]; 
   enum DataTypes Output; 

   union{
      oprNodeType opr;
   };

};

struct DataItem* SymbolTable[SIZE]; 
struct DataItem* FuncSymbolTable[SIZE]; 

struct DataItem* dummyItem;
struct DataItem* item;

extern long long compute_hash(char* s);
struct DataItem* insertTable2(char* Variable_Name, enum DataTypes DataType);
void display2();
//     const int p = 31;
//     const int m = 1e9 + 9;
//     long long hash_value = 0;
//     long long p_pow = 1;
//     for (int i=0;i<sizeof(s) / sizeof(char*);i++) {
//         hash_value = (hash_value + (s[i] - 'a' + 1) * p_pow) % m;
//         p_pow = (p_pow * p) % m;
//     }
//     return hash_value % SIZE;
// }

extern int hashCode(int key);
//    return key % SIZE;
// }

extern void display();
//    int i = 0;
	
//    for(i = 0; i<SIZE; i++) {
	
//       if(SymbolTable[i] != NULL)
//          printf(" (%s,%d)",SymbolTable[i]->Variable_Name,SymbolTable[i]->data);
//       else
//          printf(" ~~ ");
//    }
	
//    printf("\n");
// }

extern struct DataItem *search(char* Variable_Name);
//    //get the hash 
//    long long hashIndex = compute_hash(Variable_Name);  
// 	//printf("var %s\n", Variable_Name);
//    //move in array until an empty 
//    while(SymbolTable[hashIndex] != NULL) {
//       printf("var %s\n", SymbolTable[hashIndex]->Variable_Name);
//       if(!strcmp(SymbolTable[hashIndex]->Variable_Name, Variable_Name))   //CAN YOU STAY UP ALL NIGHT
//         {
           
//            return SymbolTable[hashIndex];     
//         }                        //FUH......
			
//       //go to next cell
//       ++hashIndex;
		
//       //wrap around the table
//       hashIndex %= SIZE;
//    }        
	
//    return NULL;        
// }

extern void updateConst(struct DataItem* item);
//    //dummyItem = search(item->Variable_Name);
//    search(item->Variable_Name)->isConstant = 1;
// }

//struct DataItem *con(int value) {
//     struct DataItem *p;
//     printf("Hello\n");
//     /* copy information */
//     p->data = value;

//     printf("Hello\n");
//     return p;
// }

extern void update(int data,char* dataChar, float dataFloat, bool dataBool,char* Variable_Name);
// {
//    struct DataItem* item = search(Variable_Name);
//    if(item!=NULL)
//    {
//       if(item->isConstant == 0)
//       {
//          printf("Updated\n");
//          switch (item->DataType)
//          {
//             case 1:
//                item->dataChar = dataChar;
//                break;
//             case 2:
//                item->data = data;
//                break;
//             case 3:
//                item->dataFloat = dataFloat;
//                break;
//             case 4:
//                item->dataBool = dataBool;
//                break;
//          }
//          //get the hash 
//          long long hashIndex = compute_hash(Variable_Name);

//          //move in array until an empty or deleted cell
//          while(SymbolTable[hashIndex] != NULL) {
//             //go to next cell
//             ++hashIndex;	
//             //wrap around the table
//             hashIndex %= SIZE;
//          }	

//          SymbolTable[hashIndex] = item;
         
//       }
      
//    }
// }

extern struct DataItem* insert(int data,char* dataChar, float dataFloat, bool dataBool, char* Variable_Name,bool isConstant,enum DataTypes DataType,bool isFunction,enum DataTypes Inputs[SIZE], enum DataTypes Output ,int no_params);
//  {
//    if (search(Variable_Name)!=NULL)
//    {return NULL;}
//    struct DataItem *item = (struct DataItem*) malloc(sizeof(struct DataItem));
//    switch (DataType)
//    {
//       case 1:
//          item->dataChar = dataChar;
//          break;
//       case 2:
//          item->data = data;
//          break;
//       case 3:
//          item->dataFloat = dataFloat;
//          break;
//       case 4:
//          item->dataBool = dataBool;
//          break;
//    } 
//    item->Variable_Name= (char*) malloc(sizeof(char)*30);
//    strcpy( item->Variable_Name, Variable_Name);
//    item->isConstant = isConstant;
//    item->DataType = DataType;
//    item->isFunction = isFunction;
//    item->Inputs = Inputs;
//    item->Output = Output;

//    //get the hash 
//    long long hashIndex = compute_hash(Variable_Name);
//    //move in array until an empty or deleted cell
//    while(SymbolTable[hashIndex] != NULL ) {
//       //go to next cell
//       ++hashIndex;	
//       //wrap around the table
//       hashIndex %= SIZE;
//    }	


//    SymbolTable[hashIndex] = item;
// display();
//    return item;
// }


// struct DataItem* delete(struct DataItem* item) {
//    int key = item->key;

//    //get the hash 
//    int hashIndex = hashCode(key);

//    //move in array until an empty
//    while(SymbolTable[hashIndex] != NULL) {
	
//       if(SymbolTable[hashIndex]->key == key) {
//          struct DataItem* temp = SymbolTable[hashIndex]; 
			
//          //assign a dummy item at deleted position
//          SymbolTable[hashIndex] = dummyItem; 
//          return temp;
//       }
		
//       //go to next cell
//       ++hashIndex;
		
//       //wrap around the table
//       hashIndex %= SIZE;
//    }      
	
//    return NULL;        
// }



// int main() {
//    dummyItem = (struct DataItem*) malloc(sizeof(struct DataItem));
//    dummyItem->data = -1;  
//    dummyItem->Variable_Name = "AJAJAJAJ"; 
// //insert(int data,char* Variable_Name,bool isConstant,enum DataTypes DataType,bool isFunction,enum DataTypes* Inputs, enum DataTypes Output ) {
//    enum DataTypes* nulldude;
//    insert(3, "var",0,1,0,nulldude,NULL_TYPE);
// //    insert(2, 70);
// //    insert(42, 80);
// //    insert(4, 25);
// //    insert(12, 44);
// //    insert(14, 32);
// //    insert(17, 11);
// //    insert(13, 78);
// //    insert(37, 97);

//    display();
//    item = search("var");

//    if(item != NULL) {
//       printf("Element found: %d\n", item->data);
//    } else {
//       printf("Element not found\n");
//    }

//   // delete(item);
//    update(77,"var");

//    if(item != NULL) {
//       printf("Element found: %d\n", item->data);
//    } else {
//       printf("Element not found\n");
//    }
//    display();
// }