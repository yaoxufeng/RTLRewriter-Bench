module example(
    input [31:0] x,
    output [31:0] y,
    output [31:0] z,
    output [31:0] w
);

// Multiplication by 13 using shifts and additions
assign y = (x << 3) + (x << 2) + x;

// Multiplication by 25 using shifts and additions
assign z = (x << 4) + (x << 3) + x;

// Multiplication by 63 using shifts and additions
assign w = (x << 5) + (x << 4) + (x << 3) + (x << 2) + (x << 1) + x;

endmodule