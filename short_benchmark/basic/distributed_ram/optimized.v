module memory_distributedram #(
    parameter DATA_WIDTH = 18, // Data width
    parameter ADDR_WIDTH = 10 // Address width for 1024 storage elements
)(
    input wire clk,
    input wire [ADDR_WIDTH-1:0] addr,
    input wire [DATA_WIDTH-1:0] din,
    input wire we, // Write enable
    output wire [DATA_WIDTH-1:0] dout
);

// Distributed RAM implementation using LUTs
reg [DATA_WIDTH-1:0] ram_distributed[2**ADDR_WIDTH-1:0];
reg [DATA_WIDTH-1:0] dout_reg;

always @(posedge clk) begin
    if (we) begin
        ram_distributed[addr] <= din; // Write data
    end
    dout_reg <= ram_distributed[addr]; // Read data
end

assign dout = dout_reg;

endmodule