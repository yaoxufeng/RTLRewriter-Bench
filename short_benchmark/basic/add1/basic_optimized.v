module example(
    input wire s,
    input wire [31:0] A, B, C, D,
    output reg [32:0] Z
);

reg [31:0] Z1, Z2;  // Intermediate values

always @(s, A, B, C, D) begin
    if (s) begin
        Z1 <= A;
        Z2 <= B;
    end else begin
        Z1 <= C;
        Z2 <= D;
    end
end

always @(Z1, Z2) begin
    Z <= Z1 + Z2;
end

endmodule