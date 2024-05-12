// Scenarios include high-performance applications where the goal is to maximize throughput and minimize latency.
// Benefits
// High Throughput: Operations are carried out in parallel, which significantly increases throughput.
// Reduced Latency: Each operation completes in a minimal number of clock cycles without waiting for other operations to release shared resources.
// Simplified Timing Analysis: Without resource contention, timing analysis and meeting timing constraints become more straightforward.
// Considerations
// Increased Resource Usage: Each operation requires its resources, leading to higher consumption of logic blocks, wiring, and power.
// Costlier Hardware: More extensive silicon area might lead to higher costs in production.
// Scalability Issues: Scaling such designs by adding more operations might quickly escalate resource demands and complexity.

module DedicatedResources(
    input wire [1:0] op_code,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] result
);

wire [7:0] sum_result;
wire [7:0] diff_result;
wire [7:0] and_result;
wire [7:0] or_result;

always @(*) begin
    sum_result = a + b;  // Perform addition
    diff_result = a - b;  // Perform subtraction
    and_result = a & b;  // Perform subtraction
    or_result = a | b;  // Perform subtraction
    case (op_code)
        2'b00: result <= sum_result;    // Addition
        2'b01: result <= diff_result;    // Subtraction
        2'b10: result <= and_result;    // Bitwise AND
        2'b11: result <= or_result;    // Bitwise OR
        default: result <= result; // Hold the previous result if op_code is out of range
    endcase

end
endmodule