module add3 (
    input clk,
    input in_a, in_b, in_c, in_d, in_e, in_f, in_g, in_h, in_i,
    output reg [3:0] sum
);
    reg [3:0] sum_reg;

    always @(posedge clk) begin
        sum_reg <= in_a + in_b + in_c + in_d + in_e + in_f + in_g + in_h + in_i;
    end

    always @(posedge clk) begin
        sum <= sum_reg;
    end
endmodule