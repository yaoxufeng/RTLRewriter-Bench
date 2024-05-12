module add3 (input clk, in_a, in_b, in_c, output reg sum);
    reg reg_ab_sum, reg_c;
    always@(posedge clk)
        begin
                reg_ab_sum <= in_a + in_b;
                reg_c <= in_c;
                sum <= reg_ab_sum + reg_c;
        end
endmodule