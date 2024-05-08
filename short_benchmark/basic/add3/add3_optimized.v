module example (input clk, in_a, in_b, in_c, in_d, in_e, in_f, in_g, in_h, in_i, output reg sum);
    reg reg_ab_sum, reg_c;
    always@(posedge clk)
        begin
                reg_abc_sum <= in_a + in_b + in_c;
                reg_def_sum <= in_d + in_e + in_f;
                reg_ghi_sum <= in_g + in_h + in_i;
                sum <= reg_abc_sum + reg_def_sum + reg_ghi_sum;
        end
endmodule