// Implementing an adder with subexpression sharing in Verilog can be an excellent exercise to demonstrate how to minimize redundant computations and optimize hardware resources effectively. By identifying and reusing common subexpressions, the design can be made more efficient.

module example(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [9:0] sum  // Output width increased to handle potential overflow
);

    // Intermediate sums - shared subexpressions
    wire [8:0] sum_ab;
    wire [8:0] sum_cd;

    // Calculate partial sums
    assign sum_ab = a + b;  // First pair
    assign sum_cd = c + d;  // Second pair

    // Calculate final sum using shared subexpressions
    assign sum = sum_ab + sum_cd;

endmodule