`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tsinghua University
// Engineer: Timothy-LiuXuefeng
// 
// Create Date: 2021/07/09 15:14:01
// Design Name: PipelineCPU
// Module Name: Controller
// Project Name: PipelineCPU
// Target Devices: xc7a35tcpg236-1
// Tool Versions: Vivado 2017.3
// Description: Tranform the instruction to control signals.
// 
// Dependencies: None
// 
// Revision: None
// Revision 0.01 - File Created
// Additional Comments: None
// 
//////////////////////////////////////////////////////////////////////////////////

module Controller
(
    input wire [5:0] OpCode,
    input wire [5:0] Funct,
    output reg RegWr,
    output reg Branch,
    output reg BranchClip,
    output reg Jump,
    output reg MemRead,
    output reg MemWrite,
    output reg [1:0] MemtoReg,
    output reg JumpSrc,
    output reg ALUSrcA,
    output reg ALUSrcB,
    output reg [3:0] ALUOp,
    output reg [1:0] RegDst,
    output reg LuiOp,
    output reg SignedOp
);

always @(*) begin

    // RegWr
    if (OpCode == 0)begin
        if (Funct == 6'h08) begin   // jr
            RegWr <= 0;
        end
        else RegWr <= 1;
    end
    else begin
        case (OpCode)
        6'hf, 6'h08, 6'h09, 6'h0c, 6'h0b, 6'h23, 6'h03: RegWr <= 1;
        default: RegWr <= 0;
        endcase
    end

    // Brach and BranchClip
    case (OpCode)
    6'h04, 6'h06:      // beq, blez
    begin
        Branch <= 1;
        BranchClip <= 0;
    end
    6'h05, 6'h07, 6'h01:   // bne, bgtz, bltz
    begin
        Branch <= 1;
        BranchClip <= 1;
    end
    default:
    begin
        Branch <= 0;
        BranchClip <= 0;
    end
    endcase

    // Jump
    if ((OpCode == 0 && (Funct == 6'h08 || Funct == 6'h09))
        || (OpCode == 6'h02 || OpCode == 6'h03)) Jump <= 1;
    else Jump <= 0;

    // MemRead
    MemRead <= OpCode == 6'h23;

    // MemWrite
    MemWrite <= OpCode == 6'h2b;

    // MemtoReg: 00-ALUResult, 01-Data-Mem, 10-PC+4 
    if (OpCode == 6'h23) MemtoReg <= 2'b01; // lw
    else if (OpCode == 6'h03 || (OpCode == 0 && Funct == 6'h09)) // jal, jalr
        MemtoReg <= 2'b10;
    else MemtoReg <= 2'b00;

    // JumpSrc: 0-Imm, 1-reg1
    JumpSrc <= OpCode == 0;

    // ALUSrcA: 0-ReadData1, 1-Shamt
    if (OpCode == 0 &&
        (Funct == 6'h0 || Funct == 6'h02 || Funct == 6'h03)
        )
        ALUSrcA <= 1;
    else ALUSrcA <= 0;

    // ALUSrcB: 0-ReadData2, 1-imm
    case (OpCode)
    6'h0f, 6'h08, 6'h09, 6'h0c, 6'h0b, 6'h23, 6'h2b: ALUSrcB <= 1;
    default: ALUSrcB <= 0;
    endcase

    // RegDst: 00-rd, 01-rt, 10-%ra
    case (OpCode)
    6'h0f, 6'h08, 6'h09, 6'h0c, 6'h0b, 6'h23: RegDst <= 2'b01; // I and lw
    6'h03: RegDst <= 2'b10;    // jal
    default: begin
        if (Funct == 6'h09) RegDst <= 2'b10;
        else RegDst <= 2'b00;
    end
    endcase

    // LuiOp
    LuiOp <= (OpCode == 6'h0f);

    // SignedOp
    SignedOp <= (OpCode == 6'h0c ? 0 : 1);
end

// ALUOp

parameter add_op        = 4'h0;     // add
parameter sub_op        = 4'h1;     // sub
parameter and_op        = 4'h3;     // and
parameter or_op         = 4'h4;     // or
parameter xor_op        = 4'h5;     // xor
parameter nor_op        = 4'h6;     // nor
parameter u_cmp_op      = 4'h7;     // unsigned cmp
parameter s_cmp_op      = 4'h8;     // signed cmp
parameter sll_op        = 4'h9;     // sll
parameter srl_op        = 4'hA;     // srl
parameter sra_op        = 4'hB;     // sra
parameter gtz_op        = 4'hC;     // gtz, greater than zero

always @(*) begin
    case (OpCode)
    6'h0: begin
        case (Funct)
        6'h20, 6'h21: ALUOp <= add_op;
        6'h22, 6'h23: ALUOp <= sub_op;
        6'h24: ALUOp <= and_op;
        6'h25: ALUOp <= or_op;
        6'h26: ALUOp <= xor_op;
        6'h27: ALUOp <= nor_op;
        6'h2a: ALUOp <= s_cmp_op;
        6'h2b: ALUOp <= u_cmp_op;
        6'h00: ALUOp <= sll_op;
        6'h02: ALUOp <= srl_op;
        6'h03: ALUOp <= sra_op;
        default: ALUOp <= add_op;
        endcase
    end
    6'h0f, 6'h08, 6'h09, 6'h23, 6'h2b: ALUOp <= add_op;
    6'h0c: ALUOp <= and_op;
    6'h0b: ALUOp <= u_cmp_op;
    6'h04, 6'h05: ALUOp <= sub_op;
    6'h06, 6'h07: ALUOp <= gtz_op;
    6'h01: ALUOp <= s_cmp_op;
    default: ALUOp <= add_op;
    endcase
end

endmodule
