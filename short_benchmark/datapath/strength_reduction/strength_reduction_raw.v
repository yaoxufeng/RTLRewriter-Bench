module example_raw
#(  parameter       BW = 8)
(
    input [BW-1:0] a,
    input [BW-1:0] b,
    input [BW-1:0] c,
    output reg [BW-1:0] s1,
    output reg [BW-1:0] s2,
    output reg [BW-1:0] s3
);

always @ (a or b or c) begin
    s1 = a * 4;
    s2 = b * 5;
    s3 = c * 9;
end
endmodule