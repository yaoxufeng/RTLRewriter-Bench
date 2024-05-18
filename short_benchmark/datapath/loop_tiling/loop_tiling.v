module example_raw
#(parameter    W = 16)
(
    input [W-1:0] x,
    input [W*W-1:0] A,
    output reg [W-1:0] y
);
    integer i, j, ii, jj;
    parameter B = 4;
    always @ (x) begin
        for(ii = 0; ii < W; ii = ii + B) begin
            for(jj = 0; jj < W; jj = jj + B) begin
                for(i = ii; i < ii + B; i++) begin
                    for(j = jj; j < jj + B; j++) begin
                        y[i] = A[i*W+j] * x[i];
                    end
                end
            end
        end
    end
endmodule