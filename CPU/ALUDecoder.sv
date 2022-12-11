module ALUDecoder #()(
    input  [2:0]    func3,
    input  [6:0]    func7,
    input  logic    op5,
    input  logic    op4,
    input  [1:0]    ALUOp,
    input  logic    branch,
    input  logic    zero,

    output [2:0]    ALUControl_o,
    output          PCSrc_o
);

always_comb begin
    case(ALUOp)
        2'b00: ALUControl_o = 3'b000;
        2'b01: ALUControl_o = 3'b001;
        2'b10: begin
            case(func3)
                3'b001: begin
                    case(op4)
                        1'b1: ALUControl_o = 3'b110;   //left shift for slli instruction
                        default: ALUControl_o = 3'b000;
                    endcase
                end 
                3'b010: ALUControl_o = 3'b101;
                3'b110: ALUControl_o = 3'b011;
                3'b111: ALUControl_o = 3'b010;
                3'b000: begin
                    case({op5, func7[5]})
                        2'b11: ALUControl_o = 3'b001;
                        default: ALUControl_o = 3'b000;
                    endcase
                end
                default: ALUControl_o = 3'b111; //Idk what to put as of yet
            endcase
        end
        default: ALUControl_o = 3'b111; //Idk what to put as of yet
    endcase
end

always_comb begin
            case(func3)
                3'b001: begin   // for bne, branch if alu output not zero
                    if(branch && !zero) begin 
                            PCSrc_o = 1; 
                    end                
                end
                default: PCSrc_o = 0;
            endcase
end

endmodule
