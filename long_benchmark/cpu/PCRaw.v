// Redundant Registers: Three registers (PC_1, PC_2, PC_3) are used to hold the program counter values. These are updated identically based on the input PC_i unless a hold or reset is applied.
// Majority Voting: The vote_PC wire computes the majority value among the three redundant registers. This ensures that the output PC_o reflects the correct state even if one of the registers is corrupted. The majority logic used here simply checks pairwise equality and selects the common value; if all three are different due to multiple faults (a rare scenario), it defaults to PC_3.
// Separate Logic for Output Update: A separate always block for updating the PC_o register based on the result of the majority vote ensures that changes due to the clock or reset are handled cleanly.
`timescale 1ns / 1ps

module PC_raw (
    input wire clk,
    input wire reset,
    input wire [31:0] PC_i,
    input wire PC_Hold,
    output reg [31:0] PC_o
);

    // Redundant program counters
    reg [31:0] PC_1, PC_2, PC_3;

    // Initial block for setting initial values
    initial begin
        PC_1 <= 32'h00400000;
        PC_2 <= 32'h00400000;
        PC_3 <= 32'h00400000;
    end

    // Triple redundant always blocks
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC_1 <= 32'h00400000;
            PC_2 <= 32'h00400000;
            PC_3 <= 32'h00400000;
        end else if (!PC_Hold) begin
            PC_1 <= PC_i;
            PC_2 <= PC_i;
            PC_3 <= PC_i;
        end
    end

    // Majority voting mechanism to resolve outputs
    wire [31:0] vote_PC;
    assign vote_PC = (PC_1 == PC_2) ? PC_1 :
                     (PC_2 == PC_3) ? PC_2 : PC_3;

    // Update output register in a separate always block
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC_o <= 32'h00400000;
        end else begin
            PC_o <= vote_PC;
        end
    end

endmodule