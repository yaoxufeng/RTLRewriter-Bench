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
    assign s1 = a + b + 3 * 5;
    assign s2 = a * b - 0 * c;
    assign s3 = a - b + 1 * 2 + 4;
endmodule