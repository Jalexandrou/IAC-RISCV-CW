module DataMem #(
    parameter   ADDRESS_WIDTH = 32,
                DATA_WIDTH = 32,
                BYTE_WIDTH = 8,
                SET_WIDTH = 8,  // Cache has max of 256 bytes, 64 words, so needs 8 bit Set value
                CACHE_WIDTH = DATA_WIDTH + (ADDRESS_WIDTH - SET_WIDTH - 2) + 1  // Data + Tag + V
)(
    input  logic                         clk,
    input  logic                         we,
    input  logic                         ByteOp,
    input  logic [ADDRESS_WIDTH-1:0]     Address,
    input  logic [DATA_WIDTH-1:0]        WriteData,
    output logic [DATA_WIDTH-1:0]        ReadData
);

    logic [BYTE_WIDTH-1:0] ram_array [32'h0001FFFF:32'h00000000];
    logic [CACHE_WIDTH-1:0] cache_array [2**SET_WIDTH-1:0]; // Cache Array with 64 Sets

    initial begin
        $readmemh("gaussian.mem", ram_array, 32'h10000);
    end;

    always_ff @(posedge clk) begin
        if (we && !ByteOp) begin                 
            ram_array[{Address[31:2], 2'b0}]   <= WriteData[31:24];     // Big Endian Byte Addressing
            ram_array[{Address[31:2], 2'b0}+1] <= WriteData[23:16];
            ram_array[{Address[31:2], 2'b0}+2] <= WriteData[15:8];
            ram_array[{Address[31:2], 2'b0}+3] <= WriteData[7:0];

            cache_array[Address[10:2]] <= WriteData;    // Update Cache to avoid Cache Coherency problem
        end
        else if (we && ByteOp) begin
            ram_array[Address] <= WriteData[7:0];

            cache_array[Address[10:2]] <= WriteData;   // Update Cache to avoid Cache Coherency problem
        end
    end

    always_comb begin
        if (ByteOp) begin
            if((cache_array[44:32] == Address [31:10]) && cache_array[45] == 1) begin   // Check cache first
                ReadData = cache_array[Address[10:2]];
            end
            else begin
                ReadData = ram_array[Address];
                
                cache_array[Address[10:2]] <= ram_array[Address]; // Put Accessed Data into Cache, Temporal Locality
 
            end
        end
        else begin
            if((cache_array[44:32] == Address [31:10]) && cache_array[45] == 1) begin   // Check cache first
                ReadData = cache_array[Address[10:2]];
            end
            else begin
                ReadData = {ram_array[{Address[31:2], 2'b0}], 
                        ram_array[{Address[31:2], 2'b0}+1], 
                        ram_array[{Address[31:2], 2'b0}+2], 
                        ram_array[{Address[31:2], 2'b0}+3]};
                
                cache_array[Address[10:2]] <= ram_array[Address]; // Put Accessed Data into Cache, Temporal Locality
      
            end
        end
    end

endmodule

