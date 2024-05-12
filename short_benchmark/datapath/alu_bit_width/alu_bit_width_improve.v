//Bit Width of result:
//The result is declared as a 16-bit register, which is the maximum necessary width to handle the largest possible outcome (from addition or subtraction). This is more appropriate than the original 32-bit width, reducing the logic required and potentially speeding up computation.
//Bit Width Matching Operations:
//Each operation within the ALU uses only the bit widths required for 8-bit operands. This minimizes the unnecessary use of larger data paths and simplifies the logic design.
//Efficient Resource Usage:
//By optimizing the bit widths, the design becomes more resource-efficient, which is crucial for FPGA or ASIC implementations where resource constraints are often stringent.
//Power and Performance:
//Smaller bit widths reduce the capacitance in the data paths, which can lower power consumption. Additionally, shorter data paths can potentially reduce the propagation delay, improving the ALU's operational speed.

module alu_opt(
    input [7:0] op_a,       // 8-bit input operand A
    input [7:0] op_b,       // 8-bit input operand B
    input [2:0] alu_op,     // ALU operation select
    output reg [7:0] result // Correctly sized output for maximum possible result
);

// ALU Operations defined using local parameters for clarity
localparam ADD = 3'b000;
localparam SUB = 3'b001;
localparam AND = 3'b010;
localparam OR  = 3'b011;
localparam XOR = 3'b100;
localparam NOT = 3'b101;

always @(*) begin
    case (alu_op)
        ADD: result = op_a + op_b;             // Addition, maximum 9 bits needed, still fits in 16 bits
        SUB: result = op_a - op_b;             // Subtraction, maximum 9 bits (including sign bit)
        AND: result = op_a & op_b;             // Bitwise AND, maximum 8 bits needed
        OR:  result = op_a | op_b;             // Bitwise OR, maximum 8 bits needed
        XOR: result = op_a ^ op_b;             // Bitwise XOR, maximum 8 bits needed
        NOT: result = ~op_a;                   // Bitwise NOT, only op_a is used, 8 bits
        default: result = 8'b0;               // Default case, zero padded
    endcase
end
endmodule
