module example(
    input [7:0] a,  // 8-bit input
    input [7:0] b,  // 8-bit input
    output [8:0] sum  // Correctly sized 9-bit output
);

    // Directly assign the result of the addition to the output
    assign sum = a + b;  // Result will naturally fit in 9 bits, no need for an internal register

endmodule
