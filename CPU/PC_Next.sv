module PC_Next #(
    parameter WIDTH = 32
)(
    // interface signals
    input logic [WIDTH-1:0]     PC_i,         //PC cycle
    input logic [WIDTH-1:0]     ImmOp_i,      //Immediate Operand 
    input logic                 PCsrc_i,      //PC src 
    output logic [WIDTH-1:0]    PC_Next_o     //next PC output
);

    logic [WIDTH-1:0]   branch_PC;
    logic [WIDTH-1:0]   inc_PC;

    assign branch_PC = PC_i + ImmOp_i;
    assign inc_PC = PC_i + 4;
    assign PC_Next_o = PCsrc_i ? branch_PC : inc_PC;
    
endmodule
