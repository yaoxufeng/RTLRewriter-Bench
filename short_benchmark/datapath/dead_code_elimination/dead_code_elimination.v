module example_raw
#(  parameter       BW = 8)
(
    input [BW-1:0] a,
    input [BW-1:0] b,
    input [BW-1:0] c,
    input [BW-1:0] d,
    output [BW-1:0] s1
);
    assign s1 = a + 23;
endmodule