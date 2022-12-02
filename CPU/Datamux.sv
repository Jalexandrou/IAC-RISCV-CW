module ALUmux #(
    parameter DATA_WIDTH = 32
)(
  input logic  [DATA_WIDTH-1:0] ALUOut,
  input logic  [DATA_WIDTH-1:0] readData,
  input logic                   Resultsrc,
  output logic [DATA_WIDTH-1:0] Result
);

assign Result = ResultSrc ? readData : ALUOut;

endmodule
