#include "symbol_table.h"

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

void display() {
   int i = 0;
	
   for(i = 0; i<SIZE; i++) {
	
      if(SymbolTable[i] != NULL)
     { 
        if(SymbolTable[i]->isFunction)
         {
            printf(" (Var Name:%s, Data Type:%d, Output Type:%d)",SymbolTable[i]->Variable_Name,SymbolTable[i]->DataType,SymbolTable[i]->Output);

            for(int j=0; j<SIZE && SymbolTable[i]->Inputs[j]<=5 &&SymbolTable[i]->Inputs[j]>0  ;j++)
               {    
                  printf("(Data Type:%d)", SymbolTable[i]->Inputs[j]);
               }

         }
         else
         printf(" (Var Name:%s, Data Type:%d)",SymbolTable[i]->Variable_Name,SymbolTable[i]->DataType);
     }
      else
         printf(" ~~ ");
   }
	
   printf("\n");
}


void display2() 
{
   int i = 0;
	
   for(i = 0; i<SIZE; i++) {
	
      if(FuncSymbolTable[i] != NULL)
     { 
         printf(" (Var Name:%s, Data Type:%d)",FuncSymbolTable[i]->Variable_Name,FuncSymbolTable[i]->DataType);
     }
      else
         printf(" ~~ ");
   }
	
   printf("\n");
}

struct DataItem *search(char* Variable_Name) {
   //get the hash 
   long long hashIndex = compute_hash(Variable_Name);  
	//printf("var %s\n", Variable_Name);
   //move in array until an empty 
   while(SymbolTable[hashIndex] != NULL) {
      //printf("var %s\n", SymbolTable[hashIndex]->Variable_Name);
      if(!strcmp(SymbolTable[hashIndex]->Variable_Name, Variable_Name))   //CAN YOU STAY UP ALL NIGHT
        {
           
           return SymbolTable[hashIndex];     
        }  
        
        if(!strcmp(FuncSymbolTable[hashIndex]->Variable_Name, Variable_Name))   //CAN YOU STAY UP ALL NIGHT
        {
           
           return FuncSymbolTable[hashIndex];     
        }                       
			
      //go to next cell
      ++hashIndex;
		
      //wrap around the table
      hashIndex %= SIZE;
   }        
	
   return NULL;        
}

void updateConst(struct DataItem* item) {
   //dummyItem = search(item->Variable_Name);
   search(item->Variable_Name)->isConstant = 1;
}

// struct DataItem *con(int value) {
//     struct DataItem *p;
//     printf("Hello\n");
//     /* copy information */
//     p->data = value;

//     printf("Hello\n");
//     return p;
// }

void update(int data,char* dataChar, float dataFloat, bool dataBool,char* Variable_Name)
{
   struct DataItem* item = search(Variable_Name);
   if(item!=NULL)
   {
      if(item->isConstant == 0)
      {
         printf("Updated\n");
         switch (item->DataType)
         {
            case 1:
               item->dataChar = dataChar;
               break;
            case 2:
               item->data = data;
               break;
            case 3:
               item->dataFloat = dataFloat;
               break;
            case 4:
               item->dataBool = dataBool;
               break;
         }
         //get the hash 
         long long hashIndex = compute_hash(Variable_Name);

         //move in array until an empty or deleted cell
         while(SymbolTable[hashIndex] != NULL && strcmp(SymbolTable[hashIndex]->Variable_Name, Variable_Name)) {
            //go to next cell
            ++hashIndex;	
            //wrap around the table
            hashIndex %= SIZE;
         }	

         SymbolTable[hashIndex] = item;
         
      }
      
   }
}

struct DataItem* insert(int data,char* dataChar, float dataFloat, bool dataBool, char* Variable_Name,bool isConstant,enum DataTypes DataType,bool isFunction,struct DataItem* Inputs[SIZE], enum DataTypes Output,int no_params )
 {
   if (search(Variable_Name)!=NULL)
   {return NULL;}
   struct DataItem *item = (struct DataItem*) malloc(sizeof(struct DataItem));
   switch (DataType)
   {
      case 1:
         item->dataChar = dataChar;
         break;
      case 2:
         item->data = data;
         break;
      case 3:
         item->dataFloat = dataFloat;
         break;
      case 4:
         item->dataBool = dataBool;
         break;
   } 
   item->Variable_Name= (char*) malloc(sizeof(char)*30);
   strcpy( item->Variable_Name, Variable_Name);
   if(!isFunction)
   {item->isConstant = isConstant;
   item->DataType = DataType;
   item->isFunction = isFunction;
  
   }
   else{
   item->isFunction = isFunction;
   item->DataType = DataType;

   for (int i=0;i<no_params;i++)
   item->Inputs[i] = Inputs[i];

   item->Output = Output;
   }

   //get the hash 
   long long hashIndex = compute_hash(Variable_Name);
   //move in array until an empty or deleted cell
   while(SymbolTable[hashIndex] != NULL ) {
      //go to next cell
      ++hashIndex;	
      //wrap around the table
      hashIndex %= SIZE;
   }	

struct DataItem* insertTable2(char* Variable_Name, enum DataTypes DataType)
 {
  

   struct DataItem *item = (struct DataItem*) malloc(sizeof(struct DataItem));
  
   item->Variable_Name= (char*) malloc(sizeof(char)*30);
   
   strcpy( item->Variable_Name, Variable_Name);
   
   item->DataType = DataType;
   item->isFunction = isFunction;
  
   
   
   //get the hash 
   long long hashIndex = compute_hash(Variable_Name);
   //move in array until an empty or deleted cell
   while(FuncSymbolTable[hashIndex] != NULL ) {
      //go to next cell
      ++hashIndex;	
      //wrap around the table
      hashIndex %= SIZE;
   }	



   FuncSymbolTable[hashIndex] = item;
   display2();
   return item;
}