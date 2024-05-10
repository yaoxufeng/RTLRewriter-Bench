`timescale 1ns / 1ps

module stencil3d(
    input wire clk,           // clock signal
    input wire rst,           // reset signal
    input wire [31:0] C0,     // coefficient C[0]
    input wire [31:0] C1,     // coefficient C[1]
    input wire [1023:0] orig, // original input array, one-dimensional equivalent of orig[SIZE]
    output reg [1023:0] sol   // solution output array, one-dimensional equivalent of sol[SIZE]
);

// Constants
localparam HEIGHT_SIZE = 32;
localparam COL_SIZE = 32;
localparam ROW_SIZE = 16;
localparam SIZE = ROW_SIZE * COL_SIZE * HEIGHT_SIZE;

// Intermediate values
integer i, j, k;
reg [31:0] sum0;
reg [31:0] sum1_1, sum1_2, sum1_3, sum1;
reg [31:0] mul0;
reg [31:0] mul1;

// Flatten multidimensional index calculation
function integer INDX;
    input integer _row_size;
    input integer _col_size;
    input integer _i;
    input integer _j;
    input integer _k;
    begin
        INDX = _i + _row_size * (_j + _col_size * _k);
    end
endfunction

// Initialize results on reset or boundaries handling
always @(posedge clk or posedge rst) begin
    if (rst) begin
        for (i = 0; i < SIZE; i = i + 1) begin
            sol[i] <= 0;
        end
    end else begin
        // Boundary handling
        // Core stencil computation
        for (i = 1; i < HEIGHT_SIZE - 1; i = i + 1) begin
            for (j = 1; j < COL_SIZE - 1; j = j + 1) begin
                for (k = 1; k < ROW_SIZE - 1; k = k + 1) begin
                    sum0 = orig[INDX(ROW_SIZE, COL_SIZE, k, j, i)];
                    sum1_1 = orig[INDX(ROW_SIZE, COL_SIZE, k, j, i + 1)] +
                             orig[INDX(ROW_SIZE, COL_SIZE, k, j, i - 1)] +
                             orig[INDX(ROW_SIZE, COL_SIZE, k, j + 1, i)];
                    sum1_2 = orig[INDX(ROW_SIZE, COL_SIZE, k, j - 1, i)] +
                             orig[INDX(ROW_SIZE, COL_SIZE, k + 1, j, i)];
                    sum1_3 = orig[INDX(ROW_SIZE, COL_SIZE, k - 1, j, i)];
                    sum1 = sum1_1 + sum1_2 + sum1_3;
                    mul0 = sum0 * C0;
                    mul1 = sum1 * C1;
                    sol[INDX(ROW_SIZE, COL_SIZE, k, j, i)] <= mul0 + mul1;
                end
            }
        end
    end
end

endmodule