module shared_memory_opt (
    input clk,
    input rst,
    // Port A
    input [3:0] address_a,
    input [7:0] data_in_a,
    input write_en_a,
    input read_en_a,
    output reg [7:0] data_out_a,
    // Port B
    input [3:0] address_b,
    input [7:0] data_in_b,
    input write_en_b,
    input read_en_b,
    output reg [7:0] data_out_b
);

// Memory declaration
reg [7:0] mem [0:15]; // 16 bytes of memory
integer i;

// Memory access logic
always @(posedge clk) begin
    if (rst) begin
        // Reset memory content
        for (i = 0; i < 16; i = i + 1) begin
            mem[i] <= 0;
        end
    end
    else begin
        // Handle Port A
        if (write_en_a) begin
            mem[address_a] <= data_in_a; // Write operation
        end
        if (read_en_a) begin
            data_out_a <= mem[address_a]; // Read operation
        end

        // Handle Port B
        if (write_en_b) begin
            mem[address_b] <= data_in_b; // Write operation
        end
        if (read_en_b) begin
            data_out_b <= mem[address_b]; // Read operation
        end
    end
end
endmodule