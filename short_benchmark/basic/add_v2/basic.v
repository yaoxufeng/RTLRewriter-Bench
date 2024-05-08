module example(
    input [2:0] a,          // 3-bit input a
    input b,                // 1-bit input b
    input [1:0] c,          // 2-bit input c
    output reg y           // 1-bit output y
);

// Process block A1
always @(*) begin : A1
    if (a == 3'd2 && b == 1'b1 && c == 2'd0) begin
        // Placeholder functionality for true condition
        y = 1'b1;
    end else begin
        // Placeholder functionality for false condition
        y = 1'b0;
    end
end

// Process block A2
always @(*) begin : A2
    if (a == 3'd2 && b == 1'b0 && c == 2'd0) begin
        // Another placeholder functionality for true condition
        y = 1'b1;
    end else begin
        // Another placeholder functionality for false condition
        y = 1'b0;
    end
end

endmodule