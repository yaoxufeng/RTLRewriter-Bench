module mux_tree(
    input wire sel,
    input wire a,
    input wire b,
    input wire c,
    output wire y
);
    wire x0, x1;
    mux2to1 mux0 (.in0(a), .in1(b), .sel(sel), .out(x0));
    simple_cal cal0(.in(x0), .out(x1));
    mux2to1 mux1 (.in0(x1), .in1(c), .sel(sel), .out(y));
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

// simple calculation
module simple_cal(
    input wire in,
    output reg out
);
    always @(*) begin
          out = in << 2 + 1;
    end
endmodule

