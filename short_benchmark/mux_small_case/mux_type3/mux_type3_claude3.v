module mux_tree(
    input wire sel,
    input wire a,
    output wire y
);
    assign y = sel ? 1 : a;
endmodule