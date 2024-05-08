module example(
    input [31:0] x,
    output [31:0] y,
    output [31:0] z,
    output [31:0] w
);

// Optimized multiplication using shifts and additions
assign y = (x << 3) + x; // y = 9*x, as 9 = 8+1
assign z = (x << 4) + (x << 2) + (x << 1) + x; // z = 23*x, as 23 = 16+4+2+1
assign w = (x << 6) + (x << 4) + x; // w = 81*x, as 81 = 64+16+1

endmodule
