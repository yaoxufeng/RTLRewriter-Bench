module example(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [9:0] sum  // Output to accommodate possible overflow
);

    // Directly calculate the sum of all four inputs
    wire [9:0] total_sum;

    // Calculate sum of a, b, c, and d
    assign total_sum = a + b + c + d;

    // Output the final sum, fitting within the maximum output size
    assign sum = total_sum;

endmodule
