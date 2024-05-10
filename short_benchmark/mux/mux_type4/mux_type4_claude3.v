module mux_tree(
    input wire sel,
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output wire y
);
    // Simplified multiplexer logic using conditional operator
    assign y = sel ? (d ? b : a) : (c ? b : a);
endmodule