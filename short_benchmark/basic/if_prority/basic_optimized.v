module example(input [7:0] binValue, output reg [7:0] asciiValue);

always @(binValue) begin
  case (binValue)
    1: asciiValue = "A";
    2: asciiValue = "B";
    3: asciiValue = "C";
    4: asciiValue = "D";
    default: asciiValue = "E";
  endcase
end
endmodule