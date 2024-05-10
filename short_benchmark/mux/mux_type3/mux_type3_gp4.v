module mux_tree(
    input wire sel,
    input wire a,
    output wire y
);
    // Directly implement the multiplexer logic using a conditional operator
    assign y = sel ? 1'b1 : a;
endmodule