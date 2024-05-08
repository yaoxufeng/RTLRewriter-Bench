module optimizedExample(
    input [2:0] a,
    input b,
    input [1:0] c,
    input e,                 // Assuming 'e' is an additional input
    output reg y,
    output reg d             // Assuming 'd' as an output for the new condition
);

// Compute common sub-expressions once
wire common_ac;
assign common_ac = (a == 3'd2) && (c == 2'd0);

// Process block using common sub-expression
always @(*) begin
    if (common_ac && b == 1'b1) begin
        y = 1'b1;
    end else begin
        y = 1'b0;
    end
end

always @(*) begin
    if (common_ac && b == 1'b0) begin
        y = 1'b1;
    end else begin
        y = 1'b0;
    end
end

// Additional condition involving 'e'
always @(*) begin
    if (common_ac && e == 1'b1) begin
        d = 1'b1;
    end else begin
        d = 1'b0;
    end
end

endmodule