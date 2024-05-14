module memory_compression_opt
#(  parameter       BW = 16,
    parameter       COMPRESS_BW = 8,
    parameter       MW = 16)
(
    input clk,
    input rst,
    input [15:0] write_data,
    input write_en,
    input [3:0] write_address,
    output reg [15:0] read_data,
    input read_en,
    input [3:0] read_address
);

// Example storage for compressed data
reg [COMPRESS_BW-1:0] compressed_memory[MW-1:0];
wire [COMPRESS_BW-1:0] compressed_data;
wire [BW-1:0] decompressed_data;
integer i;

// Placeholder compression function (abstract logic)
assign compressed_data = write_data[BW-1:COMPRESS_BW];  // Example: simplistic 'compression'
assign decompressed_data ={compressed_memory[read_address], 8'b00000000};
// Write logic
always @(posedge clk) begin
    if (rst) begin
        // Initialize memory to 0 on reset
        for (i = 0; i < MW; i = i + 1)
            compressed_memory[i] <= 0;
    end else if (write_en) begin
        // Write compressed data to memory
        compressed_memory[write_address] <= compressed_data;
    end
end

// Read logic
always @(posedge clk) begin
    if (read_en) begin
        // Read and decompress data from memory
        read_data <= decompressed_data;
    end
end
endmodule
