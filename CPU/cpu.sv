/* verilator lint_off UNOPTFLAT */

module cpu #(
    parameter   DATA_WIDTH = 32           // Parameters
)(
    input logic                     clk,      // Input/Output Logic
    input logic                     rst,
    output logic [DATA_WIDTH-1:0]   a0                  
);
    logic [DATA_WIDTH-1:0] ALUop1;          // Interconnecting Wires For ALU
    logic [DATA_WIDTH-1:0] ALUOut;
    logic [2:0]            ALUctrl;
    logic                  ALUsrc;
    logic                  zero;

    logic [DATA_WIDTH-1:0] regOp2;         // Interconnecting Wires For RegFile
    logic                  RegWrite;
    logic                  ResultSrc;

    logic [DATA_WIDTH-1:0] ImmOp;          // Interconnecting Wires For Sign Extend
    logic [2:0]            ImmSrc;

    logic [DATA_WIDTH-1:0] instr;           // Interconnecting Wires For PC
    logic [DATA_WIDTH-1:0] pc;
    logic [DATA_WIDTH-1:0] next_pc;
    logic                  PCsrc;
    
    logic [DATA_WIDTH-1:0] ReadData;        // Interconnecting Wires For Data Memory
    logic                  MemWrite;

    RegFile RegFile (          
        .clk (clk),
        .ad1 (instr[19:15]),
        .ad2 (instr[24:20]),
        .ad3 (instr[11:7]),
        .we3 (RegWrite),
        .wd3 (ResultSrc ? ReadData : ALUOut),
        .rd1 (ALUop1),
        .rd2 (regOp2),
        .a0 (a0)
    );

    ALU ALU (
        .ALUop1 (ALUop1),
        .ALUop2 (ALUsrc ? ImmOp : regOp2),
        .ALUOut (ALUOut),
        .zero_o (zero),
        .ALUctrl (ALUctrl)
    );

    SignExtend SignExtend (
        .ImmOp (ImmOp),
        .ImmSrc (ImmSrc),
        .instr (instr[31:7])
    );

    InstrMem InstrMem (
        .instr  (instr),
        .PC     (pc)
    );

    PC_register PCReg (
        .PC     (pc),
        .inc    (next_pc),
        .clk    (clk),
        .rst    (rst)
    );
    
    next_PC PCMux (
        .next_PC (next_pc),
        .PC (pc),
        .ImmOp (ImmOp),
        .PCsrc (PCsrc)
    );

    ControlUnit ControlUnit (
        .instr_i (instr[6:0]),
        .zero_i    (zero),
        .PCSrc_o (PCsrc),
        .ResultSrc_o (ResultSrc),
        .MemWrite_o (MemWrite),
        .ALUControl_o (ALUctrl),
        .ALUSrc_o (ALUsrc)
        .ImmSrc_o (ImmSrc),
        .RegWrite_o (RegWrite)
    );
    
    DataMem DataMem (
        .clk (clk),
        .Address (ALUout),
        .WriteData (regOp2),
        .we (MemWrite),  //Control Unit needed
        .ReadData (ReadData)
    );
    

endmodule
