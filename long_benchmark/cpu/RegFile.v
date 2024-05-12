`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tsinghua University
// Engineer: Timothy-LiuXuefeng
// 
// Create Date: 2021/07/08 14:28:23
// Design Name: PipelineCPU
// Module Name: RegFile
// Project Name: PipelineCPU
// Target Devices: xc7a35tcpg236-1
// Tool Versions: Vivado 2017.3
// Description: The register file.
// 
// Dependencies: None
// 
// Revision: None
// Revision 0.01 - File Created
// Additional Comments: None
// 
//////////////////////////////////////////////////////////////////////////////////

module RegFile
(
    input wire clk,
    input wire reset,
    input wire [4:0] ReadAddr1,
    input wire [4:0] ReadAddr2,
    input wire [4:0] WriteAddr,
    input wire [31:0] WriteData,
    input wire RegWrite,
    output wire [31:0] ReadData1,
    output wire [31:0] ReadData2
);

reg [31:0] data [31:1];

assign ReadData1 =
            ReadAddr1 == 0 ? 32'h0 :
            RegWrite && WriteAddr == ReadAddr1 ? WriteData :
            data[ReadAddr1];
assign ReadData2 =
            ReadAddr2 == 0 ? 32'h0 :
            RegWrite && WriteAddr == ReadAddr2 ? WriteData :
            data[ReadAddr2];

integer j;
initial begin
    for (j = 1; j < 29; j = j + 1) begin
        data[j] <= 0;
    end
    data[29] <= 32'h000007fc;   // $sp
    for (j = 30; j < 32; j = j + 1) begin
        data[j] <= 0;
    end
end
integer i;
always @(posedge clk or posedge reset) begin
    if (reset) begin
        for (i = 1; i < 29; i = i + 1) begin
            data[i] <= 0;
        end
        data[29] <= 32'h000007fc;   // $sp
        for (i = 30; i < 32; i = i + 1) begin
            data[i] <= 0;
        end
    end
    else begin
        if (RegWrite && WriteAddr != 0) begin
            data[WriteAddr] <= WriteData;
        end
    end
end

endmodule
