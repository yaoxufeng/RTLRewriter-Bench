module memory_blockram #(
    parameter DATA_WIDTH = 18, // Data width
    parameter ADDR_WIDTH = 10 // Address width for 1024 storage elements
)(
    input wire clk,
    input wire [ADDR_WIDTH-1:0] addr,
    input wire [DATA_WIDTH-1:0] din,
    input wire we, // Write enable
    output reg [DATA_WIDTH-1:0] dout
);

// Block RAM declaration
reg [DATA_WIDTH-1:0] ram_block[2**ADDR_WIDTH-1:0];

always @(posedge clk) begin
    if (we) begin
        ram_block[addr] <= din; // Write data
    end
    dout <= ram_block[addr]; // Read data
end

endmodule