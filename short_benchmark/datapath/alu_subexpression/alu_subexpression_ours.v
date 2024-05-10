module example(
    input [7:0] input_a,    // 8-bit input operand A
    input [7:0] input_b,    // 8-bit input operand B
    input [3:0] opcode,     // Operation code
    output reg [7:0] result,  // Result of the ALU operation
    output zero_flag        // Flag indicating result is zero
);

// Define opcode constants for clarity
localparam ADD  = 3'b000;
localparam SUB  = 3'b001;
localparam AND  = 3'b010;
localparam OR   = 3'b011;
localparam XOR  = 3'b100;
localparam NOT  = 3'b101;
localparam BCD_CORRECTION = 3'b110;

reg [7:0] add_result; // Temporary storage for addition result

always @(*) begin
    // Perform the addition operation once and use it for both ADD and BCD_CORRECTION cases
    add_result = input_a + input_b;

    case (opcode)
        ADD:  // Use pre-computed addition result
            result = add_result;
        SUB:  // Perform subtraction
            result = input_a - input_b;
        AND:  // Perform bitwise AND
            result = input_a & input_b;
        OR:   // Perform bitwise OR
            result = input_a | input_b;
        XOR:  // Perform bitwise XOR
            result = input_a ^ input_b;
        NOT:  // Perform bitwise NOT only on input A
            result = ~input_a;
        BCD_CORRECTION:  // Use pre-computed addition result and apply BCD correction if needed
            if (add_result > 9)
                result = add_result + 6;
            else
                result = add_result;
        default: result = 8'b0;  // Default result is zero
    endcase
end

// Set the zero flag if the result is zero
assign zero_flag = (result == 0);

endmodule
