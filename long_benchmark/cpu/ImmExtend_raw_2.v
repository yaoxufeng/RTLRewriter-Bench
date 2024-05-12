//Additional Control Signals: Two additional control signals signed_op_not_lui_op and zero_op_not_lui_op have been introduced. These signals are derived from the original control signals SignedOp and LuiOp using continuous assignments.
//Redundant Control Logic: The always block now uses three nested if statements to determine the value of out_ext. The first if statement checks for the LuiOp condition, as in the original implementation. However, the next two if statements introduce redundant control logic by checking for signed_op_not_lui_op and zero_op_not_lui_op, respectively. These conditions are essentially the same as SignedOp and ~SignedOp, but with the additional check for ~LuiOp, which is redundant since the LuiOp case has already been handled.
//Redundant Default Case: The always block includes a default case that assigns a constant value (32'h0) to out_ext. This case is redundant since the control signals LuiOp, SignedOp, and their complements (~LuiOp, ~SignedOp) should cover all possible cases.

module ImmExtend_raw_2(
    input wire [15:0] in,
    input wire LuiOp,
    input wire SignedOp,
    output wire [31:0] out_ext
);

wire signed_op_not_lui_op;
wire zero_op_not_lui_op;
assign signed_op_not_lui_op = SignedOp & ~LuiOp;
assign zero_op_not_lui_op = ~SignedOp & ~LuiOp;
reg [31:0] internal_out_ext;

always @(*) begin
    if (LuiOp) begin
        internal_out_ext = {in, 16'h0};
    end else if (signed_op_not_lui_op) begin
        internal_out_ext = {{16{in[15]}}, in};
    end else if (zero_op_not_lui_op) begin
        internal_out_ext = {16'h0, in};
    end else begin
        internal_out_ext = 32'h0; // Redundant case
    end
end

assign out_ext = internal_out_ext;
endmodule