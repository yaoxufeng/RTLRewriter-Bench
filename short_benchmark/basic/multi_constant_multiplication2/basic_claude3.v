module example(
    input [31:0] x,
    output [31:0] y,
    output [31:0] z,
    output [31:0] w
);

assign y = {x[28:0], 3'b000} + x;
assign z = {x[26:0], 5'b00000} + x;
assign w = {x[25:0], 6'b000000} - x;

endmodule