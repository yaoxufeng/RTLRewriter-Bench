module example_raw
#(  parameter    W = 8,
    parameter    H = 8)
(
    input [W*H-1:0] a,
    output reg [W*H-1:0] s
);

integer i, j;
always @ (a) begin
    for (i = 0; i < W; i = i + 1) begin
        for (j = 0; j < H; j = j + 1) begin
             s[i*H+j] = a[i*H+j];
         end
    end

    for (i = 0; i < W; i = i + 1) begin
             s[i*H+i] = 0;
    end
end
endmodule