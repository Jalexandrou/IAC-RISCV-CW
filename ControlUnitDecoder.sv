module ControlUnitDecoder #()(
    input [6:0] opcode,

	output  logic               Branch_o,
    output  logic               ResultSrc_o,
    output  logic               MemWrite_o,
    output  logic               ALUSrc_o,
    output  [1:0]               ImmSrc_o,
    output  logic               RegWrite_o
);

endmodule
