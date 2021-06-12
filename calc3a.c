#include <stdio.h>
#include "symbol_table.h"
#include "y.tab.h"

struct DataItem* ex(struct DataItem *p) {

        printf("test %d  %d\n", p->opr.op[0]->data,  p->opr.op[1]->data);
        struct DataItem* dummy = malloc(sizeof(struct DataItem));
        dummy->data = p->opr.op[0]->data + p->opr.op[1]->data;
        dummy->DataType = 2;
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
