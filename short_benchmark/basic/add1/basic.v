module example(
    input wire s,
    input wire [31:0] A, B, C, D,
    output reg [32:0] Z
);

always @(s, A, B, C, D) begin
    if (s)
        Z <= A + B;
    else
        Z <= C + D;
end

endmodule