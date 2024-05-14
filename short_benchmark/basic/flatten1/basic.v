module multiplexer_structured(
    input wire [3:0] D,     // Input data lines
    input wire [1:0] sel,   // Select lines
    output wire out        // Output line
);
    wire sel1_out, sel2_out;

    // Lower level multiplexers
    mux2x1 mux1 (.d0(D[0]), .d1(D[1]), .sel(sel[0]), .y(sel1_out));
    mux2x1 mux2 (.d0(D[2]), .d1(D[3]), .sel(sel[0]), .y(sel2_out));

    // Top level multiplexer
    mux2x1 mux3 (.d0(sel1_out), .d1(sel2_out), .sel(sel[1]), .y(out));

endmodule

// 2x1 Multiplexer Module
module mux2x1(
    input wire d0, d1,      // Data inputs
    input wire sel,         // Select line
    output wire y           // Output
);
    assign y = sel ? d1 : d0;
endmodule
