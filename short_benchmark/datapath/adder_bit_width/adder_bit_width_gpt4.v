module example(
    input [7:0] a,    // 8-bit input
    input [7:0] b,    // 8-bit input
    output [8:0] sum  // 9-bit output for sum
);

    // Direct computation of sum from inputs without using an unnecessary large register
    always @* begin
        sum = a + b;  // Direct assignment to sum
    end

endmodule
