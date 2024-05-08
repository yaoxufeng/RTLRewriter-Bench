module example(
    input [31:0] x,
    output [31:0] y,
    output [31:0] z,
    output [31:0] w
);

assign y = 4 * x + 9 * x;

assign z = 16 * x + 9 * x;

assign w = 8 * (9 * x) - 9 * x;

endmodule