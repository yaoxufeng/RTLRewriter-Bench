module MUX6to1 (
    input [5:0] in,        // 6-bit input for the multiplexer
    input [2:0] sel,       // 3-bit selection input
    output reg out         // Single-bit output
);

// Always block triggered by changes in 'in' or 'sel'
always @ (in or sel) begin
    case (sel)
        3'b000: out = in[0];  // If sel is 000, output is in[0]
        3'b001: out = in[1];  // If sel is 001, output is in[1]
        3'b010: out = in[2];  // If sel is 010, output is in[2]
        3'b011: out = in[3];  // If sel is 011, output is in[3]
        3'b100: out = in[4];  // If sel is 100, output is in[4]
        default: out = in[5]; // For any other value of sel, output is in[5]
    endcase
end

endmodule