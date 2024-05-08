module mux_tree(
    input wire sel,
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output wire y
);
    // Use assign statements to directly implement the multiplexer functionality
    wire x0 = c ? b : a;  // Replacing mux0
    wire x1 = d ? b : a;  // Replacing mux1
    assign y = sel ? x1 : x0;  // Replacing mux2 with direct assignment
endmodule