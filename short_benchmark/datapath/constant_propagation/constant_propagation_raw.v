module example_raw
#(  parameter       BW = 64)
(
    input  c,
    output z
);
    assign a = 2;
    assign b = (a * 32) + 3;
    assign z = c * b;
endmodule