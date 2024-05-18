module example_raw
#(  parameter       BW = 8)
(
    input [BW-1:0] a,
    input [BW-1:0] b,
    input [BW-1:0] c,
    input [BW-1:0] d,
    output [BW-1:0] s1
);
    assign s2 = a * b;
    assign s3 = a % b +d;
    assign s4 = c + d + b * a;
    assign s5 = a - b;
    assign s6 = (b + 1) * a + d + c -b;
    assign s1 = a + 23;
endmodule