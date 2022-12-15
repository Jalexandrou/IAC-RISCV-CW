#include "Vcpu.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "vbuddy.cpp"


int main(int argc, char **argv, char **env) {
    int i;
    int clk;
    bool flag;

    Verilated::commandArgs(argc, argv);
    Vcpu* top = new Vcpu;

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;

    top->trace(tfp, 99);
    tfp->open ("cpu.vcd");

    if (vbdOpen()!=1) return (-1);
    vbdHeader("F1 Sequence");

    top->clk = 0;
    top->rst = 0;
    top->trg = 0;

    vbdSetMode(1);

    for (i=0; i<10000; i++) {

        for (clk=0; clk<2; clk++) {
            tfp->dump (2*i+clk);
            top->clk = !top->clk;
            top->eval ();
        }

        flag = vbdFlag();
        top->rst = flag && (vbdValue() == 0);
        top->trg = flag && (vbdValue() == 1);
        vbdBar(top->a0 & 0xFF);
        vbdCycle(i);
        

        if (Verilated::gotFinish()){     
            tfp->close();
            exit(0);
        }

    }

}