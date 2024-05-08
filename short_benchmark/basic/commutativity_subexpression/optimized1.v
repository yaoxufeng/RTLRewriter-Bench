module arithmetic_operations_optimized(
    input [31:0] A, B, C, D, E, F, G, H,
    output [31:0] result1, result2, result3
);

wire [31:0] sum_AB, mx_CD;

assign sum_AB = A + B ;
assign mx_CD = C * D;

assign result1 = sum_AB + mx_CD;
assign result2 = mx_CD + (E - F);
assign result3 = (sum_AB + G) + H;

endmodule