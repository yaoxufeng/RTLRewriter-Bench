module mux_tree(
    input wire s1,
    input wire s2,
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output wire y
);

    // Direct implementation of the multiplexer logic in the output
    // Using ternary operators to simplify the MUX logic
    assign y = s2 ? (s1 ? b : a) : (s2 ? d : c);

endmodule

// Since we have simplified the main module, we don't need the mux2to1 module
// here anymore. However, if needed elsewhere, it can be retained as:
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