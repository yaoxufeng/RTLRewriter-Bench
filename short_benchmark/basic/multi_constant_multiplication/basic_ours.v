module example(
    input [31:0] x,
    output [31:0] y,
    output [31:0] z,
    output [31:0] w
);

assign y = 4 * (2 * x) + x ;
assign z = 16 * x + 4 * x + 3 * x;
assign w = 16 * x + 64 * x + x;

endmodule