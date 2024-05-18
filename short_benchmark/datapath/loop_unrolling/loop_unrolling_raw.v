module example_raw
#(parameter    W = 256)
(
    input [W-1:0] a,
    output reg [W-1:0] s
);
    integer i;
    always @ (a) begin
        i = 0;
        for(i = 0; i < W; i++) begin
             s[i] = a[i];
        end
    end
endmodule