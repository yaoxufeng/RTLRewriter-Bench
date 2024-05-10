module optimized_multiplier(
    input [7:0] multiplicandA,  // 8-bit multiplicand
    input [7:0] multiplierB,    // 8-bit multiplier
    input [7:0] multiplicandC,  // 8-bit multiplicand
    input [7:0] multiplierD,    // 8-bit multiplier
    input sel,
    output reg [15:0] product      // Correctly sized 16-bit product output
);

reg [7:0] multiplicand1, multiplicand2;
always @(*) begin
    // Perform multiplication directly without unnecessary internal registers
    if (sel) begin
       multiplicand1 = multiplicandA;
       multiplicand2 = multiplierB;
    end else begin
       multiplicand1 = multiplicandC;
       multiplicand2 = multiplierD;
    end
    product = multiplicand1 * multiplicand2;
end
endmodule