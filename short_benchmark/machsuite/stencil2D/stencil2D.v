module stencil (
    input clk,
    input rst,
    input [1023:0] orig,
    input [1023:0] filter,
    output reg [1023:0] sol
);
    parameter col_size = 64;
    parameter row_size = 128;
    parameter f_size = 9;

    integer r, c, k1, k2;
    reg [31:0] temp;
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
                for (c = 0; c < col_size - 2; c = c + 1) begin
                    temp = 0;
                    for (k1 = 0; k1 < 3; k1 = k1 + 1) begin
                        for (k2 = 0; k2 < 3; k2 = k2 + 1) begin
                            mul_reg = filter[k1 * 3 + k2] * orig[(r + k1) * col_size + (c + k2)];
                            temp = temp + mul_reg;
                        end
                    end
                    sol[r * col_size + c] <= temp;
                end
            end
        end
    end

endmodule