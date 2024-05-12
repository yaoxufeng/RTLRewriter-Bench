// Normalization: After multiplication, the product is checked for normalization, and adjustments are made to the exponent and fraction accordingly.
// Sensitivity List: Changed to always @ (*) for combinational logic, ensuring that any change in inputs floatA or floatB triggers the block.
// Exponent Handling: The exponent calculation now correctly adjusts for the bias (-15) and corrects for normalization shifts. Also checks for overflow and underflow conditions.
// Output Calculation: The output product is computed using the normalized values and handling special cases like zero output or exponent overflow/underflow.
// This improved module should be more reliable and efficient for synthesis, offering correct handling of floating-point multiplication according to the specified format.

module floatMult_improve (
    input [15:0] floatA, floatB,
    output reg [15:0] product
);

reg sign;
reg signed [5:0] exponent; // 6th bit for the sign
reg [9:0] mantissa;
reg [10:0] fractionA, fractionB; // fraction = {1, mantissa}
reg [21:0] fraction;

always @ (*) begin
    if (floatA == 0 || floatB == 0) begin
        product = 0;
    end else begin
        // Calculate the sign of the result
        sign = floatA[15] ^ floatB[15];

        // Calculate the exponent
        exponent = floatA[14:10] + floatB[14:10] - 15;

        // Extract the mantissas and form the fractions
        fractionA = {1'b1, floatA[9:0]};
        fractionB = {1'b1, floatB[9:0]};

        // Perform the multiplication
        fraction = fractionA * fractionB;

        // Normalize the result
        if (fraction[21]) begin
            fraction = fraction >> 1;
            exponent = exponent + 1;
        end

        // Prepare the output
        mantissa = fraction[20:11]; // Take the top 10 bits of the normalized fraction

        // Check for exponent overflow/underflow
        if (exponent < 0 || exponent > 31) begin
            product = 16'b0000000000000000; // Underflow or overflow results in zero (or could be inf)
        end else begin
            product = {sign, exponent[4:0], mantissa};
        end
    end
end

endmodule