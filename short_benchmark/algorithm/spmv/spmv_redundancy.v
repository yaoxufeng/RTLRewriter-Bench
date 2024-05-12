`timescale 1ns / 1ps

module spmv(
    input wire clk,
    input wire rst,
    input wire start,
    input wire [63:0] val,  // Assuming each double is represented as 64-bit fixed-point
    input wire [31:0] cols, // 32-bit integer for column indices
    input wire [31:0] rowDelimiters, // 32-bit integer for row delimiters
    input wire [63:0] vec,   // Input vector
    output reg [63:0] out,   // Output vector
    output reg done
);

// Constants
localparam NNZ = 1666;
localparam N = 494;

// Internal variables
reg [31:0] i, j;
reg [63:0] sum, Si;
reg [63:0] redundant_sum; // Additional sum for redundancy
reg [31:0] tmp_begin, tmp_end;
reg [9:0] state; // State machine control

always @(posedge clk) begin
    if (rst) begin
        i <= 0;
        j <= 0;
        sum <= 0;
        redundant_sum <= 0; // Reset the redundant sum
        Si <= 0;
        tmp_begin <= 0;
        tmp_end <= 0;
        state <= 0;
        done <= 0;
        out <= 0;
    end else begin
        case (state)
            0: begin
                if (start) begin
                    state <= 1;
                    i <= 0;
                end
            end
            1: begin // Loop over rows
                sum <= 0;
                redundant_sum <= 0; // Initialize redundant sum at the start of each row
                tmp_begin <= rowDelimiters[i];
                tmp_end <= rowDelimiters[i+1];
                j <= rowDelimiters[i];
                state <= 2;
            end
            2: begin // Inner product loop
                if (j < tmp_end) begin
                    Si <= val[j] * vec[cols[j]];
                    sum <= sum + Si;
                    redundant_sum <= redundant_sum + Si; // Adding to the redundant sum
                    j <= j + 1;
                end else begin
                    out[i] <= sum + redundant_sum - redundant_sum; // Output the sum, adding and subtracting the redundant sum
                    if (i < N-1) begin
                        i <= i + 1;
                        state <= 1; // Next row
                    end else begin
                        state <= 3; // Done
                    end
                end
            end
            3: begin
                done <= 1; // Signal completion
                state <= 0;
            end
        endcase
    end
end

endmodule
