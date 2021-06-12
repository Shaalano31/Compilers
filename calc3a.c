#include <stdio.h>
#include "symbol_table.h"
#include "y.tab.h"

struct DataItem* ex(struct DataItem *p) {
    if(p==NULL)
    return NULL;

        printf("test %d ,... %d, data type %d\n", p->opr.op[0]->data, p->opr.oper, p->DataType);
        //printf("Case is  %d \n", p->opr.oper);
        struct DataItem* dummy = malloc(sizeof(struct DataItem));
        switch (p->DataType)
        {
        case Int_Type:
            switch ( p->opr.oper)
            {                
            case '+':
                dummy->data = p->opr.op[0]->data + p->opr.op[1]->data;
                dummy->DataType = 2;
                break;
            
            case '-':
                printf("Entered\n");
                dummy->data = p->opr.op[0]->data - p->opr.op[1]->data;
                dummy->DataType = 2;
                break;

            case '*':
                dummy->data = p->opr.op[0]->data * p->opr.op[1]->data;
                dummy->DataType = 2;
                break;

            case '/':
                dummy->data = p->opr.op[0]->data / p->opr.op[1]->data;
                dummy->DataType = 2;
                break;

            case UMINUS: 
                //printf("Hello\n");   
                dummy->data =  0 - p->opr.op[0]->data;
                dummy->DataType = 2;
                break;
            
            case GE:
                printf("GEE\n");
                printf("OP1 %d, OP2 %d,\n", p->opr.op[0]->data, p->opr.op[1]->data);
                dummy->dataBool = p->opr.op[0]->data >= p->opr.op[1]->data;
                dummy->DataType = 4;
                break;

            case LE:
                dummy->dataBool = p->opr.op[0]->data <= p->opr.op[1]->data;
                dummy->DataType = 4;
                break;

            case NE:
                dummy->dataBool = p->opr.op[0]->data != p->opr.op[1]->data;
                dummy->DataType = 4;
                break;

            case EQ:
                dummy->dataBool = p->opr.op[0]->data == p->opr.op[1]->data;
                dummy->DataType = 4;
                break;

            // case WHILE:
            //     //printf("Entered while\n");
            //     while(ex(p->opr.op[0])->dataBool) dummy->data = ex(p->opr.op[1])->data;
            //     break; 
            }
            break;
        
        case Float_Type:
        switch ( p->opr.oper)
            {
                
            case '+':
                dummy->dataFloat = p->opr.op[0]->dataFloat + p->opr.op[1]->dataFloat;
                dummy->DataType = 3;
                break;
            
            case '-':
                dummy->dataFloat = p->opr.op[0]->dataFloat - p->opr.op[1]->dataFloat;
                dummy->DataType = 3;
                break;

            case '*':
                dummy->dataFloat = p->opr.op[0]->dataFloat * p->opr.op[1]->dataFloat;
                dummy->DataType = 3;
                break;

            case '/':
                dummy->dataFloat = p->opr.op[0]->dataFloat / p->opr.op[1]->dataFloat;
                dummy->DataType = 3;
                break;

            case UMINUS:    
                dummy->dataFloat = 0.0 - p->opr.op[0]->dataFloat;
                dummy->DataType = 3;
                break;

            case GE:
                dummy->dataBool = p->opr.op[0]->dataFloat >= p->opr.op[1]->dataFloat;
                dummy->DataType = 4;
                break;
            }
            break;

        case Bool_Type:
            switch ( p->opr.oper)
            {
                case WHILE:
                    printf("Entered while\n");
                    //printf("Bool value %s\n", p->opr.op[0]->dataBool ? "true" : "false");
                    //printf("Val %d\n", p->opr.op[1]->data);
                    while(ex(p->opr.op[0])->dataBool) 
                    {
                        printf("Bool value %s\n", p->opr.op[0]->dataBool ? "true" : "false");
                        printf("Val %d\n", p->opr.op[1]->data);
                        ex(p->opr.op[1])->data;
                    }
                    printf("Bool2222 value %s\n", ex(p->opr.op[0])->dataBool ? "true" : "false");
                    printf("Val2222 %d\n", p->opr.op[1]->data);
                    //dummy->data = 
                    break;
            }
        } 
        return dummy;
}
    //if (!p) return NULL;
    // switch(p->type) {
    // case typeCon:       return p->con.value;
    // case typeId:        return sym[p->id.i];
    // case typeOpr:
        //switch(p->opr.oper) {
        //case WHILE:     while(ex(p->opr.op[0])) ex(p->opr.op[1]); 
        // case IF:        if (ex(p->opr.op[0]))
        //                     ex(p->opr.op[1]);
        //                 else if (p->opr.nops > 2)
        //                     ex(p->opr.op[2]);
        //                 return 0;
        // case PRINT:     printf("%d\n", ex(p->opr.op[0])); return 0;
        // case ';':       ex(p->opr.op[0]); return ex(p->opr.op[1]);
        // case '=':       return sym[p->opr.op[0]->id.i] = ex(p->opr.op[1]);
        // case UMINUS:    return -ex(p->opr.op[0]);
        //case '+':       

        //printf("testing %d,")
        //struct Dataitem* dummy = search(p->opr->op[0]);
        //return search(p->opr.op[0]) + se(p->opr.op[1]);
        // case '-':       return ex(p->opr.op[0]) - ex(p->opr.op[1]);
        // case '*':       return ex(p->opr.op[0]) * ex(p->opr.op[1]);
        // case '/':       return ex(p->opr.op[0]) / ex(p->opr.op[1]);
        // case '<':       return ex(p->opr.op[0]) < ex(p->opr.op[1]);
        // case '>':       return ex(p->opr.op[0]) > ex(p->opr.op[1]);
        // case GE:        return ex(p->opr.op[0]) >= ex(p->opr.op[1]);
        // case LE:        return ex(p->opr.op[0]) <= ex(p->opr.op[1]);
        // case NE:        return ex(p->opr.op[0]) != ex(p->opr.op[1]);
        // case EQ:        return ex(p->opr.op[0]) == ex(p->opr.op[1]);
        //}
    //}
