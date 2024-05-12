module gemm #(
    parameter DATA_WIDTH = 16,
    parameter ADDR_WIDTH = 16,
    parameter MATRIX_SIZE = 32
)(
    input clk,
    input reset,
    input start,
    output reg done,
    input [DATA_WIDTH-1:0] m1,
    input [DATA_WIDTH-1:0] m2,
    output reg [DATA_WIDTH-1:0] prod
);

    integer i, j, k;
    reg [DATA_WIDTH-1:0] sum;
    wire [DATA_WIDTH-1:0] mult;
    reg [ADDR_WIDTH-1:0] i_col, k_col;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            done <= 0;
        end else if (start) begin
            done <= 0;
            for (i = 0; i < MATRIX_SIZE; i = i + 1) begin
                for (j = 0; j < MATRIX_SIZE; j = j + 1) begin
                    sum = 0;
                    i_col = i * MATRIX_SIZE;
                    for (k = 0; k < MATRIX_SIZE; k = k + 1) begin
                        k_col = k * MATRIX_SIZE;
                        mult = m1[i_col + k] * m2[k_col + j]; // Note: Multiplication needs custom implementation
                        sum = sum + mult;
                    end
                    prod[i_col + j] = sum;
                end
            end
            done <= 1;
        end
    end

    // Placeholder for multiplication; in actual implementation, would need a specific module
    // to handle fixed or floating-point multiplication.
    assign mult = m1[i_col + k] * m2[k_col + j]; // WARNING: Simplified, may not synthesize as-is for floating-point

endmodule