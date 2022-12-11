module ControlUnit #(
    parameter INSTR_WIDTH = 32
)(
	input   [INSTR_WIDTH-1:0]   instr_i,
    input   logic               zero_i,

	output  logic               PCSrc_o,
    output  logic               ResultSrc_o,
    output  logic               MemWrite_o,
    output  [2:0]               ALUControl_o,
    output  logic               ALUSrc_o,
    output  [2:0]               ImmSrc_o,
    output  logic               RegWrite_o
);

    logic   [6:0]               opcode;
    logic   [2:0]               func3;
    logic   [6:0]               func7;
    logic   [1:0]               ALUOp;
    logic                       branch;

    assign opcode = instr_i[6:0];
    assign func3 = instr_i[14:12];
    assign func7 = instr_i[31:25];


    ALUDecoder ALUDecoder (
        .func3          (func3),
        .func7          (func7),
        .op5            (opcode[5]),
        .ALUOp          (ALUOp),
        .ALUControl_o   (ALUControl_o),
        .branch         (branch),
        .zero           (zero_i),
        .PCSrc_o        (PCSrc_o)
    );

    ControlUnitDecoder ControlUnitDecoder (
        .opcode_i       (opcode),
        .Branch_o       (branch),
        .ResultSrc_o    (ResultSrc_o),
        .MemWrite_o     (MemWrite_o),
        .ALUSrc_o       (ALUSrc_o),
        .ImmSrc_o       (ImmSrc_o),
        .RegWrite_o     (RegWrite_o),
        .ALUOp_o        (ALUOp)
    );
    

endmodule
