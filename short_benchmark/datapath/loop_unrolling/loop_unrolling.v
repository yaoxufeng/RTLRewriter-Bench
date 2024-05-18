module example_raw
#(parameter    W = 256)
(
    input [W-1:0] a,
    output reg [W-1:0] s
);
    integer i;
    always @ (a) begin
        i = 0;
        for(i = 0; i < W; i = i + 8) begin
             s[i] = a[i];
             s[i+1] = a[i+1];
             s[i+2] = a[i+2];
             s[i+3] = a[i+3];
             s[i+4] = a[i+4];
             s[i+5] = a[i+5];
             s[i+6] = a[i+6];
             s[i+7] = a[i+7];
        end
    end
endmodule