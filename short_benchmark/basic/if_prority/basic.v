module example(input [7:0] binValue, output reg [7:0] asciiValue);

always @(binValue) begin
  if (binValue == 1)
    asciiValue = "A";
  else if (binValue == 2)
    asciiValue = "B";
  else if (binValue == 3)
    asciiValue = "C";
  else if (binValue == 4)
    asciiValue = "D";
  else
    asciiValue = "E";
end
endmodule
···