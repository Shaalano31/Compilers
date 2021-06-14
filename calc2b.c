#include <stdio.h>
#include "symbol_table.h"
#include "y.tab.h"

static int lbl;
extern FILE* output;

int ex(struct DataItem *p) {
    int lbl1, lbl2;

    if (!p) return 0;
    p->nodeType.type;
    switch(p->nodeType.type) {
    case typeCon:       
        fprintf(output, "\tpush\t%d\n", p->nodeType.con.value); 
        break;
    case typeId:        
        fprintf(output, "\tpush\t%c\n", p->nodeType.id.i); 
        break;
    case typeOpr:
        switch(p->nodeType.opr.oper) {
        case FUNCTION:
            // ffprintf(output, output, "ENTERED\n");
            // //ffprintf(output, output, "$%c", p->Variable_Name);
            // //ffprintf(output, output, ":");
            ex(p->nodeType.opr.op[0]);
            ex(p->nodeType.opr.op[1]);
            fprintf(output, "RET\n");
            break;
        case FUNCNAME:
            fprintf(output, "$%c", p->nodeType.opr.op[0]->nodeType.id.i);
            fprintf(output, ":\n");
            break;
        case CALL:
            fprintf(output, "call %c\n", p->nodeType.opr.op[0]->nodeType.id.i);
            break;
        case WHILE:
            fprintf(output, "L%03d:\n", lbl1 = lbl++);
            ex(p->nodeType.opr.op[0]);
            fprintf(output, "\tjz\tL%03d\n", lbl2 = lbl++);
            ex(p->nodeType.opr.op[1]);
            fprintf(output, "\tjmp\tL%03d\n", lbl1);
            fprintf(output, "L%03d:\n", lbl2);
            break;
        case FOR:
            //fprintf(output, "declared i = 0\n"); //to be replaced with dec logic
            ex(p->nodeType.opr.op[0]);
            fprintf(output, "L%03d:\n", lbl1 = lbl++);
            ex(p->nodeType.opr.op[1]);
            fprintf(output, "\tjz\tL%03d\n", lbl2 = lbl++);
            ex(p->nodeType.opr.op[3]);
            ex(p->nodeType.opr.op[2]);
            fprintf(output, "\tjmp\tL%03d\n", lbl1);
            fprintf(output, "L%03d:\n", lbl2);
            break;
        case REPEAT:
            fprintf(output, "L%03d:\n", lbl1 = lbl++);
            ex(p->nodeType.opr.op[0]);
            ex(p->nodeType.opr.op[1]);
            fprintf(output, "\tjz\tL%03d\n", lbl2 = lbl++);
            fprintf(output, "\tjmp\tL%03d\n", lbl1);
            fprintf(output, "L%03d:\n", lbl2);
            break;
        case SWITCH:
            //fprintf(output, "Entered\n");
            ex(p->nodeType.opr.op[0]);
            ex(p->nodeType.opr.op[1]);
            // fprintf(output, "\tjmp\tL%03d\n", lbl);
            // fprintf(output, "L%03d:\n", lbl2 = lbl-1);
            ex(p->nodeType.opr.op[2]);
            fprintf(output, "L%03d:\n", lbl1 = lbl++);
            break;
        case CASE:
            ex(p->nodeType.opr.op[0]);
            fprintf(output, "\tcompEQ\n");
            fprintf(output, "\tjz\tL%03d\n", lbl2 = lbl++);
            ex(p->nodeType.opr.op[1]);
            fprintf(output, "\tjmp\tL%03d\n", lbl);
            fprintf(output, "L%03d:\n", lbl2 = lbl-1);
            ex(p->nodeType.opr.op[2]);
            break;
        case IF:
            ex(p->nodeType.opr.op[0]);
            if (p->nodeType.opr.nops > 2) {
                /* if else */
                fprintf(output, "\tjz\tL%03d\n", lbl1 = lbl++);
                ex(p->nodeType.opr.op[1]);
                fprintf(output, "\tjmp\tL%03d\n", lbl2 = lbl++);
                fprintf(output, "L%03d:\n", lbl1);
                ex(p->nodeType.opr.op[2]);
                fprintf(output, "L%03d:\n", lbl2);
            } else {
                /* if */
                fprintf(output, "\tjz\tL%03d\n", lbl1 = lbl++);
                ex(p->nodeType.opr.op[1]);
                fprintf(output, "L%03d:\n", lbl1);
            }
            break;
        // case PRINT:     
        //     ex(p->nodeType.opr.op[0]);
        //     fprintf(output, "\tprint\n");
        //     break;
        case NOTHING:
            break;
        case '=':       
            ex(p->nodeType.opr.op[1]);
            fprintf(output, "\tpop\t%c\n", p->nodeType.opr.op[0]->nodeType.id.i);
            break;
        case UMINUS:   
            ex(p->nodeType.opr.op[0]);
            fprintf(output, "\tneg\n");
            break;
        case INC:
            ex(p->nodeType.opr.op[0]);
            fprintf(output, "\tpush\t1\n");
            fprintf(output, "\tadd\n");
            fprintf(output, "\tpop\t%c\n", p->nodeType.opr.op[0]->nodeType.id.i);
            break;
        case DEC:
            ex(p->nodeType.opr.op[0]);
            fprintf(output, "\tpush\t1\n");
            fprintf(output, "\tsub\n");
            fprintf(output, "\tpop\t%c\n", p->nodeType.opr.op[0]->nodeType.id.i);
            break;
        case AND:
            ex(p->nodeType.opr.op[0]);
            ex(p->nodeType.opr.op[1]);
            fprintf(output, "\tAND\n");
            break;
        case OR:
            ex(p->nodeType.opr.op[0]);
            ex(p->nodeType.opr.op[1]);
            fprintf(output, "\tOR\n");
            break;
        default:
            ex(p->nodeType.opr.op[0]);
            ex(p->nodeType.opr.op[1]);
            switch(p->nodeType.opr.oper) {
            case '+':   fprintf(output, "\tadd\n"); break;
            case '-':   fprintf(output, "\tsub\n"); break; 
            case '*':   fprintf(output, "\tmul\n"); break;
            case '/':   fprintf(output, "\tdiv\n"); break;
            case '<':   fprintf(output, "\tcompLT\n"); break;
            case '>':   fprintf(output, "\tcompGT\n"); break;
            case GE:    fprintf(output, "\tcompGE\n"); break;
            case LE:    fprintf(output, "\tcompLE\n"); break;
            case NE:    fprintf(output, "\tcompNE\n"); break;
            case EQ:    fprintf(output, "\tcompEQ\n"); break;
            }
        }
    }
    return 0;
}
