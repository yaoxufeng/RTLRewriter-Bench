`timescale 1ns/1ps

module decoder_raw (encodedDataA, encodedDataB, encodedDataC, encodedDataD, encodedDataE, encodedDataF, encodedDataG, encodedDataH,
    load, clk, rst, sel,
    symbolLengthA, symbolLengthB, symbolLengthC, symbolLengthD, symbolLengthE, symbolLengthF,
    decodedDataA, decodedDataB, decodedDataC, decodedDataD, decodedDataE, decodedDataF,
    result1, result2, result3, result4, result5, result6, decodedSum);

    parameter DATA_WIDTH = 16;
    parameter D = 1;
    parameter H = 8;
    parameter W = 8;
    parameter F = 3;

    //Inputs
    input [0: D*H*W*DATA_WIDTH-1] encodedDataA, encodedDataB, encodedDataC, encodedDataD, encodedDataE, encodedDataF, encodedDataG, encodedDataH;     // 10 bits sliding window; equals the maximum length of encoded data
    input       load;            // Load input data when asserted
    input       clk;             // Clock
    input       rst;             // Active Low Reset
    input       sel;             // sel decoded data

    //Outputs
    output reg [31:0] decodedSum;      //5 bits to represent 32 different data
    output reg [31:0] decodedDataA, decodedDataB, decodedDataC, decodedDataD, decodedDataE, decodedDataF;
	output reg [3:0] symbolLengthA, symbolLengthB, symbolLengthC, symbolLengthD, symbolLengthE, symbolLengthF;    //4 bits to represent upto length 16.
    output wire [0: D*H*W*DATA_WIDTH-1] result1, result2, result3, result4, result5, result6;

   //Internals
    reg [3:0] readyA, readyB, readyC, readyD, readyE, readyF;

    HuffmanDecoder decA (
          .symbolLength (symbolLengthA),
          .decodedData (decodedDataA),
          .ready (readyA),
          .encodedData (encodedDataA),
          .load (load),
          .clk (clk),
          .rst (rst)
           );

    HuffmanDecoder decB (
          .symbolLength (symbolLengthB),
          .decodedData (decodedDataB),
          .ready (readyB),
          .encodedData (encodedDataB),
          .load (load),
          .clk (clk),
          .rst (rst)
           );

    HuffmanDecoder decC (
          .symbolLength (symbolLengthC),
          .decodedData (decodedDataC),
          .ready (readyC),
          .encodedData (encodedDataC),
          .load (load),
          .clk (clk),
          .rst (rst)
           );

    HuffmanDecoder decD (
          .symbolLength (symbolLengthD),
          .decodedData (decodedDataD),
          .ready (readyD),
          .encodedData (encodedDataD),
          .load (load),
          .clk (clk),
          .rst (rst)
           );

    HuffmanDecoder decE (
          .symbolLength (symbolLengthE),
          .decodedData (decodedDataE),
          .ready (readyE),
          .encodedData (encodedDataE),
          .load (load),
          .clk (clk),
          .rst (rst)
           );

    HuffmanDecoder decF (
          .symbolLength (symbolLengthF),
          .decodedData (decodedDataF),
          .ready (readyF),
          .encodedData (encodedDataF),
          .load (load),
          .clk (clk),
          .rst (rst)
           );

integer address, c, k, i;
always @ (*) begin
    address = 0;
    for (c = 0; c < W; c = c + 1) begin
        for (k = 0; k < D; k = k + 1) begin
            for (i = 0; i < F; i = i + 1) begin
                result1[address*DATA_WIDTH+:DATA_WIDTH] = (encodedDataA[address*DATA_WIDTH+:DATA_WIDTH] + encodedDataB[address*DATA_WIDTH+:DATA_WIDTH]) + (encodedDataC[address*DATA_WIDTH+:DATA_WIDTH] * encodedDataD[address*DATA_WIDTH+:DATA_WIDTH]);
                result2[address*DATA_WIDTH+:DATA_WIDTH] = (encodedDataD[address*DATA_WIDTH+:DATA_WIDTH] * encodedDataC[address*DATA_WIDTH+:DATA_WIDTH]) + (encodedDataE[address*DATA_WIDTH+:DATA_WIDTH] - encodedDataF[address*DATA_WIDTH+:DATA_WIDTH]);
                result3[address*DATA_WIDTH+:DATA_WIDTH] = (encodedDataB[address*DATA_WIDTH+:DATA_WIDTH] + encodedDataG[address*DATA_WIDTH+:DATA_WIDTH] + encodedDataA[address*DATA_WIDTH+:DATA_WIDTH]) + encodedDataH[address*DATA_WIDTH+:DATA_WIDTH];
                result4[address*DATA_WIDTH+:DATA_WIDTH] = (encodedDataD[address*DATA_WIDTH+:DATA_WIDTH] * encodedDataC[address*DATA_WIDTH+:DATA_WIDTH] + encodedDataE[address*DATA_WIDTH+:DATA_WIDTH]) * (encodedDataB[address*DATA_WIDTH+:DATA_WIDTH] + encodedDataA[address*DATA_WIDTH+:DATA_WIDTH]);
                result5[address*DATA_WIDTH+:DATA_WIDTH] = (encodedDataC[address*DATA_WIDTH+:DATA_WIDTH] * encodedDataD[address*DATA_WIDTH+:DATA_WIDTH] + encodedDataB[address*DATA_WIDTH+:DATA_WIDTH]) - (encodedDataF[address*DATA_WIDTH+:DATA_WIDTH] + encodedDataB[address*DATA_WIDTH+:DATA_WIDTH] + encodedDataA[address*DATA_WIDTH+:DATA_WIDTH]);
                result6[address*DATA_WIDTH+:DATA_WIDTH] = (encodedDataA[address*DATA_WIDTH+:DATA_WIDTH] + encodedDataC[address*DATA_WIDTH+:DATA_WIDTH] + encodedDataB[address*DATA_WIDTH+:DATA_WIDTH]) * (encodedDataE[address*DATA_WIDTH+:DATA_WIDTH] - encodedDataF[address*DATA_WIDTH+:DATA_WIDTH]);
                address = address + 1;
            end
        end
    end
end
endmodule