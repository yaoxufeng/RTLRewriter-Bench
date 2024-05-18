module example_raw
#(parameter    W = 16)
(
    input [W-1:0] x,
    output reg [W-1:0] y,
    output reg [W-1:0] z
);
    integer i;
    always @ (x) begin
        for(i = 0; i < W; i++) begin
             y[i] = x[i];
        end

        for(i = 0; i < W; i++) begin
             z[i] = x[i];
        end
    end
endmodule
