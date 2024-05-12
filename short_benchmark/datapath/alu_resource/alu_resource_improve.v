// Scenarios include simple embedded systems, microcontroller units
// Benefits
// Resource Efficiency: Uses only one ALU for multiple operations, saving silicon area and power.
// Simplicity: Reduces the complexity of the hardware design by minimizing the number of distinct functional units.
// Considerations
// Performance: Time-multiplexing hardware resources can lead to increased latency in operation execution since operations are performed sequentially rather than in parallel.
// Control Complexity: Additional logic is required to manage the time-sharing of the ALU, including the control path for switching operations and possibly the need for holding registers to store intermediate data.

module TimeMultiplexedALU(
    input [1:0] op_code,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] result
);

// Perform ALU operations based on op_code
always @(*) begin
    case (op_code)
        2'b00: result <= a + b;    // Addition
        2'b01: result <= a - b;    // Subtraction
        2'b10: result <= a & b;    // Bitwise AND
        2'b11: result <= a | b;    // Bitwise OR
        default: result <= result; // Hold the previous result if op_code is out of range
    endcase
end
endmodule
