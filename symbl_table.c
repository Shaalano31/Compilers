#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

#define SIZE 20

enum DataTypes {NULL_TYPE=-1,Char_Type = 0, Int_Type = 1, Float_Type = 2, Bool_Type = 3 , Void_Type = 4};

struct DataItem {
   int data;
   char* Variable_Name;
   bool isConstant;   
   enum DataTypes DataType;
   bool isFunction;
   enum DataTypes* Inputs; 
   enum DataTypes Output; 
};

struct DataItem* SymbolTable[SIZE]; 
struct DataItem* dummyItem;
struct DataItem* item;

long long compute_hash(char* s) {
    const int p = 31;
    const int m = 1e9 + 9;
    long long hash_value = 0;
    long long p_pow = 1;
    for (int i=0;i<sizeof(s) / sizeof(char*);i++) {
        hash_value = (hash_value + (s[i] - 'a' + 1) * p_pow) % m;
        p_pow = (p_pow * p) % m;
    }
    return hash_value % SIZE;
}

int hashCode(int key) {
   return key % SIZE;
}

struct DataItem *search(char* Variable_Name) {
   //get the hash 
   long long hashIndex = compute_hash(Variable_Name);  
	
   //move in array until an empty 
   while(SymbolTable[hashIndex] != NULL) {
	
      if(SymbolTable[hashIndex]->Variable_Name == Variable_Name)    //CAN YOU STAY UP ALL NIGHT
         return SymbolTable[hashIndex];                             //FUH......
			
      //go to next cell
      ++hashIndex;
		
      //wrap around the table
      hashIndex %= SIZE;
   }        
	
   return NULL;        
}

void update(int data,char* Variable_Name)
{
    struct DataItem* item = search(Variable_Name);
    if(item!=NULL)
    {
        if(item->isConstant == 0)
            item->data = data;
    }
}

void insert(int data,char* Variable_Name,bool isConstant,enum DataTypes DataType,bool isFunction,enum DataTypes* Inputs, enum DataTypes Output ) {

   struct DataItem *item = (struct DataItem*) malloc(sizeof(struct DataItem));
   item->data = data;  
   item->Variable_Name = Variable_Name;
   item->isConstant = isConstant;
   item->DataType = DataType;
   item->isFunction = isFunction;
   item->Inputs = Inputs;
   item->Output = Output;

   //get the hash 
   long long hashIndex = compute_hash(Variable_Name);

   //move in array until an empty or deleted cell
   while(SymbolTable[hashIndex] != NULL && SymbolTable[hashIndex]->Variable_Name != "") {
      //go to next cell
      ++hashIndex;	
      //wrap around the table
      hashIndex %= SIZE;
   }	

   SymbolTable[hashIndex] = item;
}

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

void display() {
   int i = 0;
	
   for(i = 0; i<SIZE; i++) {
	
      if(SymbolTable[i] != NULL)
         printf(" (%s,%d)",SymbolTable[i]->Variable_Name,SymbolTable[i]->data);
      else
         printf(" ~~ ");
   }
	
   printf("\n");
}

int main() {
   dummyItem = (struct DataItem*) malloc(sizeof(struct DataItem));
   dummyItem->data = -1;  
   dummyItem->Variable_Name = "AJAJAJAJ"; 
//insert(int data,char* Variable_Name,bool isConstant,enum DataTypes DataType,bool isFunction,enum DataTypes* Inputs, enum DataTypes Output ) {
   enum DataTypes* nulldude;
   insert(3, "var",0,1,0,nulldude,NULL_TYPE);
//    insert(2, 70);
//    insert(42, 80);
//    insert(4, 25);
//    insert(12, 44);
//    insert(14, 32);
//    insert(17, 11);
//    insert(13, 78);
//    insert(37, 97);

   display();
   item = search("var");

   if(item != NULL) {
      printf("Element found: %d\n", item->data);
   } else {
      printf("Element not found\n");
   }

  // delete(item);
   update(77,"var");

   if(item != NULL) {
      printf("Element found: %d\n", item->data);
   } else {
      printf("Element not found\n");
   }
   display();
}