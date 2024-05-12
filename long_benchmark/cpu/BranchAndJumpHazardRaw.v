// Redundant Signal Generation: Each flush condition is calculated three times independently. This redundancy ensures that even if one of the signal paths experiences a fault, the other paths can still correctly represent the intended logic.
// Majority Voting: The final signals IF_ID_Flush and ID_EX_Flush are determined by a majority vote among the three redundant signals. The majority voting logic ((A & B) | (B & C) | (A & C)) ensures that the output reflects the most common value among the three inputs, providing fault tolerance.

`timescale 1ns / 1ps

module BranchAndJumpHazard_raw
(
    input wire Jump,
    input wire no_branch,
    output wire IF_ID_Flush,
    output wire ID_EX_Flush
);

// Redundant signals for TMR
wire IF_ID_Flush_1, IF_ID_Flush_2, IF_ID_Flush_3;
wire ID_EX_Flush_1, ID_EX_Flush_2, ID_EX_Flush_3;

// Generating redundant signals
assign IF_ID_Flush_1 = Jump || !no_branch;
assign IF_ID_Flush_2 = Jump || !no_branch;
assign IF_ID_Flush_3 = Jump || !no_branch;

assign ID_EX_Flush_1 = !no_branch;
assign ID_EX_Flush_2 = !no_branch;
assign ID_EX_Flush_3 = !no_branch;

// Majority voting mechanism
wire IF_ID_Flush, ID_EX_Flush;

assign IF_ID_Flush = (IF_ID_Flush_1 & IF_ID_Flush_2) | (IF_ID_Flush_2 & IF_ID_Flush_3) | (IF_ID_Flush_1 & IF_ID_Flush_3);
assign ID_EX_Flush = (ID_EX_Flush_1 & ID_EX_Flush_2) | (ID_EX_Flush_2 & ID_EX_Flush_3) | (ID_EX_Flush_1 & ID_EX_Flush_3);
endmodule
