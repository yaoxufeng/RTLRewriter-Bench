`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tsinghua University
// Engineer: Timothy-LiuXuefeng
// 
// Create Date: 2021/07/13 14:16:11
// Design Name: PipelineCPU
// Module Name: DataHazard
// Project Name: PipelineCPU
// Target Devices: xc7a35tcpg236-1
// Tool Versions: Vivado 2017.3
// Description: Data hazard unit
// 
// Dependencies: None
// 
// Revision: None
// Revision 0.01 - File Created
// Additional Comments: None
// 
//////////////////////////////////////////////////////////////////////////////////


module DataHazard
(
    input wire ID_EX_RegWrite,
    input wire [4:0] ID_EX_WriteAddr,
    input wire EX_MEM_RegWrite,
    input wire [4:0] EX_MEM_WriteAddr,
    input wire [4:0] rs,
    input wire [4:0] rt,
    input wire ID_EX_MemRead,

    output wire [1:0] ForwardA,     // 00: no hazard, 01: 1-step, 10: 2_step
    output wire [1:0] ForwardB,
    output wire LW_Stall
);

assign ForwardA =
                (ID_EX_RegWrite && ID_EX_WriteAddr != 0 && ID_EX_WriteAddr == rs) ? 2'b01 :
                (EX_MEM_RegWrite && EX_MEM_WriteAddr != 0 && EX_MEM_WriteAddr == rs) ? 2'b10 :
                2'b00;

assign ForwardB =
                (ID_EX_RegWrite && ID_EX_WriteAddr != 0 && ID_EX_WriteAddr == rt) ? 2'b01 :
                (EX_MEM_RegWrite && EX_MEM_WriteAddr != 0 && EX_MEM_WriteAddr == rt) ? 2'b10 :
                2'b00;

assign LW_Stall =
                ID_EX_MemRead && (ID_EX_WriteAddr != 0) && (ID_EX_WriteAddr == rs || ID_EX_WriteAddr == rt);

endmodule
