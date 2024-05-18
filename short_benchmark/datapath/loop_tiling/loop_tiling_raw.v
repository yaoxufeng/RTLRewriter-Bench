module example_raw
#(parameter    W = 16)
(
    input [W-1:0] x,
    input [W*W-1:0] A,
    output reg [W-1:0] y
);
    integer i, j;
    always @ (x) begin
        for(i = 0; i < W; i++) begin
             for(j = 0; j < W; j++) begin
                 y[i] = A[i*W+j] * x[i];
             end
        end
    end
endmodule