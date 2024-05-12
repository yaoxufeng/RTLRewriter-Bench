module logic_reduce (
    input wire clk,
    input wire non_critical,
    input wire critical,
    input wire additional_condition1,
    input wire additional_condition2,
    input wire in1,
    input wire in2,
    output reg out1
);

// Sequential logic to directly update 'out1' based on conditions
always @(posedge clk) begin
    if (critical & additional_condition1 & additional_condition2) begin
        // Determine 'out1' based on 'non_critical' when critical conditions are met
        if (non_critical) begin
            out1 <= in1;
        end else begin
            out1 <= in2;
        end
    end else begin
        out1 <= in2; // Default to 'in2' otherwise
    end
end

endmodule
