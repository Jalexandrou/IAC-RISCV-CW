module ControlUnit #(
    parameter INSTR_WIDTH = 32
)(
	input 	logic               eq_i,
	input   [INSTR_WIDTH-1:0]   instr_i,
    input   logic               zero_i

	output  logic               PCSrc_o,
    output  logic               ResultSrc_o,
    output  logic               MemWrite_o,
    output  [2:0]               ALUControl_o,
    output  logic               ALUSrc_o,
    output  [1:0]               ImmSrc_o,
    output  logic               RegWrite_o
);

    logic   [6:0]               opcode;
    logic   [2:0]               func3;
    logic   [6:0]               func7;

    assign opcode = instr[6:0];
    assign funct3 = instr[14:12];
    assign funct7 = instr[31:25];

    ALUDecoder ALUDecoder (
        .func3          (func3),
        .func7          (func7),
        .op5            (opcode[5]),
        .ALUOp          (WIP),
        .ALUControl_o   (ALUControl_o)
    );

    logic                       branch;

    ControlUnitDecoder ControlUnitDecoder (
        .opcode         (opcode),
        .Branch_o       (branch),
        .ResultSrc_o    (ResultSrc_o),
        .MemWrite_o     (MemWrite_o),
        .ALUSrc_o       (ALUSrc_o),
        .IMMSrc_o       (ImmSrc_o),
        .RegWrite_o     (RegWrite_o)
    )
    
    assign PCSrc_o = branch & zero_i; 

endmodule
