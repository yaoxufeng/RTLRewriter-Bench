module ImmExtend_raw (
    input wire [15:0] in,
    input wire LuiOp,
    input wire SignedOp,
    output wire [31:0] out_ext
);

wire [31:0] out_ext_1, out_ext_2;
assign out_ext_2 = SignedOp ? {{16{in[15]}}, in} : {16'h0, in};
assign out_ext_1 = LuiOp ? {in, 16'h0} : out_ext_2;
assign out_ext = out_ext_1;
endmodule