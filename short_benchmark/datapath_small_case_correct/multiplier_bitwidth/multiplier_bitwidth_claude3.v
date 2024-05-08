module efficient_multiplier(
    input [7:0] multiplicandA,  // 8-bit multiplicand
    input [7:0] multiplierB,    // 8-bit multiplier
    input [7:0] multiplicandC,  // 8-bit multiplicand
    input [7:0] multiplierD,    // 8-bit multiplier
    input sel,
    output reg [15:0] product   // 16-bit product output
);

// Internal variables with appropriate bit widths
reg [7:0] internal_multiplicand;
reg [7:0] internal_multiplier;

always @(*) begin
    if (sel) begin
        internal_multiplicand = multiplicandA;
        internal_multiplier = multiplierB;
    end else begin
        internal_multiplicand = multiplicandC;
        internal_multiplier = multiplierD;
    end

    // Perform multiplication using appropriate bit widths
    product = internal_multiplicand * internal_multiplier;
end

endmodule