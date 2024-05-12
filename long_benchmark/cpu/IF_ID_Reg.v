`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tsinghua University
// Engineer: Timothy-LiuXuefeng
// 
// Create Date: 2021/07/08 22:16:27
// Design Name: PipelineCPU
// Module Name: IF_ID_Reg
// Project Name: PipelineCPU
// Target Devices: xc7a35tcpg236-1
// Tool Versions: Vivado 2017.3
// Description: IF/ID Register
// 
// Dependencies: None
// 
// Revision: None
// Revision 0.01 - File Created
// Additional Comments: None
// 
//////////////////////////////////////////////////////////////////////////////////


module IF_ID_Reg
(
    input wire clk,
    input wire reset,
    input wire flush,
    input wire hold,
    input wire [31:0] ReadInst,
    input wire [31:0] IF_PC_Plus_4,
    output reg [5:0] OpCode,
    output reg [4:0] rs,
    output reg [4:0] rt,
    output reg [4:0] rd,
    output reg [4:0] Shamt,
    output reg [5:0] Funct,
    output reg [31:0] PC_Plus_4
);

initial begin
    OpCode <= 0;
    rs <= 0;
    rt <= 0;
    rd <= 0;
    Shamt <= 0;
    Funct <= 0;
    PC_Plus_4 <= 0;
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        OpCode <= 0;
        rs <= 0;
        rt <= 0;
        rd <= 0;
        Shamt <= 0;
        Funct <= 0;
        PC_Plus_4 <= 0;
    end
    else if (flush) begin
        if (!hold) begin
            OpCode <= 0;
            rs <= 0;
            rt <= 0;
            rd <= 0;
            Shamt <= 0;
            Funct <= 0;
            PC_Plus_4 <= 0;
        end
    end
    else begin
        if (!hold) begin
            OpCode <= ReadInst[31:26];
            rs <= ReadInst[25:21];
            rt <= ReadInst[20:16];
            rd <= ReadInst[15:11];
            Shamt <= ReadInst[10:6];
            Funct <= ReadInst[5:0];
            PC_Plus_4 <= IF_PC_Plus_4;
        end
    end
end

endmodule
