//Hardware Utilization: This approach results in higher hardware usage since separate circuits are used for addition and subtraction. It is less area and power-efficient but can be justified in scenarios where isolation between operations is required, or when the highest possible performance for each operation is necessary.
//Performance: Each operation may be optimized independently for speed, which could potentially lead to faster operation times compared to a shared resource approach, particularly in high-frequency or high-performance environments.

module non_shared_adder(
    input [7:0] a,        // 8-bit input operand A
    input [7:0] b,        // 8-bit input operand B
    input mode,           // Operation mode: 0 for addition, 1 for subtraction
    output [7:0] result   // 9-bit result to accommodate potential carry or borrow
);

// Instantiate separate adder and subtractor
wire [8:0] sum;
wire [8:0] difference;

// Addition module
adder add_module(
    .a(a),
    .b(b),
    .sum(sum)
);

// Subtraction module
subtractor subtract_module(
    .a(a),
    .b(b),
    .difference(difference)
);

// Mode selection logic
assign result = mode ? difference : sum;

endmodule

// Module for addition
module adder(
    input [7:0] a,
    input [7:0] b,
    output [7:0] sum
);
    assign sum = a + b;
endmodule

// Module for subtraction
module subtractor(
    input [7:0] a,
    input [7:0] b,
    output [7:0] difference
);
    assign difference = a - b;
endmodule




