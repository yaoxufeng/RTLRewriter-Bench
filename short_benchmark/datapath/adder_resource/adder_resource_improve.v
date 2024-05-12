//Simplicity and Efficiency: This design is simple yet efficient for systems where basic arithmetic operations are required without the need for dedicated hardware for each type of operation.
//Extendibility: The concept can be extended to include more operations (like bitwise operations) by further manipulating the operands based on additional modes.
//Area and Power: By reusing the same hardware for multiple operations, the design saves area and power, which is crucial in resource-constrained environments.

module shared_adder(
    input [7:0] a,
    input [7:0] b,
    input mode,
    output [7:0] result  // 9-bit result to accommodate potential carry or borrow
);

// Use a 2's complement method for subtraction
// Negate B if mode is 1 (subtraction), otherwise pass B unchanged
wire [7:0] b_modified = mode ? ~b + 1'b1 : b;

// Add A to the modified B
assign result = a + b_modified;

endmodule