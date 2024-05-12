module logic_reduce (
    input wire clk,
    input wire non_critical,
    input wire critical,
    input wire additional_condition1, // New input signal for complex condition
    input wire additional_condition2, // Another new input signal for complex condition
    input wire in1,
    input wire in2,
    output reg out1
);

// Intermediate storage for the more complex critical path condition
wire complex_critical_condition;

// Define complex critical path logic
assign complex_critical_condition = critical & additional_condition1 & additional_condition2;

reg out_temp;

// Combinational logic to determine 'out_temp' based on 'non_critical'
always @* begin
    if (non_critical) begin
        out_temp = in1;
    end else begin
        out_temp = in2;
    end
end

// Sequential logic to update 'out1' based on the complex 'critical' condition
always @(posedge clk) begin
    if (complex_critical_condition) begin
        out1 <= out_temp; // Use the intermediate value if the complex condition is met
    end else begin
        out1 <= in2; // Default to 'in2' otherwise
    end
end

endmodule