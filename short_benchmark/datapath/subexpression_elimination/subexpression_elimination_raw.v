module example_raw
#(  parameter       BW = 8)
(
    input [BW-1:0] a,
    input [BW-1:0] b,
    input [BW-1:0] c,
    input [BW-1:0] d,
    output [BW-1:0] s1,
    output [BW-1:0] s2,
    output [BW-1:0] s3,
    output [BW-1:0] s4,
    output [BW-1:0] s5,
    output [BW-1:0] s6
);

    assign s1 = a + b;
    assign s2 = a * b;
    assign s3 = a % b +d;
    assign s4 = c + d + b * a;
    assign s5 = a - b;
    assign s6 = (b + 1) * a + d + c -b;
endmodule
