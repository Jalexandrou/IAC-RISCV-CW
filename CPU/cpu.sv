module cpu #(
    parameter   DATA_WIDTH = 32            // Parameters
)(
    input logic                     clk,   // Input/Output Logic
    input logic                     rst,
    output logic [DATA_WIDTH-1:0]   a0
);

//interconnecting wires before first pipeline register
             
    logic [DATA_WIDTH-1:0] PCF;
    logic [DATA_WIDTH-1:0] next_pc;
    logic [DATA_WIDTH-1:0] PCPlus4F;

//interconnecting wires before second pipeline register
    logic [DATA_WIDTH-1:0] PCD;
    logic [DATA_WIDTH-1:0] PCPlus4D;        
    logic                  RegWriteD;
    logic                  ResultSrcD;
    logic [DATA_WIDTH-1:0] ImmExtD;          
    logic [2:0]            ImmSrcD;
    logic                  MemWriteD;
    logic [2:0]            ALUControlD;
    logic                  ALUSrcD;
    logic                  PCsrcRegD;
    logic [DATA_WIDTH-1:0] RD1;        
    logic [DATA_WIDTH-1:0] RD2;
    logic                  branchD;
    logic                  JlinkD;
    logic                  StorePCD;
    logic                  ByteOpD;
    logic [DATA_WIDTH-1:0] RD;
    logic [DATA_WIDTH-1:0] InstrD;


//interconnecting wires before third pipeline register
    logic [DATA_WIDTH-1:0] PCE;
    logic [DATA_WIDTH-1:0] RD1E;         
    logic [DATA_WIDTH-1:0] RD2E;
    logic [DATA_WIDTH-1:0] ALUResultE;
    logic [DATA_WIDTH-1:0] ImmExtE;          
    logic [DATA_WIDTH-1:0] PCPlus4E; 
    logic [4:0]            RdE;       
    logic                  RegWriteE;
    logic                  ResultSrcE;
    logic                  MemWriteE;
    logic [2:0]            ALUControlE;
    logic                  ALUSrcE;
    logic                  ZeroE;
    logic                  PCsrcE;
    logic                  PCsrcRegE;
    logic                  StorePCE;
    logic                  branchE;
    logic                  JlinkE;
    logic                  ByteOpE;

//interconnecting wires before fourth pipeline register
    logic [DATA_WIDTH-1:0] PCPlus4M;
    logic [4:0]            RdM;      
    logic [DATA_WIDTH-1:0] ALUResultM;
    logic [DATA_WIDTH-1:0] WriteDataM;
    logic [DATA_WIDTH-1:0] ReadDataM;     
    logic                  RegWriteM;
    logic                  ResultSrcM;
    logic                  MemWriteM;
    logic                  StorePCM;
    logic                  ByteOpM;

//interconnecting wires after fourth pipeline register
    logic                  RegWriteW;
    logic                  ResultSrcW;
    logic [DATA_WIDTH-1:0] ReadDataW;     
    logic [4:0]            RdW;      
    logic [DATA_WIDTH-1:0] PCPlus4W;
    logic                  StorePCW;
    logic [DATA_WIDTH-1:0] ALUResultW;

    PC_Next PCMux (
        .PC_i (PCF),
        .PC_i2 (PCE),
        .ImmOp_i (ImmExtE),
        .PC_Jalr_i (ALUResultE),
        .PCsrc_i (PCsrcE),
        .PCsrcReg_i (PCsrcRegE),
        .PC_Next_o (next_pc),
        .PC_Plus4_o (PCPlus4F)
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

    always_ff @ (negedge clk) begin
    //register after instruction memory
        InstrD <= RD;
        PCD <= PCF;
        PCPlus4D <= PCPlus4F;
    end 
    
    RegFile RegFile (          
        .clk (clk),
        .ad1 (InstrD[19:15]),
        .ad2 (InstrD[24:20]),
        .ad3 (RdW),
        .we3 (RegWriteW),
        .wd3 (StorePCW ? PCPlus4W : (ResultSrcW ? ReadDataW : ALUResultW)), 
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
        .PCSrcReg_o (PCsrcRegD),
        .StorePC_o  (StorePCD), 
        .ResultSrc_o (ResultSrcD),
        .MemWrite_o (MemWriteD),
        .ALUControl_o (ALUControlD),
        .ALUSrc_o (ALUSrcD),
        .ImmSrc_o (ImmSrcD),
        .RegWrite_o (RegWriteD),
        .branch_o(branchD),
        .Jlink_o(JlinkD),
        .ByteOp(ByteOpD)
    );

    always_ff @ (negedge clk) begin
        // register after control unit and register file
        PCsrcRegE <= PCsrcRegD;
        RD1E <= RD1;
        RD2E <= RD2;
        PCE <= PCD;
        RdE <= InstrD[11:7];
        ImmExtE <= ImmExtD;
        PCPlus4E <= PCPlus4D;
        RegWriteE <= RegWriteD;
        ResultSrcE <= ResultSrcD;
        MemWriteE <= MemWriteD;
        ALUControlE <= ALUControlD;
        ALUSrcE <= ALUSrcD;
        StorePCE <= StorePCD;
        branchE <= branchD;
        JlinkE <= JlinkD;
        ByteOpE <= ByteOpD;
    end 

    ALU ALU (
        .ALUop1 (RD1E),
        .ALUop2 (ALUSrcE ? ImmExtE : RD2E),
        .ALUout (ALUResultE),
        .zero_o (ZeroE),
        .ALUctrl (ALUControlE)
    );

    assign PCsrcE = (branchE & !ZeroE) || JlinkE;
    
    always_ff @ (negedge clk) begin
        //register after ALU
        ALUResultM <= ALUResultE;
        WriteDataM <= RD2E;
        RdM <= RdE;
        PCPlus4M <= PCPlus4E;
        RegWriteM <= RegWriteE;
        ResultSrcM <= ResultSrcE;
        MemWriteM <= MemWriteE;
        StorePCM <= StorePCE;
        ByteOpM <= ByteOpE;
    end 
    
    DataMem DataMem (
        .clk (clk),
        .Address (ALUResultM),
        .WriteData (WriteDataM),
        .we (MemWriteM),  
        .ByteOp  (ByteOpM),
        .ReadData (ReadDataM)
    );
    
    always_ff @ (negedge clk) begin 
        //register after data memory
        ReadDataW <= ReadDataM;
        RdW <= RdM;
        PCPlus4W <= PCPlus4M;
        RegWriteW <= RegWriteM;
        ResultSrcW <= ResultSrcM;
        StorePCW <= StorePCM;
        ALUResultW <= ALUResultM;
    end 

endmodule
