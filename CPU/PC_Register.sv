module PC_Register #(
    parameter WIDTH = 32
)(
    // interface signals
    input logic                 clk,          //clock
    input logic                 rst,          //reset
    input logic                 trg,          //trigger
    input logic  [WIDTH-1:0]    PC_Next_i,    //PC Input 
    output logic [WIDTH-1:0]    PC_o          //PC Output
);

always_ff @ (posedge clk)
    if (rst) PC_o <= {WIDTH{1'b0}};
    else if (trg) PC_o <= {32'b1100};
    else     PC_o <= PC_Next_i;
    
endmodule
