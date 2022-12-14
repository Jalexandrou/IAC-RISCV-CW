module cpu #(
    parameter   DATA_WIDTH = 32            // Parameters
)(
    input logic                     clk,   // Input/Output Logic
    input logic                     rst,
    output logic [DATA_WIDTH-1:0]   a0                  
);

//interconnecting wires before first pipeline register
    logic [DATA_WIDTH-1:0] RD;          
    logic [DATA_WIDTH-1:0] PCF;
    logic [DATA_WIDTH-1:0] next_pc;
    logic [DATA_WIDTH-1:0] PC_Plus4F;
    logic                  PCsrcRegE;

//interconnecting wires before second pipeline register
    logic [DATA_WIDTH-1:0] InstrD;
    logic [DATA_WIDTH-1:0] PCD;
    logic [DATA_WIDTH-1:0] PC_Plus4D;        
    logic                  RegWriteD;
    logic [1:0]            ResultSrcD;
    logic                  JumpD;
    logic                  BranchD;
    logic [DATA_WIDTH-1:0] ImmExtD;          
    logic [2:0]            ImmSrcD;
    logic                  MemWriteD;
    logic [2:0]            ALUControlD;
    logic                  ALUSrcD;
    logic                  PCsrcD;
    logic                  PCsrcRegD;
    logic [DATA_WIDTH-1:0] RD1;        
    logic [DATA_WIDTH-1:0] RD2;
    logic [DATA_WIDTH-1:0] RdD;
    logic                  branchD;
    logic                  JlinkD;
    
//interconnecting wires before third pipeline register
    logic [DATA_WIDTH-1:0] PCE;
    logic [DATA_WIDTH-1:0] RD1E;         
    logic [DATA_WIDTH-1:0] RD2E;
    logic [DATA_WIDTH-1:0] RdE;  
    logic [DATA_WIDTH-1:0] ImmExtE;          
    logic [DATA_WIDTH-1:0] ALUResultE;
    logic [DATA_WIDTH-1:0] PC_Plus4E;        
    logic                  RegWriteE;
    logic [1:0]            ResultSrcE;
    logic                  JumpE;
    logic                  BranchE;
    logic [DATA_WIDTH-1:0] ImmExtE;          
    logic                  MemWriteE;
    logic [2:0]            ALUControlE;
    logic                  ALUsrcE;
    logic                  ZeroE;
    logic                  PCsrcE;
    logic                  PCsrcRegE;
    logic                  StorePCE;
    logic                  branchE;
    logic                  JlinkE;
    
//interconnecting wires before fourth pipeline register
    logic [DATA_WIDTH-1:0] PC_Plus4M;
    logic [DATA_WIDTH-1:0] RdM;      
    logic [DATA_WIDTH-1:0] ALUResultM;
    logic [DATA_WIDTH-1:0] WriteDataM;
    logic [DATA_WIDTH-1:0] ReadDataM;     
    logic                  RegWriteM;
    logic [1:0]            ResultSrcM;
    logic                  MemWriteM;
    logic                  StorePCM;

//interconnecting wires after fourth pipeline register
    logic                  RegWriteW;
    logic [1:0]            ResultSrcW;
    logic [DATA_WIDTH-1:0] ReadDataW;     
    logic [DATA_WIDTH-1:0] RdW;      
    logic [DATA_WIDTH-1:0] PC_Plus4W;
    logic                  StorePCW;


    PC_Next PCMux (
        .PC_i (PCF),
        .PC_i2 (PCE),
        .ImmOp_i (ImmExtE),
        .PC_Jalr_i (ALUResultE),
        .PCsrc_i (PCsrcE),
        .PCsrcReg_i (PCsrcRegE),
        .PC_Next_o (next_pc),
        .PC_Plus4_o (PC_Plus4F)
    );

    PC_Register PCReg (
        .PC_o         (PCF),
        .PC_Next_i    (next_pc),
        .clk          (clk),
        .rst          (rst)
    );
    
    InstrMem InstrMem (
        .instr  (RD),
        .PC     (PCF)
    );

    always_ff @ (negedge clk)
    //register after instruction memory
        InstrD <= RD;
        PCD <= PCF;
        PCPlus4D <= PCPlus4F;

    RegFile RegFile (          
        .clk (clk),
        .ad1 (InstrD[19:15]),
        .ad2 (InstrD[24:20]),
        .ad3 (RdW),
        .we3 (RegWriteW),
        .wd3 (StorePCW ? PC_Plus4 : (ResultSrcW ? ReadDataW : ALUResultM)), 
        .rd1 (RD1),
        .rd2 (RD2),
        .a0 (a0)
    );

    SignExtend SignExtend (
        .ImmOp (ImmExtD),
        .ImmSrc (ImmSrcD),
        .instr (InstrD[31:7])
    );

    ControlUnit ControlUnit (
        .instr_i (InstrD),
        .zero_i  (ZeroE),
        .PCSrc_o (PCsrcD),
        .PCSrcReg_o (PCsrcRegD),
        .StorePC_o  (StorePCD), 
        .ResultSrc_o (ResultSrcD),
        .MemWrite_o (MemWriteD),
        .ALUControl_o (ALUControlD),
        .ALUSrc_o (ALUSrcD),
        .ImmSrc_o (ImmSrcD),
        .RegWrite_o (RegWriteD),
        .branch_o(BranchD),
        .Jlink_o(JlinkD)
        .ByteOp(ByteOpD),
    );

    
    always_ff @ (negedge clk)
        // register after control unit and register file
        PCsrcRegE <= PCsrcRegD;
        RD1E <= RD1;
        RD2E <= RD2;
        PCE <= PCD;
        RdE <= RdD;
        ImmExtE <= ImmExtD;
        PCPlus4E <= PCPlus4D;
        RegWriteE <= RegWriteD;
        ResultSrcE <= ResultSrcD;
        MemWriteE <= MemWriteD;
        ALUControlE <= ALUControlD;
        ALUSrcE <= ALUSrcD;
        ImmSrcE <= ImmSrcD;
        StorePCE <= StorePCD;
        branchE <= branchD;
        JlinkE <= JlinkD;
        ByteOpE <= ByteOpD;

    ALU ALU (
        .ALUop1 (RD1E),
        .ALUop2 (ALUSrcE ? ImmExtE : RD2E),
        .ALUout (ALUResultE),
        .zero_o (ZeroE),
        .ALUctrl (ALUControlE)
    );

    always_ff @ (negedge clk)
        //register after ALU
        ALUResultM <= ALUResultE;
        WriteDataM <= WriteDataE;
        RdM <= RdE;
        PCPlus4M <= PCPlus4E;
        RegWriteM <= RegWriteE;
        ResultSrcM <= ResultSrcE;
        MemWriteM <= MemWriteE;
        StorePCM <= StorePCE;
        ByteOpM <= ByteOpE;

    DataMem DataMem (
        .clk (clk),
        .Address (ALUResultM),
        .WriteData (WriteDataM),
        .we (MemWriteM),  
        .ByteOp  (ByteOpM),
        .ReadData (ReadDataM)
    );
    
    always_ff @ (negedge clk)
        //register after data memory
        ReadDataW <= Rd;
        RdW <= RdM;
        PCPlus4W <= PCPlus4M;
        RegWriteW <= RegWriteM;
        ResultSrcW <= ResultSrcM;
        StorePCW <= StorePCM;

endmodule
