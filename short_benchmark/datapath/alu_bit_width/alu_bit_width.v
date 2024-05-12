//Resource Waste: Using a 32-bit data path for operations that involve 8-bit operands leads to a significant waste of hardware resources, including more extensive logic gates and potentially slower operations due to the increased data path size.
//Power Inefficiency: Larger registers and wider data paths can lead to higher power consumption due to increased switching activity and greater capacitance.
//Reduced Performance: Propagation delays may increase because the signal must travel through more extensive logic networks.

module alu_raw(
    input [7:0] op_a,       // 8-bit input operand A
    input [7:0] op_b,       // 8-bit input operand B
    input [2:0] alu_op,     // ALU operation select
    output reg [7:0] result // Excessively wide 32-bit output
);

// Extend inputs to 32-bit
wire [31:0] extended_a = {24'b0, op_a};
wire [31:0] extended_b = {24'b0, op_b};
reg [31:0] result_internal;

// ALU Operations
localparam ADD = 3'b000;
localparam SUB = 3'b001;
localparam AND = 3'b010;
localparam OR  = 3'b011;
localparam XOR = 3'b100;
localparam NOT = 3'b101;

always @(*) begin
    case (alu_op)
        ADD: result_internal = extended_a + extended_b;   // Addition
        SUB: result_internal = extended_a - extended_b;   // Subtraction
        AND: result_internal = extended_a & extended_b;   // Bitwise AND
        OR:  result_internal = extended_a | extended_b;   // Bitwise OR
        XOR: result_internal = extended_a ^ extended_b;   // Bitwise XOR
        NOT: result_internal = ~extended_a;               // Bitwise NOT (only A is used)
        default: result_internal = 32'b0;                 // Default case
    endcase
    result = result_internal[7:0];
end
endmodule