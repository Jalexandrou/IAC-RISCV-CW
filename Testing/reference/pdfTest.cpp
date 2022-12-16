#include "Vcpu.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "vbuddy.cpp"

#include <iostream>
#include <vector>
#include <string>

#define MAX_SIM_CYC 1000000

int main(int argc, char **argv, char **env) {
    int simcyc;  
    int clk;

    Verilated::commandArgs(argc, argv);
    Vcpu* top = new Vcpu;

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;

    top->trace(tfp, 99);
    tfp->open ("cpu.vcd");

    //initialise vbuddy
    if (vbdOpen()!=1) return(-1);
    vbdHeader("Calculating PDF");
    vbdSetMode(0);

    top->clk = 0;
    top->rst = 0;

    bool StoreNextVal = 0;
    int ValuesStored = 0;
    int Pdf_Values[1024];

    for (simcyc=0; simcyc<MAX_SIM_CYC; simcyc++) {

        for (clk=0; clk<2; clk++) {
            tfp->dump (2*simcyc+clk);
            top->clk = !top->clk;
            top->eval ();
        }

        if (StoreNextVal) {
            if (ValuesStored <= 1023) {
              Pdf_Values[ValuesStored] = top->a0;
              ValuesStored++;
              StoreNextVal = 0;
            } 
            else break;
        }

        if (int(top->a0) == -1) StoreNextVal = 1;

        if (Verilated::gotFinish()){ 
            vbdClose();    
            tfp->close();
            exit(0);
        }

    }

    vbdHeader("PDF");
    for (int i = 1; i <= 720; i++){             //Changed value here to 720 (3*240)
        if(Pdf_Values[i] != -1){
          std::cout << "X: " << i << " Y: " << Pdf_Values[i] << std::endl;
          vbdPlot(Pdf_Values[i], 10, 190);  //Scaled the display slighty so the top and bottom values can be seen more clearly
        }                                         
    }

    vbdClose();
    exit(0);

}
