module example_raw
#(  parameter       BW = 8)
(
    input [BW-1:0] a,
    input [BW-1:0] b,
    input [BW-1:0] c,
    output [BW-1:0] s1,
    output [BW-1:0] s2,
    output [BW-1:0] s3
);
    assign s1 = a + b + 15;
    assign s2 = a * b;
    assign s3 = a - b + 6;
endmodule