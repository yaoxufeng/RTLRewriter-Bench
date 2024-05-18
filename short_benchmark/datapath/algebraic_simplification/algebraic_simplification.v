module example_raw
#(  parameter    BW = 8)
(
    input [BW-1:0] a,
    input [BW-1:0] b,
    output [BW-1:0] s1,
    output [BW-1:0] s2
);
    assign s1 = a + b ;
    assign s2 = s1 * 2;
endmodule