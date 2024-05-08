module example(
    input [31:0] X, Y, Z, P, Q, R, S, T,
    output [31:0] output1, output2, output3, output4, output5, output6
);

// Optimized expressions using commutativity and associativity
assign output1 = X * Y + Z + P;         // Simplified grouping
assign output2 = (P + Z) * (Q - R);     // No change necessary
assign output3 = X + Y + S + T;         // Simplified grouping
assign output4 = (X * Y + Q) * (P + X); // No change necessary, but reordered for consistency
assign output5 = X * Y + P - R - P - X; // Simplified by directly calculating the final expression
assign output6 = (X + Y + P) * (Q - R); // No change necessary

endmodule