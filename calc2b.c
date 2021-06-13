#include <stdio.h>
#include "symbol_table.h"
#include "y.tab.h"

static int lbl;

int ex(struct DataItem *p) {
    int lbl1, lbl2;

    if (!p) return 0;
    p->nodeType.type;
    switch(p->nodeType.type) {
    case typeCon:       
        printf("\tpush\t%d\n", p->nodeType.con.value); 
        break;
    case typeId:        
        printf("\tpush\t%c\n", p->nodeType.id.i); 
        break;
    case typeOpr:
        switch(p->nodeType.opr.oper) {
        case FUNCTION:
            // printf("ENTERED\n");
            // //printf("$%c", p->Variable_Name);
            // //printf(":");
            ex(p->nodeType.opr.op[0]);
            ex(p->nodeType.opr.op[1]);
            printf("RET\n");
            break;
        case FUNCNAME:
            printf("$%c", p->nodeType.opr.op[0]->nodeType.id.i);
            printf(":\n");
            break;
        case CALL:
            printf("call %c", p->nodeType.opr.op[0]->nodeType.id.i);
            break;
        case WHILE:
            printf("L%03d:\n", lbl1 = lbl++);
            ex(p->nodeType.opr.op[0]);
            printf("\tjz\tL%03d\n", lbl2 = lbl++);
            ex(p->nodeType.opr.op[1]);
            printf("\tjmp\tL%03d\n", lbl1);
            printf("L%03d:\n", lbl2);
            break;
        case FOR:
            //printf("declared i = 0\n"); //to be replaced with dec logic
            ex(p->nodeType.opr.op[0]);
            printf("L%03d:\n", lbl1 = lbl++);
            ex(p->nodeType.opr.op[1]);
            printf("\tjz\tL%03d\n", lbl2 = lbl++);
            ex(p->nodeType.opr.op[3]);
            ex(p->nodeType.opr.op[2]);
            printf("\tjmp\tL%03d\n", lbl1);
            printf("L%03d:\n", lbl2);
            break;
        case REPEAT:
            printf("L%03d:\n", lbl1 = lbl++);
            ex(p->nodeType.opr.op[0]);
            ex(p->nodeType.opr.op[1]);
            printf("\tjz\tL%03d\n", lbl2 = lbl++);
            printf("\tjmp\tL%03d\n", lbl1);
            printf("L%03d:\n", lbl2);
            break;
        case SWITCH:
            //printf("Entered\n");
            ex(p->nodeType.opr.op[0]);
            ex(p->nodeType.opr.op[1]);
            // printf("\tjmp\tL%03d\n", lbl);
            // printf("L%03d:\n", lbl2 = lbl-1);
            ex(p->nodeType.opr.op[2]);
            printf("L%03d:\n", lbl1 = lbl++);
            break;
        case CASE:
            ex(p->nodeType.opr.op[0]);
            printf("\tcompEQ\n");
            printf("\tjz\tL%03d\n", lbl2 = lbl++);
            ex(p->nodeType.opr.op[1]);
            printf("\tjmp\tL%03d\n", lbl);
            printf("L%03d:\n", lbl2 = lbl-1);
            ex(p->nodeType.opr.op[2]);
            break;
        case IF:
            ex(p->nodeType.opr.op[0]);
            if (p->nodeType.opr.nops > 2) {
                /* if else */
                printf("\tjz\tL%03d\n", lbl1 = lbl++);
                ex(p->nodeType.opr.op[1]);
                printf("\tjmp\tL%03d\n", lbl2 = lbl++);
                printf("L%03d:\n", lbl1);
                ex(p->nodeType.opr.op[2]);
                printf("L%03d:\n", lbl2);
            } else {
                /* if */
                printf("\tjz\tL%03d\n", lbl1 = lbl++);
                ex(p->nodeType.opr.op[1]);
                printf("L%03d:\n", lbl1);
            }
            break;
        // case PRINT:     
        //     ex(p->nodeType.opr.op[0]);
        //     printf("\tprint\n");
        //     break;
        case NOTHING:
            break;
        case '=':       
            ex(p->nodeType.opr.op[1]);
            printf("\tpop\t%c\n", p->nodeType.opr.op[0]->nodeType.id.i);
            break;
        case UMINUS:   
            ex(p->nodeType.opr.op[0]);
            printf("\tneg\n");
            break;
        case INC:
            ex(p->nodeType.opr.op[0]);
            printf("\tpush\t1\n");
            printf("\tadd\n");
            printf("\tpop\t%c\n", p->nodeType.opr.op[0]->nodeType.id.i);
            break;
        case DEC:
            ex(p->nodeType.opr.op[0]);
            printf("\tpush\t1\n");
            printf("\tsub\n");
            printf("\tpop\t%c\n", p->nodeType.opr.op[0]->nodeType.id.i);
            break;
        default:
            ex(p->nodeType.opr.op[0]);
            ex(p->nodeType.opr.op[1]);
            switch(p->nodeType.opr.oper) {
            case '+':   printf("\tadd\n"); break;
            case '-':   printf("\tsub\n"); break; 
            case '*':   printf("\tmul\n"); break;
            case '/':   printf("\tdiv\n"); break;
            case '<':   printf("\tcompLT\n"); break;
            case '>':   printf("\tcompGT\n"); break;
            case GE:    printf("\tcompGE\n"); break;
            case LE:    printf("\tcompLE\n"); break;
            case NE:    printf("\tcompNE\n"); break;
            case EQ:    printf("\tcompEQ\n"); break;
            }
        }
    }
    return 0;
}
