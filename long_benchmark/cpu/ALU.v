`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2021/07/08 14:55:11
// Design Name: PipelineCPU
// Module Name: ALU
// Project Name: PipelineCPU
// Target Devices: xc7a35tcpg236-1
// Tool Versions: Vivado 2017.3
// Description: The ALU (arithmetic-logic unit) module.
// 
// Dependencies: None
// 
// Revision: None
// Revision 0.01 - File Created
// Additional Comments: None
// 
//////////////////////////////////////////////////////////////////////////////////

module ALU
(
    in1, in2, in3, in4,
    resultA, resultB, resultC, resultD, resultE, resultF, resultG, resultH,
    ALUOp, sel, out,
    result1, result2, result3, result4, result5, result6, zero
);

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
parameter bcd_op        = 4'hD;     // BCD correction
parameter sel_sum_op    = 4'hE;     // selective sum
parameter accu_sum_op   = 4'h2;     // accumulation sum

parameter DATA_WIDTH = 16;
parameter D = 1;
parameter H = 8;
parameter W = 8;
parameter F = 5;

input wire [31:0] in1, in2, in3, in4;
input wire [0:D*H*W*DATA_WIDTH-1] resultA, resultB, resultC, resultD, resultE, resultF, resultG, resultH;
input wire [3:0] ALUOp;
input wire sel;
output reg [31:0] out;
output wire [0:D*H*W*DATA_WIDTH-1] result1, result2, result3, result4, result5, result6;
output wire zero;
assign zero = out == 32'b0;

// Signed compare.
wire less_than_31;
wire less_than_signed;
assign less_than_31 = in1[30:0] < in2[30:0];
assign less_than_signed = (in1[31] == in2[31]) ? less_than_31 : (in1[31] ? 1 : 0);
wire [31:0] sum1, sum2, sum3, sum4, sum5, sum6;
wire [0:D*H*W*DATA_WIDTH-1] resultAB, resultCD, resultEF;
integer address, c, k, i;

always @ (*) begin
    address = 0;
    for (c = 0; c < W; c = c + 1) begin
        for (k = 0; k < D; k = k + 1) begin
            for (i = 0; i < F; i = i + 1) begin
                resultAB[address*DATA_WIDTH+:DATA_WIDTH] = resultA[address*DATA_WIDTH+:DATA_WIDTH] + resultB[address*DATA_WIDTH+:DATA_WIDTH];
                resultCD[address*DATA_WIDTH+:DATA_WIDTH] = resultC[address*DATA_WIDTH+:DATA_WIDTH] * resultD[address*DATA_WIDTH+:DATA_WIDTH];
                resultEF[address*DATA_WIDTH+:DATA_WIDTH] = resultE[address*DATA_WIDTH+:DATA_WIDTH] - resultF[address*DATA_WIDTH+:DATA_WIDTH];
                result1[address*DATA_WIDTH+:DATA_WIDTH] = resultAB[address*DATA_WIDTH+:DATA_WIDTH] + resultCD[address*DATA_WIDTH+:DATA_WIDTH];
                result2[address*DATA_WIDTH+:DATA_WIDTH] = resultCD[address*DATA_WIDTH+:DATA_WIDTH] + resultEF[address*DATA_WIDTH+:DATA_WIDTH];
                result3[address*DATA_WIDTH+:DATA_WIDTH] = (resultAB[address*DATA_WIDTH+:DATA_WIDTH] + resultG[address*DATA_WIDTH+:DATA_WIDTH]) + resultH[address*DATA_WIDTH+:DATA_WIDTH];
                result4[address*DATA_WIDTH+:DATA_WIDTH] = (resultCD[address*DATA_WIDTH+:DATA_WIDTH] + resultE[address*DATA_WIDTH+:DATA_WIDTH]) * resultAB[address*DATA_WIDTH+:DATA_WIDTH];
                result5[address*DATA_WIDTH+:DATA_WIDTH] = (resultCD[address*DATA_WIDTH+:DATA_WIDTH] + resultB[address*DATA_WIDTH+:DATA_WIDTH]) - (resultF[address*DATA_WIDTH+:DATA_WIDTH] + resultAB[address*DATA_WIDTH+:DATA_WIDTH]);
                result6[address*DATA_WIDTH+:DATA_WIDTH] = (resultAB[address*DATA_WIDTH+:DATA_WIDTH] + resultC[address*DATA_WIDTH+:DATA_WIDTH]) * resultEF[address*DATA_WIDTH+:DATA_WIDTH];
                address = address + 1;
            end
        end
    end
end

always @(*) begin
    case (ALUOp)
        add_op      : out <= in1 + in2;
        sub_op      : out <= in1 - in2;
        and_op      : out <= in1 & in2;
        or_op       : out <= in1 | in2;
        xor_op      : out <= in1 ^ in2;
        nor_op      : out <= ~(in1 | in2);
        u_cmp_op    : out <= in1 < in2;
        s_cmp_op    : out <= less_than_signed;
        sll_op      : out <= (in2 << in1[4:0]);
        srl_op      : out <= (in2 >> in1[4:0]);
        sra_op      : out <= ({{32{in2[31]}}, in2} >> in1[4:0]);
        gtz_op      : out <= (in1[31] == 0 && in1 != 0);
        bcd_op      : out <= (in2 + in1 < 10) ? in2 + in1 : (in2 + in1 + 6);
        sel_sum_op  : begin
                            if (sel) begin
                                sum1 = in1;
                                sum2 = 32'hA;
                            end else begin
                                sum1 <= in2;
                                sum2 <= 32'hB;
                            end
                            out <= sum1 + sum2;
                      end
        accu_sum_op :
                    begin
                        sum1 = in1 +  in2;
                        sum2 = in3 +  in4;
                        out <= sum1 + sum2;
                    end
        default: out <= 0;
    endcase
end
endmodule
