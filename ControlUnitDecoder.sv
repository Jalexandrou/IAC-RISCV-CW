module ControlUnitDecoder #()(
    input [6:0] opcode,

	output  logic               Branch_o,
    output  logic               ResultSrc_o,
    output  logic               MemWrite_o,
    output  logic               ALUSrc_o,
    output  [1:0]               ImmSrc_o,
    output  logic               RegWrite_o
);

typedef enum bit[6:0]   {
        RType    =   7'b0110011,
        Load     =   7'b0000011,
        IType    =   7'b0010011,
        SType    =   7'b0100011,
        BType    =   7'b1100011,
        AddUpp   =   7'b0010111,
        LoadUpp  =   7'b0110111,
        JumpImm  =   7'b1100111,
        JumpLink =   7'b1101111
    }                           Opcode;

endmodule
