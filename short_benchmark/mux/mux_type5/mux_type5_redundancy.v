module mux_tree(
    input wire s1,
    input wire s2,
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output wire y
);
    wire x0, x1, x2;
    mux2to1 mux0 (.in0(c), .in1(d), .sel(s2), .out(x2));
    mux2to1 mux1 (.in0(a), .in1(b), .sel(s1), .out(x0));
    mux2to1 mux2 (.in0(a), .in1(b), .sel(x2), .out(x1));
    mux2to1 mux3 (.in0(x0), .in1(x1), .sel(s2), .out(y));
endmodule

// 2-to-1 Multiplexer Module
module mux2to1(
    input wire in0,
    input wire in1,
    input wire sel,
    output reg out
);
    always @(*) begin
        out = sel ? in1 : in0; // Use ternary operator for clarity
    end
endmodule