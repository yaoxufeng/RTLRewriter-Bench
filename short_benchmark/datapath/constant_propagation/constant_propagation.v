module example
#(  parameter       BW = 64)
(
    input c,
    output z
);
    assign z = c * 67;
endmodule