`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tsinghua University
// Engineer: Timothy-LiuXuefeng
// 
// Create Date: 2021/07/08 12:16:51
// Design Name: PipelineCPU
// Module Name: PipelineCPU
// Project Name: PipelineCPU
// Target Devices: xc7a35tcpg236-1
// Tool Versions: Vivado 2017.3
// Description: Top design module.
// 
// Dependencies: None
// 
// Revision: None
// Revision 0.01 - File Created
// Additional Comments: None
// 
//////////////////////////////////////////////////////////////////////////////////


module PipelineCPU
(
    input wire sysclk,
    input wire reset,
    output wire [7:0] leds,
    output wire [3:0] AN,
    output wire [7:0] BCD
);

wire clk;
assign clk = sysclk;

wire [31:0] PC_i;
wire [31:0] PC_o;
wire PC_Hold;
PC PC(clk, reset, PC_i, PC_Hold, PC_o);

wire [31:0] ReadInst;
InstMem InstMem(PC_o, ReadInst);

wire IF_ID_Flush;
wire [5:0] OpCode;
wire [4:0] rs;
wire [4:0] rt;
wire [4:0] rd;
wire [4:0] Shamt;
wire [5:0] Funct;
wire [31:0] PC_Plus_4;
wire IF_ID_Hold;
IF_ID_Reg IF_ID_Reg
    (
        .clk(clk),
        .reset(reset),
        .flush(IF_ID_Flush),
        .hold(IF_ID_Hold),
        .ReadInst(ReadInst),
        .IF_PC_Plus_4(PC_o + 4),
        .OpCode(OpCode),
        .rs(rs), .rt(rt), .rd(rd),
        .Shamt(Shamt),
        .Funct(Funct),
        .PC_Plus_4(PC_Plus_4)
    );

wire [4:0] MEM_WB_WriteAddr;
wire [31:0] MEM_WB_WriteData;
wire MEM_WB_RegWr;
wire [31:0] ReadData1;
wire [31:0] ReadData2;
RegFile RegFile
    (
        .clk(clk),
        .reset(reset),
        .ReadAddr1(rs),
        .ReadAddr2(rt),
        .WriteAddr(MEM_WB_WriteAddr),
        .WriteData(MEM_WB_WriteData),
        .RegWrite(MEM_WB_RegWr),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );

wire [31:0] ReadData1Actual;
wire [31:0] ReadData2Actual;
wire [1:0] ForwardA;
wire [1:0] ForwardB;

wire RegWr;
wire Branch;
wire BranchClip;
wire Jump;
wire MemRead;
wire MemWrite;
wire [1:0] MemtoReg;
wire JumpSrc;
wire ALUSrcA;
wire ALUSrcB;
wire [3:0] ALUOp;
wire [1:0] RegDst;
wire LuiOp;
wire SignedOp;
Controller Controller
    (
        .OpCode(OpCode),
        .Funct(Funct),
        .RegWr(RegWr),
        .Branch(Branch),
        .BranchClip(BranchClip),
        .Jump(Jump),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .JumpSrc(JumpSrc),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ALUOp(ALUOp),
        .RegDst(RegDst),
        .LuiOp(LuiOp),
        .SignedOp(SignedOp)
    );


wire [31:0] J_out;
assign J_out = Jump == 0 ? (PC_o + 4) :
                JumpSrc == 0 ? {PC_Plus_4[31:28], rs, rt, rd, Shamt, Funct, 2'b00} :
                ReadData1Actual;


wire [31:0] out_ext;
ImmExtend ImmExtend
    (
        .in({rd, Shamt, Funct}),
        .LuiOp(LuiOp),
        .SignedOp(SignedOp),
        .out_ext(out_ext)
    );

wire ID_EX_Flush;
ID_EX_Reg ID_EX_Reg
    (
        .clk(clk),
        .reset(reset),
        .flush(ID_EX_Flush),

        .ID_RegWr       (RegWr      ),
        .ID_Branch      (Branch     ),
        .ID_BranchClip  (BranchClip ),
        .ID_MemRead     (MemRead    ),
        .ID_MemWrite    (MemWrite   ),
        .ID_MemtoReg    (MemtoReg   ),
        .ID_ALUSrcA     (ALUSrcA    ),
        .ID_ALUSrcB     (ALUSrcB    ),
        .ID_ALUOp       (ALUOp      ),
        .ID_RegDst      (RegDst     ),

        .ID_ReadData1   (ReadData1Actual  ),
        .ID_ReadData2   (ReadData2Actual  ),
        .ID_imm_ext     (out_ext    ),

        .ID_PC_Plus_4   (PC_Plus_4  ),
        .ID_Shamt       (Shamt      ),
        .ID_rt          (rt         ),
        .ID_rd          (rd         )
    );


wire [31:0] ALU_in1;
wire [31:0] ALU_in2;
wire [31:0] ALU_out;
wire ALU_zero;

assign ALU_in1 = ID_EX_Reg.ALUSrcA == 0 ? ID_EX_Reg.ReadData1 :
                { 27'h0, ID_EX_Reg.Shamt };
assign ALU_in2 = ID_EX_Reg.ALUSrcB == 0 ? ID_EX_Reg.ReadData2 :
                ID_EX_Reg.imm_ext;

ALU ALU(ALU_in1, ALU_in2, ID_EX_Reg.ALUOp, ALU_out, ALU_zero);

wire no_branch;
assign no_branch = (ID_EX_Reg.Branch == 0 || !(ALU_zero ^ ID_EX_Reg.BranchClip));
assign PC_i = no_branch ? J_out :
                ID_EX_Reg.PC_Plus_4 + (ID_EX_Reg.imm_ext << 2);

wire [4:0] EX_WriteAddr;
assign EX_WriteAddr = ID_EX_Reg.RegDst == 2'b00 ? ID_EX_Reg.rd :
                        ID_EX_Reg.RegDst == 2'b01 ? ID_EX_Reg.rt :
                        5'd31;
EX_MEM_Reg EX_MEM_Reg
    (
        .clk(clk),
        .reset(reset),

        .EX_MemRead  (ID_EX_Reg.MemRead  ),
        .EX_MemWrite (ID_EX_Reg.MemWrite ),
        .EX_WriteData(ID_EX_Reg.ReadData2),
        .EX_WriteAddr(EX_WriteAddr       ),
        .EX_MemtoReg (ID_EX_Reg.MemtoReg ),
        .EX_RegWrite (ID_EX_Reg.RegWr    ),
        .EX_ALU_out  (ALU_out            ),
        .EX_PC_Plus_4(ID_EX_Reg.PC_Plus_4)
    );

wire [31:0] DataMemReadData;
DataMem DataMem
    (
        .clk(clk),
        .reset(reset),
        .addr(EX_MEM_Reg.ALU_out),
        .WriteData(EX_MEM_Reg.WriteData),
        .MemRead(EX_MEM_Reg.MemRead),
        .MemWrite(EX_MEM_Reg.MemWrite),
        .ReadData(DataMemReadData),
        .leds(leds),
        .AN(AN),
        .BCD(BCD)
    );

MEM_WB_Reg MEM_WB_Reg
    (
        .clk(clk),
        .reset(reset),
        .MEM_RegWr(EX_MEM_Reg.RegWrite),
        .MEM_MemtoReg(EX_MEM_Reg.MemtoReg),
        .MEM_WriteAddr(EX_MEM_Reg.WriteAddr),
        .MEM_ReadData(DataMemReadData),
        .MEM_ALU_result(EX_MEM_Reg.ALU_out),
        .MEM_PC_next(EX_MEM_Reg.PC_Plus_4)
    );

assign MEM_WB_WriteAddr = MEM_WB_Reg.WriteAddr;
assign MEM_WB_RegWr = MEM_WB_Reg.RegWr;
assign MEM_WB_WriteData =
                MEM_WB_Reg.MemtoReg == 2'b00 ? MEM_WB_Reg.ALU_result :
                MEM_WB_Reg.MemtoReg == 2'b01 ? MEM_WB_Reg.ReadData :
                MEM_WB_Reg.PC_next;

wire LW_Stall;
DataHazard DataHazard
    (
        .ID_EX_RegWrite(ID_EX_Reg.RegWr),
        .ID_EX_WriteAddr(EX_WriteAddr),
        .EX_MEM_RegWrite(EX_MEM_Reg.RegWrite),
        .EX_MEM_WriteAddr(EX_MEM_Reg.WriteAddr),
        .rs(rs),
        .rt(rt),
        .ID_EX_MemRead(ID_EX_Reg.MemRead),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB),
        .LW_Stall(LW_Stall)
    );

assign PC_Hold = LW_Stall;
assign IF_ID_Hold = LW_Stall;

wire Branch_ID_EX_Flush;
BranchAndJumpHazard BranchAndJumpHazard
    (
        .Jump(Jump),
        .no_branch(no_branch),
        .IF_ID_Flush(IF_ID_Flush),
        .ID_EX_Flush(Branch_ID_EX_Flush)
    );

assign ID_EX_Flush = Branch_ID_EX_Flush || LW_Stall;

// assign ReadData1Actual = ID_EX_Reg.ReadData1;
// assign ReadData2Actual = ID_EX_Reg.ReadData2;

assign ReadData1Actual =
        ForwardA == 2'b01 ? ALU_out :
        ForwardA == 2'b10 ?
            (
                EX_MEM_Reg.MemtoReg == 2'b00 ? EX_MEM_Reg.ALU_out :
                EX_MEM_Reg.MemtoReg == 2'b01 ? DataMemReadData :
                EX_MEM_Reg.PC_Plus_4
            ) :
        ReadData1;

assign ReadData2Actual =
        ForwardB == 2'b01 ? ALU_out :
        ForwardB == 2'b10 ?
            (
                EX_MEM_Reg.MemtoReg == 2'b00 ? EX_MEM_Reg.ALU_out :
                EX_MEM_Reg.MemtoReg == 2'b01 ? DataMemReadData :
                EX_MEM_Reg.PC_Plus_4
            ) :
        ReadData2;
endmodule
