module add3 (input clk, in_a, in_b, in_c, output reg sum);
    reg reg_a, reg_b, reg_c;
    always@(posedge clk)
        begin
                reg_a <= in_a;
                reg_b <= in_b;
                reg_c <= in_c;
                sum <= reg_a + reg_b + reg_c;
        end
endmodule