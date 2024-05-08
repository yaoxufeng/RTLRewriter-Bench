module example (
    input clk,
    input in_a, in_b, in_c, in_d, in_e, in_f, in_g, in_h, in_i,
    output reg sum
);
    // Intermediate sums to reduce depth of addition
    wire sum_ab, sum_cd, sum_ef, sum_gh;

    // Parallel addition pairs
    assign sum_ab = in_a + in_b;
    assign sum_cd = in_c + in_d;
    assign sum_ef = in_e + in_f;
    assign sum_gh = in_g + in_h;

    // Use registers to store intermediate sums if necessary
    reg [3:0] reg_sum_ab, reg_sum_cd, reg_sum_ef, reg_sum_gh, reg_in_i;

    always @(posedge clk) begin
        // Register the intermediate sums and the last input
        reg_sum_ab <= sum_ab;
        reg_sum_cd <= sum_cd;
        reg_sum_ef <= sum_ef;
        reg_sum_gh <= sum_gh;
        reg_in_i <= in_i;

        // Final addition in a sequential block to ensure timing
        sum <= reg_sum_ab + reg_sum_cd + reg_sum_ef + reg_sum_gh + reg_in_i;
    end
endmodule
