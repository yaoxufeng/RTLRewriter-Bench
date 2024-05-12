`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tsinghua University
// Engineer: Timothy-LiuXuefeng
// 
// Create Date: 2021/07/16 03:11:29
// Design Name: PipelineCPU
// Module Name: BranchAndJumpHazard
// Project Name: PipelineCPU
// Target Devices: xc7a35tcpg236-1
// Tool Versions: Vivado 2017.3
// Description: Branch hazard Unit.
// 
// Dependencies: None
// 
// Revision: None
// Revision 0.01 - File Created
// Additional Comments: None
// 
//////////////////////////////////////////////////////////////////////////////////

module BranchAndJumpHazard
(
    input wire Jump,
    input wire no_branch,
    output wire IF_ID_Flush,
    output wire ID_EX_Flush
);

assign IF_ID_Flush = Jump || !no_branch;
assign ID_EX_Flush = !no_branch;

endmodule
