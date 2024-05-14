module multiplexer_flattened(
    input wire [3:0] D,     // Input data lines
    input wire [1:0] sel,   // Select lines
    output wire out         // Output line
);
    // Logic for a 4-to-1 multiplexer
    assign out = (sel == 2'b00) ? D[0] :
                 (sel == 2'b01) ? D[1] :
                 (sel == 2'b10) ? D[2] :
                                  D[3] ;
endmodule
