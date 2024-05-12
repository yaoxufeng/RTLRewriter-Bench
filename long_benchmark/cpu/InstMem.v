`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tsinghua University
// Engineer: Timothy-LiuXuefeng
// 
// Create Date: 2021/07/08 20:45:55
// Design Name: PipelineCPU
// Module Name: InstMem
// Project Name: PipelineCPU
// Target Devices: xc7a35tcpg236-1
// Tool Versions: Vivado 2017.3
// Description: The memory to save instructions
// 
// Dependencies: None
// 
// Revision: None
// Revision 0.01 - File Created
// Additional Comments: None
// 
//////////////////////////////////////////////////////////////////////////////////


module InstMem
(
    input wire [31:0] ReadAddr,
    output wire [31:0] ReadInst
);

parameter MEM_SIZE = 512;
reg [31:0] data [MEM_SIZE:0];

assign ReadInst = data[ReadAddr[10:2]];

integer i;
initial begin
    data[9'h0 ] <= 32'h20040005;
    data[9'h1 ] <= 32'h20080080;
    data[9'h2 ] <= 32'h03a8e822;
    data[9'h3 ] <= 32'h23a50000;
    data[9'h4 ] <= 32'h20060005;
    data[9'h5 ] <= 32'h20080002;
    data[9'h6 ] <= 32'haca80000;
    data[9'h7 ] <= 32'h2008000c;
    data[9'h8 ] <= 32'haca80004;
    data[9'h9 ] <= 32'h20080001;
    data[9'hA ] <= 32'haca80008;
    data[9'hB ] <= 32'h2008000a;
    data[9'hC ] <= 32'haca8000c;
    data[9'hD ] <= 32'h20080003;
    data[9'hE ] <= 32'haca80010;
    data[9'hF ] <= 32'h20080014;
    data[9'h10] <= 32'haca80014;
    data[9'h11] <= 32'h20080002;
    data[9'h12] <= 32'haca80018;
    data[9'h13] <= 32'h2008000f;
    data[9'h14] <= 32'haca8001c;
    data[9'h15] <= 32'h20080001;
    data[9'h16] <= 32'haca80020;
    data[9'h17] <= 32'h20080008;
    data[9'h18] <= 32'haca80024;
    data[9'h19] <= 32'h20080100;
    data[9'h1A] <= 32'h03a8e822;
    data[9'h1B] <= 32'h23b00000;
    data[9'h1C] <= 32'h20080000;
    data[9'h1D] <= 32'h20090040;
    data[9'h1E] <= 32'h0109482a;
    data[9'h1F] <= 32'h11200005;
    data[9'h20] <= 32'h00084880;
    data[9'h21] <= 32'h01304820;
    data[9'h22] <= 32'had200000;
    data[9'h23] <= 32'h21080001;
    data[9'h24] <= 32'h0810001d;
    data[9'h25] <= 32'h20080000;
    data[9'h26] <= 32'h0104502a;
    data[9'h27] <= 32'h1140001b;
    data[9'h28] <= 32'h000850c0;
    data[9'h29] <= 32'h01455020;
    data[9'h2A] <= 32'h8d510000;
    data[9'h2B] <= 32'h8d520004;
    data[9'h2C] <= 32'h00065880;
    data[9'h2D] <= 32'h01705820;
    data[9'h2E] <= 32'h00d16022;
    data[9'h2F] <= 32'h000c6080;
    data[9'h30] <= 32'h01906020;
    data[9'h31] <= 32'h20c90000;
    data[9'h32] <= 32'h0120502a;
    data[9'h33] <= 32'h1540000d;
    data[9'h34] <= 32'h0131502a;
    data[9'h35] <= 32'h15400007;
    data[9'h36] <= 32'h8d6d0000;
    data[9'h37] <= 32'h8d8e0000;
    data[9'h38] <= 32'h01d27020;
    data[9'h39] <= 32'h01cd782a;
    data[9'h3A] <= 32'h11e00001;
    data[9'h3B] <= 32'h0810003d;
    data[9'h3C] <= 32'had6e0000;
    data[9'h3D] <= 32'h216bfffc;
    data[9'h3E] <= 32'h218cfffc;
    data[9'h3F] <= 32'h2129ffff;
    data[9'h40] <= 32'h08100032;
    data[9'h41] <= 32'h21080001;
    data[9'h42] <= 32'h08100026;
    data[9'h43] <= 32'h00061080;
    data[9'h44] <= 32'h00501020;
    data[9'h45] <= 32'h8c420000;
    data[9'h46] <= 32'h20100000;
    data[9'h47] <= 32'h00104302;
    data[9'h48] <= 32'h31080003;
    data[9'h49] <= 32'h20090000;
    data[9'h4A] <= 32'h11090006;
    data[9'h4B] <= 32'h20090001;
    data[9'h4C] <= 32'h11090007;
    data[9'h4D] <= 32'h20090002;
    data[9'h4E] <= 32'h11090009;
    data[9'h4F] <= 32'h20090003;
    data[9'h50] <= 32'h1109000b;
    data[9'h51] <= 32'h20110e00;
    data[9'h52] <= 32'h3052000f;
    data[9'h53] <= 32'h08100060;
    data[9'h54] <= 32'h20110d00;
    data[9'h55] <= 32'h00029102;
    data[9'h56] <= 32'h3252000f;
    data[9'h57] <= 32'h08100060;
    data[9'h58] <= 32'h20110b00;
    data[9'h59] <= 32'h00029202;
    data[9'h5A] <= 32'h3252000f;
    data[9'h5B] <= 32'h08100060;
    data[9'h5C] <= 32'h20110700;
    data[9'h5D] <= 32'h00029302;
    data[9'h5E] <= 32'h3252000f;
    data[9'h5F] <= 32'h08100060;
    data[9'h60] <= 32'h20090000;
    data[9'h61] <= 32'h1249001e;
    data[9'h62] <= 32'h21290001;
    data[9'h63] <= 32'h1249001f;
    data[9'h64] <= 32'h21290001;
    data[9'h65] <= 32'h12490020;
    data[9'h66] <= 32'h21290001;
    data[9'h67] <= 32'h12490021;
    data[9'h68] <= 32'h21290001;
    data[9'h69] <= 32'h12490022;
    data[9'h6A] <= 32'h21290001;
    data[9'h6B] <= 32'h12490023;
    data[9'h6C] <= 32'h21290001;
    data[9'h6D] <= 32'h12490024;
    data[9'h6E] <= 32'h21290001;
    data[9'h6F] <= 32'h12490025;
    data[9'h70] <= 32'h21290001;
    data[9'h71] <= 32'h12490026;
    data[9'h72] <= 32'h21290001;
    data[9'h73] <= 32'h12490027;
    data[9'h74] <= 32'h21290001;
    data[9'h75] <= 32'h12490028;
    data[9'h76] <= 32'h21290001;
    data[9'h77] <= 32'h12490029;
    data[9'h78] <= 32'h21290001;
    data[9'h79] <= 32'h1249002a;
    data[9'h7A] <= 32'h21290001;
    data[9'h7B] <= 32'h1249002b;
    data[9'h7C] <= 32'h21290001;
    data[9'h7D] <= 32'h1249002c;
    data[9'h7E] <= 32'h21290001;
    data[9'h7F] <= 32'h1249002d;
    data[9'h80] <= 32'h200c00c0;
    data[9'h81] <= 32'h022c9025;
    data[9'h82] <= 32'h081000b0;
    data[9'h83] <= 32'h200c00f9;
    data[9'h84] <= 32'h022c9025;
    data[9'h85] <= 32'h081000b0;
    data[9'h86] <= 32'h200c00a4;
    data[9'h87] <= 32'h022c9025;
    data[9'h88] <= 32'h081000b0;
    data[9'h89] <= 32'h200c00b0;
    data[9'h8A] <= 32'h022c9025;
    data[9'h8B] <= 32'h081000b0;
    data[9'h8C] <= 32'h200c0099;
    data[9'h8D] <= 32'h022c9025;
    data[9'h8E] <= 32'h081000b0;
    data[9'h8F] <= 32'h200c0092;
    data[9'h90] <= 32'h022c9025;
    data[9'h91] <= 32'h081000b0;
    data[9'h92] <= 32'h200c0082;
    data[9'h93] <= 32'h022c9025;
    data[9'h94] <= 32'h081000b0;
    data[9'h95] <= 32'h200c00f8;
    data[9'h96] <= 32'h022c9025;
    data[9'h97] <= 32'h081000b0;
    data[9'h98] <= 32'h200c0080;
    data[9'h99] <= 32'h022c9025;
    data[9'h9A] <= 32'h081000b0;
    data[9'h9B] <= 32'h200c0090;
    data[9'h9C] <= 32'h022c9025;
    data[9'h9D] <= 32'h081000b0;
    data[9'h9E] <= 32'h200c0088;
    data[9'h9F] <= 32'h022c9025;
    data[9'hA0] <= 32'h081000b0;
    data[9'hA1] <= 32'h200c0083;
    data[9'hA2] <= 32'h022c9025;
    data[9'hA3] <= 32'h081000b0;
    data[9'hA4] <= 32'h200c00c6;
    data[9'hA5] <= 32'h022c9025;
    data[9'hA6] <= 32'h081000b0;
    data[9'hA7] <= 32'h200c00a1;
    data[9'hA8] <= 32'h022c9025;
    data[9'hA9] <= 32'h081000b0;
    data[9'hAA] <= 32'h200c0086;
    data[9'hAB] <= 32'h022c9025;
    data[9'hAC] <= 32'h081000b0;
    data[9'hAD] <= 32'h200c008e;
    data[9'hAE] <= 32'h022c9025;
    data[9'hAF] <= 32'h081000b0;
    data[9'hB0] <= 32'h3c0a4000;
    data[9'hB1] <= 32'h214a0010;
    data[9'hB2] <= 32'had520000;
    data[9'hB3] <= 32'h22100001;
    data[9'hB4] <= 32'h08100047;

    for (i = 9'hB5; i < MEM_SIZE; i = i + 1)
    begin
        data[i] <= 0;
    end
end

endmodule

