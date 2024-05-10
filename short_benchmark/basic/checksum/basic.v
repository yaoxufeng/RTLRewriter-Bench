module example(
    input [15:0] in0, in1, in2, in3,
    output reg [17:0] sum
);
    always @* begin
        sum = in0 + in1 + in2 + in3;
    end
endmodule