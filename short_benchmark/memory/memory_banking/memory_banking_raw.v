module memory_bank(
    input clk,
    input rst,

    // Interface for Bank 0
    input bank0_write_en,
    input [7:0] bank0_addr,
    input [7:0] bank0_data_in,
    output reg [7:0] bank0_data_out,

    // Interface for Bank 1
    input bank1_write_en,
    input [7:0] bank1_addr,
    input [7:0] bank1_data_in,
    output reg [7:0] bank1_data_out
);

    // Define memory banks
    //reg [7:0] mem_bank0[255:0];
    //reg [7:0] mem_bank1[255:0];
    reg [7:0] mem_bank[511:0];

    // Memory access for Bank
    always @(posedge clk) begin
        if (rst) begin
            bank0_data_out <= 0;
        end else if (bank0_write_en) begin
            mem_bank[bank0_addr] <= bank0_data_in;
        end else begin
            bank0_data_out <= mem_bank[bank0_addr];
        end
    end

    // Memory access for Bank 1
    always @(posedge clk) begin
        if (rst) begin
            bank1_data_out <= 0;
        end else if (bank1_write_en) begin
            mem_bank[{1, bank1_addr}] <= bank1_data_in;
        end else begin
            bank1_data_out <= mem_bank[{1, bank1_addr}];
        end
    end

endmodule