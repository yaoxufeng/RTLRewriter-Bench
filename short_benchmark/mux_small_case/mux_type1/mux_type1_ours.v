module mux_tree(
    input wire sel,
    input wire a,
    input wire b,
    input wire c,
    output wire y
);
    wire x0;
    reg x1;
    mux2to1 mux0 (.in0(a), .in1(b), .sel(sel), .out(x0));

    // Combine simple_cal directly here to avoid extra module
    always @(*) begin
        x1 = (x0 << 2) + 1;
    end

    mux2to1 mux1 (.in0(x1), .in1(c), .sel(sel), .out(y));
endmodule

// 2-to-1 Multiplexer Module (unchanged)
module mux2to1(
    input wire in0,
    input wire in1,
    input wire sel,
    output reg out
);
    always @(*) begin
        out = sel ? in1 : in0;
    end
endmodule