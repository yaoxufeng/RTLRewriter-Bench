module example(
    input [15:0] in0, in1, in2, in3,
    output reg [17:0] sum
);
    reg [16:0] sum1, sum2;
    always @* begin
        sum1 = in0 + in1;
        sum2 = in2 + in3;
        sum = sum1 + sum2;
    end
endmodule