module example(
    input x,
    input sel,
    input [7:0] a,        // 8-bit input operand A
    input [7:0] b,        // 8-bit input operand B
    output reg [7:0] result  // Output result
);

// Simplified combinational logic
always @(*) begin
    if (x) begin
        // And bitwise directly in the module
        result = a & b;
    end else begin
        // Or bitwise directly in the module
        result = a | b;
    end
end

endmodule
