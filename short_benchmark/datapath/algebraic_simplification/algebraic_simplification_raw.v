module example_raw
#(  parameter    BW = 8)
(
    input [BW-1:0] a,
    input [BW-1:0] b,
    output [BW-1:0] s1,
    output [BW-1:0] s2
);
    wire [BW-1:0] t1, t2;
    assign s1 = a + b;
    assign t1 = s1 + 0;
    assign t2 = s1 * 1;
    assign s2 = t1 + t2;
endmodule