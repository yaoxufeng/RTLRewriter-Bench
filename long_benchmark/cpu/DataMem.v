`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tsinghua University
// Engineer: Timothy-LiuXuefeng
// 
// Create Date: 2021/07/08 16:26:57
// Design Name: PipelineCPU
// Module Name: DataMem
// Project Name: PipelineCPU
// Target Devices: xc7a35tcpg236-1
// Tool Versions: Vivado 2017.3
// Description: The memory to store data.
// 
// Dependencies: None
// 
// Revision: None
// Revision 0.01 - File Created
// Additional Comments: None
// 
///////////////////////////////////////////////////////////////////////////////////

module DataMem
(
    input wire clk,
    input wire reset,
    input wire [31:0] addr,
    input wire [31:0] WriteData,
    input wire MemRead,
    input wire MemWrite,
    output wire [31:0] ReadData,
    output reg [7:0] leds,
    output reg [3:0] AN,
    output reg [7:0] BCD
);

parameter MEM_SIZE = 512;
wire [29:0] word_addr;
reg [31:0] data [MEM_SIZE - 1:0];
assign word_addr = addr[31:2];
assign ReadData = MemRead == 0 ? 0 :
                    word_addr < MEM_SIZE ? data[word_addr] :
                    word_addr == 30'b0100_0000_0000_0000_0000_0000_0000_11 ? {24'h0, leds} :
                    word_addr == 30'b0100_0000_0000_0000_0000_0000_0001_00 ? {20'h0, AN, BCD} :
                    0;

integer j;
initial begin
    leds <= 0;
    AN <= 0;
    BCD <= 0;

    for (j = 0; j < MEM_SIZE; j = j + 1) begin
        data[j] <= 0;
    end
end

integer i;
always @(posedge clk or posedge reset) begin
    if (reset) begin
        leds <= 0;
        AN <= 0;
        BCD <= 0;

        for (i = 0; i < MEM_SIZE; i = i + 1) begin
            data[i] <= 0;
        end
    end
    else begin
        if (MemWrite) begin
            if (word_addr < MEM_SIZE) begin
                data[word_addr] <= WriteData;
            end
            else begin
                case (word_addr)
                30'b0100_0000_0000_0000_0000_0000_0000_11: begin
                    leds <= WriteData[7:0];
                end
                30'b0100_0000_0000_0000_0000_0000_0001_00: begin
                    BCD <= WriteData[7:0];
                    AN <= WriteData[11:8];
                end
                endcase
            end
        end
    end
end

endmodule
