// This implementation is less efficient than the original implementation for the following reasons:
// Procedural Logic: Instead of using a continuous assignment statement, this implementation uses a procedural block (always block) to determine the value of out_ext. While this approach works functionally, it requires more hardware resources (registers, multiplexers, etc.) to implement the logic, leading to increased area and power consumption.
// Sensitivity List: The always block is sensitive to all input signals (in, LuiOp, and SignedOp), even though the output out_ext does not depend on all of them simultaneously. This unnecessary sensitivity can lead to unnecessary evaluations and switching activity, potentially impacting power consumption and timing.
// Output Register: The output out_ext is declared as a register, which is unnecessary since the extended value does not need to be stored across clock cycles. This can lead to additional hardware resources and potential timing issues.
// Conditional Statements: The use of nested if-else statements can lead to longer combinational logic paths, potentially impacting timing and area.

module ImmExtend_raw_1(
    input wire [15:0] in,
    input wire LuiOp,
    input wire SignedOp,
    output wire [31:0] out_ext
);

reg [63:0] internal_out_ext;

always @(*) begin
    if (LuiOp) begin
        internal_out_ext = {in, 48'h0};
    end
    else if (SignedOp) begin
        internal_out_ext = {{48{in[15]}}, in};
    end
    else begin
        internal_out_ext = {48'h0, in};
    end
end

assign out_ext = internal_out_ext[31:0];
endmodule