module atax(
    input clk,
    input reset,
    input enable,
  	input [511:0] A, // Assuming 32-bit floating-point format
    input [63:0] x,
    output reg [63:0] y_out
);

parameter N = 64;
reg [31:0] buff_A[N-1:0][N-1:0];
reg [31:0] buff_x[N-1:0];
reg [31:0] buff_y_out[N-1:0];
reg [31:0] tmp1[N-1:0];
integer i, j;

always @(posedge clk) begin
    if (reset) begin
        for (i = 0; i < N; i++) begin
            buff_y_out[i] <= 0;
            tmp1[i] <= 0;
        end
    end
    else if (enable) begin
        // Load A and x
        for (i = 0; i < N; i++) begin
            buff_x[i] <= x[i];
            for (j = 0; j < N; j++) begin
                buff_A[i][j] <= A[i][j];
            end
        end

        // Compute tmp1 = A * x
        for (i = 0; i < N; i++) begin
            tmp1[i] <= 0; // Reset tmp1[i]
            for (j = 0; j < N; j++) begin
                tmp1[i] <= tmp1[i] + buff_A[i][j] * buff_x[j];
            end
        end

        // Compute y_out = A' * tmp1
        for (j = 0; j < N; j++) begin
            buff_y_out[j] <= 0; // Reset buff_y_out[j]
            for (i = 0; i < N; i++) begin
                buff_y_out[j] <= buff_y_out[j] + buff_A[i][j] * tmp1[i];
            end
        end

        // Update output
        for (i = 0; i < N; i++) begin
            y_out[i] <= buff_y_out[i];
        end
    end
end

endmodule
