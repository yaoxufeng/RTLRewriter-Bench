module example(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [9:0] sum  // Output to accommodate possible overflow
);

    // Optimized intermediate shared expressions
    wire [8:0] sum_ab;    // Sum of a and b, 9 bits to accommodate overflow
    wire [9:0] sum_abc;   // Sum of a+b and c, 9 bits + 1 bit for overflow

    // Calculate sum of a and b
    assign sum_ab = a + b;

    // Calculate sum of a+b and c
    assign sum_abc = sum_ab + c;

    // Calculate final sum of a+b+c and d, output directly
    assign sum = sum_abc + d;

endmodule
