module ALUDecoder #()(
    input  [2:0]    func3,
    input  [6:0]    func7,
    input  logic    op5,
    input  [1:0]    ALUOp,

    output [2:0]    ALUControl_o
);

always_comb begin
    case(ALUOp)
        2'b00: ALUControl_o = 3'b000;
        2'b01: ALUControl_o = 3'b001;
        2'b10: begin
            case(func3)
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

endmodule
