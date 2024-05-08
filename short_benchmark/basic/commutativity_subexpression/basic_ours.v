module example(
    input [31:0] A, B, C, D, E, F, G, H,
    output [31:0] result1, result2, result3, result4, result5, result6
);

// Precompute reused expressions
wire [31:0] sum_AB = A + B;
wire [31:0] prod_CD = C * D;
wire [31:0] diff_EF = E - F;
wire [31:0] sum_ABG = sum_AB + G;

// Redefine outputs using precomputed values
assign result1 = sum_AB + prod_CD;
assign result2 = prod_CD + diff_EF;
assign result3 = sum_ABG + H;
assign result4 = (prod_CD + E) * sum_AB;
assign result5 = (prod_CD + B) - (F + sum_AB);
assign result6 = (sum_AB + C) * diff_EF;

endmodule
