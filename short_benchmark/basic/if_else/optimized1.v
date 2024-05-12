module MUX6to1 (
    input [5:0] in,    // 6-bit input for the multiplexer
    input [2:0] sel,   // 3-bit selection input
    output reg out     // Single-bit output
);

always @ (in or sel) begin
    out = (sel == 3'b000) ? in[0] :
          (sel == 3'b001) ? in[1] :
          (sel == 3'b010) ? in[2] :
          (sel == 3'b011) ? in[3] :
          (sel == 3'b100) ? in[4] : in[5];
end

endmodule
