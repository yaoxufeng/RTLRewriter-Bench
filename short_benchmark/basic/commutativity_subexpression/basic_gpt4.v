module example(
    input [31:0] A, B, C, D, E, F, G, H,
    output [31:0] result1, result2, result3, result4, result5, result6
);

// Common subexpressions
wire [31:0] AB = A + B;
wire [31:0] CD = C * D;
wire [31:0] EF = E - F;
wire [31:0] DC = D * C;  // Since CD and DC are equivalent, only one needs to be calculated.

assign result1 = AB + CD;
assign result2 = CD + EF;
assign result3 = AB + G + H;
assign result4 = (CD + E) * AB;
assign result5 = DC + B - (F + AB);
assign result6 = (AB + C) * EF;

endmodule
