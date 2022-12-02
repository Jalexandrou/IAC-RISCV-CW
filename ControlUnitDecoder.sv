module ControlUnitDecoder #()(
    input [6:0]                 opcode_i,

	output  logic               Branch_o,
    output  logic               ResultSrc_o,
    output  logic               MemWrite_o,
    output  logic               ALUSrc_o,
    output  [1:0]               ImmSrc_o,
    output  logic               RegWrite_o,
    output  [1:0]               ALUOp_o
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

    always_comb begin
        case (opcode)
            RType: begin
                Branch_o    = 1'b0;
                ResultSrc_o = 1'b0;
                MemWrite_o  = 1'b0;
                ALUSrc_o    = 1'b0;
                ImmSrc_o    = 2'b0;
                RegWrite_o  = 1'b1;
            end
            Load: begin
                Branch_o    = 1'b0;
                ResultSrc_o = 1'b1;
                MemWrite_o  = 1'b0;
                ALUSrc_o    = 1'b0;
                ImmSrc_o    = 2'b0;
                RegWrite_o  = 1'b1;
            end
            IType: begin
                Branch_o    = 1'b0;
                ResultSrc_o = 1'b0;
                MemWrite_o  = 1'b0;
                ALUSrc_o    = 1'b0;
                ImmSrc_o    = 2'b0;
                RegWrite_o  = 1'b1;
            end
            SType: begin
                Branch_o    = 1'b0;
                ResultSrc_o = 1'b0;
                MemWrite_o  = 1'b1;
                ALUSrc_o    = 1'b0;
                ImmSrc_o    = 2'b0;
                RegWrite_o  = 1'b0;
            end
            BType: begin
                Branch_o    = 1'b0;
                ResultSrc_o = 1'b0;
                MemWrite_o  = 1'b0;
                ALUSrc_o    = 1'b0;
                ImmSrc_o    = 2'b0;
                RegWrite_o  = 1'b0;
            end
            AddUp: begin
                Branch_o    = 1'b0;
                ResultSrc_o = 1'b0;
                MemWrite_o  = 1'b0;
                ALUSrc_o    = 1'b0;
                ImmSrc_o    = 2'b0;
                RegWrite_o  = 1'b1;
            end
            LoadUpp: begin
                Branch_o    = 1'b0;
                ResultSrc_o = 1'b0;
                MemWrite_o  = 1'b0;
                ALUSrc_o    = 1'b0;
                ImmSrc_o    = 2'b0;
                RegWrite_o  = 1'b1;
            end
            JumpImm: begin
                Branch_o    = 1'b0;
                ResultSrc_o = 1'b0;
                MemWrite_o  = 1'b0;
                ALUSrc_o    = 1'b0;
                ImmSrc_o    = 2'b0;
                RegWrite_o  = 1'b0;
            end
            JumpLink: begin
                Branch_o    = 1'b0;
                ResultSrc_o = 1'b0;
                MemWrite_o  = 1'b0;
                ALUSrc_o    = 1'b0;
                ImmSrc_o    = 2'b0;
                RegWrite_o  = 1'b0;
            end
            default: begin
                Branch_o    = 1'b0;
                ResultSrc_o = 1'b0;
                MemWrite_o  = 1'b0;
                ALUSrc_o    = 1'b0;
                ImmSrc_o    = 2'b0;
                RegWrite_o  = 1'b0;
            end
        endcase
    end

endmodule
