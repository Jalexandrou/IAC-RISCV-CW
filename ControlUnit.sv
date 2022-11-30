module ControlUnit #(
    parameter INSTR_WIDTH = 32
)(
	input 	logic               eq_i,
	input   [INSTR_WIDTH-1:0]   instr_i,

	output  logic               PCSrc_o,
    output  logic               ResultSrc_o,
    output  logic               MemWrite_o,
    output  [2:0]               ALUControl_o,
    output  logic               ALUSrc_o,
    output  [1:0]               ImmSrc_o,
    output  logic               RegWrite_o
);

    logic   [6:0]               opcode;
    logic   [4:0]               rd;
    logic   [4:0]               rs1;
    logic   [4:0]               rs2;
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

    always_comb begin
    	case (instr[6:0])
            addi: begin	
                RegWrite = 1;		
    			ALUctrl = 0;
    	        ALUsrc = 1;
    	        ImmSrc = 0;
    	        PCsrc = 0;
    		end
    		bne: if (!EQ) begin
    			RegWrite = 0;		
    			ALUctrl = 001; //check if this is required for value of EQ
    	        ALUsrc = 0;
    	        ImmSrc = 3;
    	        PCsrc = 1;
    		end
    		default: begin
    			RegWrite = 0; // Ensure no register is written to by default
                ALUctrl = 0;
    	        ALUsrc = 0;
    	        ImmSrc = 0;
    	        PCsrc = 0;
    		end
    	endcase
    end

endmodule
