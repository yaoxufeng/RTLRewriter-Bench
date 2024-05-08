module example_optimized(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [9:0] sum  // Output to accommodate possible overflow
);

    // Optimized addition using intermediate results
    wire [8:0] sum_ab;    // Sum of a and b
    wire [8:0] sum_cd;    // Sum of c and d
    wire [9:0] sum_abcd;  // Final sum of (a+b) and (c+d)

    // Calculate sum of a and b
    assign sum_ab = a + b;

    // Calculate sum of c and d
    assign sum_cd = c + d;

    // Calculate final sum of (a+b) and (c+d)
    assign sum_abcd = sum_ab + sum_cd;

    // Output the final sum
    assign sum = sum_abcd;

endmodule