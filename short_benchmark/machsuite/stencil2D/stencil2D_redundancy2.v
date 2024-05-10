module stencil (
    input clk,
    input rst,
    input [511:0] orig,
    input [511:0] filter,
    output reg [511:0] sol
);
    parameter col_size = 64;
    parameter row_size = 128;
    parameter f_size = 9;

    integer r, c, k1, k2;
    reg [31:0] temp;
    reg [31:0] sum_pipe[2:0];  // Pipelining intermediate sums
    wire [31:0] mul;
    reg [31:0] mul_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (r = 0; r < row_size; r = r + 1) begin
                for (c = 0; c < col_size; c = c + 1) begin
                    sol[r * col_size + c] <= 0;
                end
            end
        end else begin
            for (r = 0; r < row_size - 2; r = r + 1) begin
                sum_pipe[0] <= 0; // initialize pipeline
                sum_pipe[1] <= 0;
                for (c = 0; c < col_size - 2; c = c + 1) begin
                    temp = sum_pipe[0]; // start with last completed partial sum
                    for (k1 = 0; k1 < 3; k1 = k1 + 1) begin
                        for (k2 = 0; k2 < 3; k2 = k2 + 1) begin
                            mul_reg = filter[k1 * 3 + k2] * orig[(r + k1) * col_size + (c + k2)];
                            sum_pipe[k1] = sum_pipe[k1] + mul_reg; // accumulating in pipeline stages
                        end
                    end
                    sum_pipe[0] = sum_pipe[1] + temp;
                    sum_pipe[1] = sum_pipe[2];
                    sol[r * col_size + c] <= sum_pipe[0]; // output from first pipeline stage
                end
            end
        end
    end

endmodule