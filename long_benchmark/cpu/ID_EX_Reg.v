`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tsinghua University
// Engineer: Timothy-LiuXuefeng
// 
// Create Date: 2021/07/11 23:00:23
// Design Name: PipelineCPU
// Module Name: ID_EX_Reg
// Project Name: PipelineCPU
// Target Devices: xc7a35tcpg236-1
// Tool Versions: Vivado 2017.3
// Description: ID/EX Register
// 
// Dependencies: None
// 
// Revision: None
// Revision 0.01 - File Created
// Additional Comments: None
// 
//////////////////////////////////////////////////////////////////////////////////


module ID_EX_Reg
(
    input wire clk,
    input wire reset,
    input wire flush,

    input wire ID_RegWr,
    input wire ID_Branch,
    input wire ID_BranchClip,
    input wire ID_MemRead,
    input wire ID_MemWrite,
    input wire [1:0] ID_MemtoReg,
    input wire ID_ALUSrcA,
    input wire ID_ALUSrcB,
    input wire [3:0] ID_ALUOp,
    input wire [1:0] ID_RegDst,

    input wire [31:0] ID_ReadData1,
    input wire [31:0] ID_ReadData2,
    input wire [31:0] ID_imm_ext,

    input wire [31:0] ID_PC_Plus_4,
    input wire [4:0] ID_Shamt,
    input wire [4:0] ID_rt,
    input wire [4:0] ID_rd
);

reg RegWr;
reg Branch;
reg BranchClip;
reg MemRead;
reg MemWrite;
reg [1:0] MemtoReg;
reg ALUSrcA;
reg ALUSrcB;
reg [3:0] ALUOp;
reg [1:0] RegDst;

reg [31:0] ReadData1;
reg [31:0] ReadData2;
reg [31:0] imm_ext;

reg [31:0] PC_Plus_4;
reg [4:0] Shamt;
reg [4:0] rt;
reg [4:0] rd;

initial begin
    RegWr           <= 0;
    Branch          <= 0;
    BranchClip      <= 0;
    MemRead         <= 0;
    MemWrite        <= 0;
    MemtoReg        <= 0;
    ALUSrcA         <= 0;
    ALUSrcB         <= 0;
    ALUOp           <= 0;
    RegDst          <= 0;

    ReadData1       <= 0;
    ReadData2       <= 0;
    imm_ext         <= 0;

    PC_Plus_4       <= 0;
    Shamt           <= 0;
    rt              <= 0;
    rd              <= 0;
end

always @(posedge clk or posedge reset) begin
    if (reset ) begin
        RegWr           <= 0;
        Branch          <= 0;
        BranchClip      <= 0;
        MemRead         <= 0;
        MemWrite        <= 0;
        MemtoReg        <= 0;
        ALUSrcA         <= 0;
        ALUSrcB         <= 0;
        ALUOp           <= 0;
        RegDst          <= 0;
        
        ReadData1       <= 0;
        ReadData2       <= 0;
        imm_ext         <= 0;

        PC_Plus_4       <= 0;
        Shamt           <= 0;
        rt              <= 0;
        rd              <= 0;
    end
    else if (flush) begin
        RegWr           <= 0;
        Branch          <= 0;
        BranchClip      <= 0;
        MemRead         <= 0;
        MemWrite        <= 0;
        MemtoReg        <= 0;
        ALUSrcA         <= 0;
        ALUSrcB         <= 0;
        ALUOp           <= 0;
        RegDst          <= 0;
        
        ReadData1       <= 0;
        ReadData2       <= 0;
        imm_ext         <= 0;

        PC_Plus_4       <= 0;
        Shamt           <= 0;
        rt              <= 0;
        rd              <= 0;
    end
    else begin
        RegWr       <= ID_RegWr         ;
        Branch      <= ID_Branch        ;
        BranchClip  <= ID_BranchClip    ;
        MemRead     <= ID_MemRead       ;
        MemWrite    <= ID_MemWrite      ;
        MemtoReg    <= ID_MemtoReg      ;
        ALUSrcA     <= ID_ALUSrcA       ;
        ALUSrcB     <= ID_ALUSrcB       ;
        ALUOp       <= ID_ALUOp         ;
        RegDst      <= ID_RegDst        ;

        ReadData1   <= ID_ReadData1     ;
        ReadData2   <= ID_ReadData2     ;
        imm_ext     <= ID_imm_ext       ;

        PC_Plus_4   <= ID_PC_Plus_4     ;
        Shamt       <= ID_Shamt         ;
        rt          <= ID_rt            ;
        rd          <= ID_rd            ;
    end
end

endmodule
