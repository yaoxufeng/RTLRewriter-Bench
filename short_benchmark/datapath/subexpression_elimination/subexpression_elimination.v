module example
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
    assign s3 = a % b + d;
    assign s4 = c + d + s2;
    assign s5 = a - b;
    assign s6 = s4 + s5;
endmodule
