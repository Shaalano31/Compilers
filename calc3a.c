#include <stdio.h>
#include "symbol_table.h"
#include "y.tab.h"

struct DataItem* ex(struct DataItem *p) {

        printf("test %d  %d,... %d, data type %d\n", p->opr.op[0]->data,  p->opr.op[1]->data, p->opr.oper, p->DataType);
        struct DataItem* dummy = malloc(sizeof(struct DataItem));
        switch (p->DataType)
        {
        case Int_Type:
            switch ( p->opr.oper)
            {
                printf("Entered\n");
                dummy->DataType = 2;
            case '+':
                dummy->data = p->opr.op[0]->data + p->opr.op[1]->data;
                break;
            
            case '-':
                dummy->data = p->opr.op[0]->data - p->opr.op[1]->data;
                break;

            case '*':
                dummy->data = p->opr.op[0]->data * p->opr.op[1]->data;
                break;

            case '/':
                dummy->data = p->opr.op[0]->data / p->opr.op[1]->data;
                break;

            case UMINUS: 
                printf("Hello\n");   
                dummy->data =  - p->opr.op[0]->data;
                break;
            }
            break;
        
        case Float_Type:
        switch ( p->opr.oper)
            {
                dummy->DataType = 3;
            case '+':
                dummy->dataFloat = p->opr.op[0]->dataFloat + p->opr.op[1]->dataFloat;
                break;
            
            case '-':
                dummy->dataFloat = p->opr.op[0]->dataFloat - p->opr.op[1]->dataFloat;
                break;

            case '*':
                dummy->dataFloat = p->opr.op[0]->dataFloat * p->opr.op[1]->dataFloat;
                break;

            case '/':
                dummy->dataFloat = p->opr.op[0]->dataFloat / p->opr.op[1]->dataFloat;
                break;

            case UMINUS:    
                dummy->dataFloat =  - p->opr.op[0]->dataFloat;
                break;
            }
            break;
        }
        return dummy;
}
    //if (!p) return NULL;
    // switch(p->type) {
    // case typeCon:       return p->con.value;
    // case typeId:        return sym[p->id.i];
    // case typeOpr:
        //switch(p->opr.oper) {
        // case WHILE:     while(ex(p->opr.op[0])) ex(p->opr.op[1]); return 0;
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
