`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tsinghua University
// Engineer: Timothy-LiuXuefeng
// 
// Create Date: 2021/07/08 16:03:56
// Design Name: PipelineCPU
// Module Name: ImmExtend
// Project Name: PipelineCPU
// Target Devices: xc7a35tcpg236-1
// Tool Versions: Vivado 2017.3
// Description: Immediate number processor.
// 
// Dependencies: None
// 
// Revision: None
// Revision 0.01 - File Created
// Additional Comments: None
// 
//////////////////////////////////////////////////////////////////////////////////

module ImmExtend
(
    input wire [15:0] in,
    input wire LuiOp,
    input wire SignedOp,
    output wire [31:0] out_ext
);

assign out_ext = LuiOp ? {in, 16'h0} :
                SignedOp ? {{16{in[15]}}, in} :
                {16'h0, in};
endmodule
