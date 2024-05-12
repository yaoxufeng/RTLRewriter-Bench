`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tsinghua University
// Engineer: Timothy-LiuXuefeng
// 
// Create Date: 2021/07/08 21:32:55
// Design Name: PipelineCPU
// Module Name: MEM_WB_Reg
// Project Name: PipelineCPU
// Target Devices: xc7a35tcpg236-1
// Tool Versions: Vivado 2017.3
// Description: MEM/WB Register
// 
// Dependencies: None
// 
// Revision: None
// Revision 0.01 - File Created
// Additional Comments: None
// 
//////////////////////////////////////////////////////////////////////////////////


module MEM_WB_Reg
(
    input wire clk,
    input wire reset,

    input wire MEM_RegWr,
    input wire [1:0] MEM_MemtoReg,
    input wire [4:0] MEM_WriteAddr,
    input wire [31:0] MEM_ReadData,
    input wire [31:0] MEM_ALU_result,
    input wire [31:0] MEM_PC_next
);

reg RegWr;
reg [1:0] MemtoReg;
reg [4:0] WriteAddr;
reg [31:0] ReadData;
reg [31:0] ALU_result;
reg [31:0] PC_next;

initial begin
    RegWr       <= 0;
    MemtoReg    <= 0;
    WriteAddr   <= 0;
    ReadData    <= 0;
    ALU_result  <= 0;
    PC_next     <= 0;
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        RegWr       <= 0;
        MemtoReg    <= 0;
        WriteAddr   <= 0;
        ReadData    <= 0;
        ALU_result  <= 0;
        PC_next     <= 0;
    end
    else begin
        RegWr           <= MEM_RegWr;
        MemtoReg        <= MEM_MemtoReg;
        WriteAddr       <= MEM_WriteAddr;
        ReadData        <= MEM_ReadData;
        ALU_result      <= MEM_ALU_result;
        PC_next         <= MEM_PC_next;
    end
end

endmodule
