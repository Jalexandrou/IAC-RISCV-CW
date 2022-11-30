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


typedef enum bit[6:0]   {addi = 7'b0010011, bne = 7'b1100011}   Opcode;

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
