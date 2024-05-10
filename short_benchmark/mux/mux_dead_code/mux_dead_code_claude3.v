module example(
    input x,
    input sel,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] result
);

// Instantiate ALU module
wire [7:0] alu_result;

alu alu_module(
    .a(a),
    .b(b),
    .sel(sel),
    .alu_result(alu_result)
);

always @(*) begin
    if (x) begin
        result = alu_result;
    end else begin
        result = a | b;
    end
end

endmodule

// Optimized ALU module
module alu(
    input [7:0] a,
    input [7:0] b,
    input sel,
    output reg [7:0] alu_result
);

always @(*) begin
    case (sel)
        1'b0: alu_result = a & b;
        1'b1: alu_result = a + b - b;
        default: alu_result = 8'b0;
    endcase
end

endmodule