module example(
    input [7:0] input_a,    // 8-bit input operand A
    input [7:0] input_b,    // 8-bit input operand B
    input [7:0] input_c,    // 8-bit input operand C
    input [7:0] input_d,    // 8-bit input operand D
    input [2:0] opcode,     // 3-bit Operation code due to 8 operations
    input sel,
    output reg [7:0] result,  // Result of the ALU operation
    output zero_flag        // Flag indicating result is zero
);

// Define opcode constants for clarity
localparam ADD = 3'b000;
localparam ADDReverse = 3'b111;
localparam SUB = 3'b001;
localparam AND = 3'b010;
localparam OR = 3'b011;
localparam XOR = 3'b100;
localparam NOT = 3'b101;
localparam SEL_SUM = 3'b110;

always @(*) begin
    case (opcode)
        ADD, ADDReverse:
            result = input_a + input_b + input_c + input_d; // Uniform calculation
        SUB:
            result = input_a - input_b;
        AND:
            result = input_a & input_b;
        OR:
            result = input_a | input_b;
        XOR:
            result = input_a ^ input_b;
        NOT:
            result = ~input_a;
        SEL_SUM:
            result = sel ? (input_a + input_c) : (input_b + input_d);
        default:
            result = 8'b0;  // Default result is zero
    endcase
end

// Set the zero flag if the result is zero
assign zero_flag = (result == 0);

endmodule