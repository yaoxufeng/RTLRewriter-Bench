module communtativity_subexpression(
    input [31:0] A, B, C, D, E, F, G, H,
    output [31:0] result1, result2, result3, result4, result5, result6
);

    wire [31:0] sum_AB, mx_CD, sub_EF;

    assign sum_AB = A + B ;
    assign mx_CD = C * D;
    assign sub_EF = E - F ;

    assign result1 = sum_AB + mx_CD;
    assign result2 = mx_CD + sub_EF;
    assign result3 = (sum_AB + G) + H;
    assign result4 = (mx_CD + E) * sum_AB;
    assign result5 = (mx_CD + B) - (F + sum_AB);
    assign result6 = (sum_AB + C) * sub_EF;

endmodule