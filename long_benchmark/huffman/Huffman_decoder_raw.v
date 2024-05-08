`timescale 1ns/1ps

module Cal_with_decoder_raw (encodedDataA, encodedDataB, encodedDataC, encodedDataD, encodedDataE, encodedDataF, encodedDataG, encodedDataH,
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

module HuffmanDecoder (symbolLength, decodedData, ready, encodedData, load, clk, rst);
parameter symb_S =  3'b010;
parameter symb_K =  3'b001;
parameter symb_R =  3'b000;

parameter symb_J =  4'b1111;
parameter symb_T =  4'b1110;
parameter symb_Q =  4'b1011;
parameter symb_I =  4'b1010;
parameter symb_U =  4'b1001;
parameter symb_L =  4'b1000;

parameter symb_V =  5'b11010;
parameter symb_H =  5'b11001;
parameter symb_P =  5'b11000;

parameter symb_M =  5'b01101;
parameter symb_W =  5'b01100;

parameter symb_G =  6'b011111;
parameter symb_X =  6'b011101;

parameter symb_O =  7'b1101111;
parameter symb_F =  7'b1101110;
parameter symb_N =  7'b1101100;

parameter symb_Y =  7'b0111100;
parameter symb_E =  7'b0111000;

parameter symb_Z =  8'b11011011;

parameter symb_a =  8'b01111011;
parameter symb_D =  8'b01111010;
parameter symb_C =  8'b01110010;
parameter symb_B =  9'b110110101;

parameter symb_d = 10'b1101101001;
parameter symb_b = 10'b1101101000;
parameter symb_e = 10'b0111001100;
parameter symb_c = 10'b0111001101;
parameter symb_f = 10'b0111001111;
parameter symb_A = 10'b0111001110;


//Outputs
output reg [4:0] decodedData;     //5 bits to represent 32 different data
output reg [3:0] symbolLength;    //4 bits to represent upto length 16.
output reg [3:0] ready;

//Inputs
input [9:0] encodedData;     // 10 bits sliding window; equals the maximum length of encoded data
input       clk;             // Clock
input       rst;             // Active Low Reset
input       load;            // Load input data when asserted

reg state;                   // FSM State
reg enable;                  // Enable signal to LUT
reg [4:0] symbol;            // Symbol input to LUT -> Converts symbol to address for LUT
reg [9:0] upper_reg;
reg [9:0] lower_reg;

//==============================================================
// Main State Machine
//==============================================================

always @(posedge clk or negedge rst) begin
  if (!rst) begin
     upper_reg <= 10'b0;
     lower_reg <= 10'b0;
     state <= 'd0;
     enable <= 1'b0;
     symbol <= 5'b0;
     ready  <= 1'b1;
     symbolLength <= 4'd0;
  end // end if (!rst)
  else begin
       case (state)
          'd0: begin   // Load input data into lower register
	         if (load) begin
	            lower_reg <= encodedData;
	            state <= 'd1;
	         end
	         else state <= 'd0;
		 ready <= 1'b1;
	  end
	  'd1: begin   // Load new data into lower register and old data upper register
	         if (load) begin
	            upper_reg <= lower_reg;
	            lower_reg <= encodedData;
	            state <= 'd2;
	         end
	         else state <= 'd1;
		 ready <= 1'b0;
	  end
	  'd2: begin   // Check if the 3 length codes are contained in input
	         if  (upper_reg[9])
	              state <= 'd3;
	         else if (upper_reg[8:7] == 2'b10) begin
		       symbol <= 5'd0;  // S
		       enable <= 1'b1;
	               state <= 'd2;    // -> Go back to check for length 3 codes
		       ready <= 1'b1;
                       symbolLength <= 4'd3;
		       upper_reg <= {upper_reg[6:0], lower_reg[9:7]};
		       lower_reg <= {lower_reg[6:0], encodedData[9:7]};
		 end
		 else if (upper_reg[8:7] == 2'b01) begin
		       symbol <= 5'd1;  // K
		       enable <= 1'b1;
	               state <= 'd2;    // -> Go back to check for length 3 codes
		       ready <= 1'b1;
                       symbolLength <= 4'd3;
		       upper_reg <= {upper_reg[6:0], lower_reg[9:7]};
		       lower_reg <= {lower_reg[6:0], encodedData[9:7]};
		 end
		 else if (upper_reg[8:7] == 2'b00) begin
		       symbol <= 5'd2;  // R
		       enable <= 1'b1;
	               state <= 'd2;    // -> Go back to check for length 3 codes
		       ready <= 1'b1;
                       symbolLength <= 4'd3;
		       upper_reg <= {upper_reg[6:0], lower_reg[9:7]};
		       lower_reg <= {lower_reg[6:0], encodedData[9:7]};
		 end
		 else begin             // [8:7] == 2'b11 -> Go to checks for length 5 codes (First One)
	               state <= 'd4;
		       ready <= 1'b0;
		 end
	  end
	  'd3: begin   // Check if the 4 length codes are contained in input
	          if  (upper_reg[8])
	              if  (upper_reg[7:6] == 2'b11) begin
		          symbol <= 5'd3;  // J
		          enable <= 1'b1;
	                  state <= 'd2;    // -> Go back to check for length 3 codes
		          ready <= 1'b1;
                          symbolLength <= 4'd4;
		          upper_reg <= {upper_reg[5:0], lower_reg[9:6]};
		          lower_reg <= {lower_reg[5:0], encodedData[9:6]};
		      end
	              else if  (upper_reg[7:6] == 2'b10) begin
		          symbol <= 5'd4;  // T
		          enable <= 1'b1;
	                  state <= 'd2;    // -> Go back to check for length 3 codes
		          ready <= 1'b1;
                          symbolLength <= 4'd4;
		          upper_reg <= {upper_reg[5:0], lower_reg[9:6]};
		          lower_reg <= {lower_reg[5:0], encodedData[9:6]};
		      end
		      else begin
	          	  state <= 'd5; // Go to checks for length 5 codes (Second One)
		          ready <= 1'b0;
		      end
	          else // upper_reg[8] == 0
	              if  (upper_reg[7:6] == 2'b11) begin
		          symbol <= 5'd5;  // Q
		          enable <= 1'b1;
	                  state <= 'd2;    // -> Go back to check for length 3 codes
		          ready <= 1'b1;
                          symbolLength <= 4'd4;
		          upper_reg <= {upper_reg[5:0], lower_reg[9:6]};
		          lower_reg <= {lower_reg[5:0], encodedData[9:6]};
		      end
	              else if  (upper_reg[7:6] == 2'b10) begin
		          symbol <= 5'd6;  // I
		          enable <= 1'b1;
	                  state <= 'd2;    // -> Go back to check for length 3 codes
		          ready <= 1'b1;
                          symbolLength <= 4'd4;
		          upper_reg <= {upper_reg[5:0], lower_reg[9:6]};
		          lower_reg <= {lower_reg[5:0], encodedData[9:6]};
		      end
	              else if  (upper_reg[7:6] == 2'b01) begin
		          symbol <= 5'd7;  // U
		          enable <= 1'b1;
	                  state <= 'd2;    // -> Go back to check for length 3 codes
		          ready <= 1'b1;
                          symbolLength <= 4'd4;
		          upper_reg <= {upper_reg[5:0], lower_reg[9:6]};
		          lower_reg <= {lower_reg[5:0], encodedData[9:6]};
		      end
	              else begin
		          symbol <= 5'd8;  // L
		          enable <= 1'b1;
	                  state <= 'd2;    // -> Go back to check for length 3 codes
		          ready <= 1'b1;
                          symbolLength <= 4'd4;
		          upper_reg <= {upper_reg[5:0], lower_reg[9:6]};
		          lower_reg <= {lower_reg[5:0], encodedData[9:6]};
		      end
	  end
	  'd4: begin   // Check for the 5 length codes (Already have 011 checked till this point)
	              if  (upper_reg[6:5] == 2'b01) begin
		          symbol <= 5'd12;  // M
		          enable <= 1'b1;
	                  state <= 'd2;    // -> Go back to checks for length 3 codes
		          ready <= 1'b1;
                          symbolLength <= 4'd5;
		          upper_reg <= {upper_reg[4:0], lower_reg[9:5]};
		          lower_reg <= {lower_reg[4:0], encodedData[9:5]};
		      end
	              else if  (upper_reg[6:5] == 2'b00) begin
		          symbol <= 5'd13;  // W
		          enable <= 1'b1;
	                  state <= 'd2;    // -> Go back to checks for length 3 codes
		          ready <= 1'b1;
                          symbolLength <= 4'd5;
		          upper_reg <= {upper_reg[4:0], lower_reg[9:5]};
		          lower_reg <= {lower_reg[4:0], encodedData[9:5]};
		      end
	              else begin // (upper_reg[6:5] == 2'b10 or 2'b11)
	                  state <= 'd6;    // -> Go to checks for length 6 codes
		          ready <= 1'b0;
		      end
	  end
	  'd5: begin   // Check for the 5 length codes (Already have checked 110 till this point)
	              if  (upper_reg[6:5] == 2'b10) begin
		          symbol <= 5'd9;  // V
		          enable <= 1'b1;
	                  state <= 'd2;    // -> Go back to checks for length 3 codes
		          ready <= 1'b1;
                          symbolLength <= 4'd5;
		          upper_reg <= {upper_reg[4:0], lower_reg[9:5]};
		          lower_reg <= {lower_reg[4:0], encodedData[9:5]};
		      end
	              else if  (upper_reg[6:5] == 2'b01) begin
		          symbol <= 5'd10;  // H
		          enable <= 1'b1;
	                  state <= 'd2;    // -> Go back to checks for length 3 codes
		          ready <= 1'b1;
                          symbolLength <= 4'd5;
		          upper_reg <= {upper_reg[4:0], lower_reg[9:5]};
		          lower_reg <= {lower_reg[4:0], encodedData[9:5]};
		      end
	              else if  (upper_reg[6:5] == 2'b00) begin
		          symbol <= 5'd11;  // P
		          enable <= 1'b1;
	                  state <= 'd2;    // -> Go back to checks for length 3 codes
		          ready <= 1'b1;
                          symbolLength <= 4'd5;
		          upper_reg <= {upper_reg[4:0], lower_reg[9:5]};
		          lower_reg <= {lower_reg[4:0], encodedData[9:5]};
		      end
	              else begin // (upper_reg[6:5] == 2'b11)
	                  state <= 'd7;    // -> Go to checks for length 7 codes (First One)
		          ready <= 1'b0;
		      end
          end
	  'd6: begin   // Check for the 6 length codes (Already have checked 0111 till this point)
	              if  (upper_reg[5:4] == 2'b11) begin
		          symbol <= 5'd14;  // G
		          enable <= 1'b1;
	                  state <= 'd2;    // -> Go back to checks for length 3 codes
		          ready <= 1'b1;
                          symbolLength <= 4'd6;
		          upper_reg <= {upper_reg[3:0], lower_reg[9:4]};
		          lower_reg <= {lower_reg[3:0], encodedData[9:4]};
		      end
	              else if  (upper_reg[5:4] == 2'b01) begin
		          symbol <= 5'd15;  // X
		          enable <= 1'b1;
	                  state <= 'd2;    // -> Go back to checks for length 3 codes
		          ready <= 1'b1;
                          symbolLength <= 4'd6;
		          upper_reg <= {upper_reg[3:0], lower_reg[9:4]};
		          lower_reg <= {lower_reg[3:0], encodedData[9:4]};
		      end
		      else  begin //upper_reg[5:4] == 2'b10 or 00
		          state <= 'd8;     // -> Go to checks for length 7 codes (Second One)
		          ready <= 1'b0;
		      end
	  end
	  'd7: begin   // Check for the 7 length codes (Already have checked 11011 till this point)
	              if  (upper_reg[4:3] == 2'b11) begin
		          symbol <= 5'd16;  // O
		          enable <= 1'b1;
	                  state <= 'd2;    // -> Go back to checks for length 3 codes
		          ready <= 1'b1;
                          symbolLength <= 4'd7;
		          upper_reg <= {upper_reg[2:0], lower_reg[9:3]};
		          lower_reg <= {lower_reg[2:0], encodedData[9:3]};
		      end
	              else if  (upper_reg[4:3] == 2'b10) begin
		          symbol <= 5'd17;  // F
		          enable <= 1'b1;
	                  state <= 'd2;    // -> Go back to checks for length 3 codes
		          ready <= 1'b1;
                          symbolLength <= 4'd7;
		          upper_reg <= {upper_reg[2:0], lower_reg[9:3]};
		          lower_reg <= {lower_reg[2:0], encodedData[9:3]};
		      end
	              else if  (upper_reg[4:3] == 2'b00) begin
		          symbol <= 5'd18;  // N
		          enable <= 1'b1;
	                  state <= 'd2;    // -> Go back to checks for length 3 codes
		          ready <= 1'b1;
                          symbolLength <= 4'd7;
		          upper_reg <= {upper_reg[2:0], lower_reg[9:3]};
		          lower_reg <= {lower_reg[2:0], encodedData[9:3]};
		      end
		      else begin
		          state <= 'd9;     // -> Go to checks for length 8 codes (First One)
		          ready <= 1'b0;
		      end
	  end
	  'd8: begin   // Check for the 7 length codes (Already have checked 0111 till this point)
	              if  (!upper_reg[3])
		          if (upper_reg[5]) begin
		              symbol <= 5'd19;  // Y
		              enable <= 1'b1;
	                      state <= 'd2;    // -> Go back to checks for length 3 codes
		              ready <= 1'b1;
                              symbolLength <= 4'd7;
		              upper_reg <= {upper_reg[2:0], lower_reg[9:3]};
		              lower_reg <= {lower_reg[2:0], encodedData[9:3]};
		          end
			  else begin
		              symbol <= 5'd20;  // E
		              enable <= 1'b1;
	                      state <= 'd2;    // -> Go back to checks for length 3 codes
		              ready <= 1'b1;
                              symbolLength <= 4'd7;
		              upper_reg <= {upper_reg[2:0], lower_reg[9:3]};
		              lower_reg <= {lower_reg[2:0], encodedData[9:3]};
		          end
		      else begin //(upper_reg[3])
	                    state <= 'd10;    // -> Go to checks for length 8 codes (Second One)
		            ready <= 1'b0;
		      end
	  end
	  'd9: begin   // Check for the 8 length codes (Already have checked 1101101 till this point)
	              if  (upper_reg[2] == 1'b1) begin
		              symbol <= 5'd21;  // Z
		              enable <= 1'b1;
	                      state <= 'd2;    // -> Go back to checks for length 3 codes
		              ready <= 1'b1;
                              symbolLength <= 4'd8;
		              upper_reg <= {upper_reg[1:0], lower_reg[9:2]};
		              lower_reg <= {lower_reg[1:0], encodedData[9:2]};
		      end
		      else begin
	                      state <= 'd11;    // -> Go to checks for length 9 codes
		              ready <= 1'b0;
		      end
	  end
	  'd10: begin   // Check for the 8 length codes (Already have checked 0111 till this point)
	              if  (!upper_reg[2])
		          if (upper_reg[5]) begin
		              symbol <= 5'd23;  // D
		              enable <= 1'b1;
	                      state <= 'd2;    // -> Go back to checks for length 3 codes
		              ready <= 1'b1;
                              symbolLength <= 4'd8;
		              upper_reg <= {upper_reg[1:0], lower_reg[9:2]};
		              lower_reg <= {lower_reg[1:0], encodedData[9:2]};
		          end
			  else begin
		              symbol <= 5'd24;  // C
		              enable <= 1'b1;
	                      state <= 'd2;    // -> Go back to checks for length 3 codes
		              ready <= 1'b1;
                              symbolLength <= 4'd8;
		              upper_reg <= {upper_reg[1:0], lower_reg[9:2]};
		              lower_reg <= {lower_reg[1:0], encodedData[9:2]};
		          end
	              else  //(upper_reg[2])
		          if (upper_reg[5]) begin
		              symbol <= 5'd22;  // a
		              enable <= 1'b1;
	                      state <= 'd2;    // -> Go back to checks for length 3 codes
		              ready <= 1'b1;
                              symbolLength <= 4'd8;
		              upper_reg <= {upper_reg[1:0], lower_reg[9:2]};
		              lower_reg <= {lower_reg[1:0], encodedData[9:2]};
		          end
			  else begin
	                      state <= 'd13;    // -> Go back to checks for length 10 codes (Second One)
		              ready <= 1'b0;
			  end
	  end
	  'd11: begin   // Check for the 9 length codes (Already have checked 11011010 till this point)
	              if  (upper_reg[1] == 1'b1) begin
		              symbol <= 5'd25;  // B
		              enable <= 1'b1;
	                      state <= 'd2;    // -> Go back to checks for length 3 codes
		              ready <= 1'b1;
                              symbolLength <= 4'd9;
		              upper_reg <= {upper_reg[0:0], lower_reg[9:1]};
		              lower_reg <= {lower_reg[0:0], encodedData[9:1]};
		      end
		      else begin
	                      state <= 'd12;    // -> Go to checks for length 10 codes (First One)
		              ready <= 1'b0;
		      end
	  end
	  'd12: begin   // Check for the 10 length codes (Already have checked 110110100 till this point)
	              if  (upper_reg[0] == 1'b1) begin
		              symbol <= 5'd26;  // d
		              enable <= 1'b1;
	                      state <= 'd2;    // -> Go back to checks for length 3 codes
		              ready <= 1'b1;
                              symbolLength <= 4'd10;
		              upper_reg <= lower_reg[9:0];
		              lower_reg <= encodedData[9:0];
		      end
		      else begin
		              symbol <= 5'd29;  // b
		              enable <= 1'b1;
	                      state <= 'd2;    // -> Go back to checks for length 3 codes
		              ready <= 1'b1;
                              symbolLength <= 4'd10;
		              upper_reg <= lower_reg[9:0];
		              lower_reg <= encodedData[9:0];
		      end
	  end
	  'd13: begin   // Check for the 10 length codes (Already have checked 01110011 till this point)
	              if  (upper_reg[1:0] == 2'b00) begin
		              symbol <= 5'd27;  // e
		              enable <= 1'b1;
	                      state <= 'd2;    // -> Go back to checks for length 3 codes
		              ready <= 1'b1;
                              symbolLength <= 4'd10;
		              upper_reg <= lower_reg[9:0];
		              lower_reg <= encodedData[9:0];
		      end
	              else if  (upper_reg[1:0] == 2'b01) begin
		              symbol <= 5'd28;  // c
		              enable <= 1'b1;
	                      state <= 'd2;    // -> Go back to checks for length 3 codes
		              ready <= 1'b1;
                              symbolLength <= 4'd10;
		              upper_reg <= lower_reg[9:0];
		              lower_reg <= encodedData[9:0];
		      end
	              else if  (upper_reg[1:0] == 2'b10) begin
		              symbol <= 5'd31;  // A
		              enable <= 1'b1;
	                      state <= 'd2;    // -> Go back to checks for length 3 codes
		              ready <= 1'b1;
                              symbolLength <= 4'd10;
		              upper_reg <= lower_reg[9:0];
		              lower_reg <= encodedData[9:0];
		      end
	              else begin //  (upper_reg[1:0] == 2'b11)
		              symbol <= 5'd30;  // f
		              enable <= 1'b1;
	                      state <= 'd2;    // -> Go back to checks for length 3 codes
		              ready <= 1'b1;
                              symbolLength <= 4'd10;
		              upper_reg <= lower_reg[9:0];
		              lower_reg <= encodedData[9:0];
		      end
	  end
     endcase
  end
end

//==============================================================
// Instantiate LookUp Table
//==============================================================
     lookUpTable LUT (
              .enable (enable),
		      .symbol (symbol),
		      .decodedData (decodedData)
       		     );

endmodule



module lookUpTable (
	            input enable,
	            input [4:0] symbol,
	            output reg [4:0] decodedData
                   );

always @(*) begin
        if (enable)
	case (symbol)
		5'd0: begin
			decodedData = 5'd18;  // Symbol S
		      end
		5'd1: begin
			decodedData = 5'd10;  // Symbol K
                      end
		5'd2: begin
			decodedData = 5'd17;  // Symbol R
	              end
		5'd3: begin
			decodedData = 5'd9;  // Symbol J
                      end
		5'd4: begin
			decodedData = 5'd19;  // Symbol T
		      end
		5'd5: begin
			decodedData = 5'd16;  // Symbol Q
		      end
		5'd6: begin
			decodedData = 5'd8;  // Symbol I
		      end
		5'd7: begin
			decodedData = 5'd20;  // Symbol U
		      end
		5'd8: begin
			decodedData = 5'd11;  // Symbol L
		      end
		5'd9: begin
			decodedData = 5'd21;  // Symbol V
		      end
	       5'd10: begin
			decodedData = 5'd7;  // Symbol H
	     	      end
	       5'd11: begin
			decodedData = 5'd15;  // Symbol P
		      end
		5'd12: begin
			decodedData = 5'd12;  // Symbol M
		       end
		5'd13: begin
			decodedData = 5'd22;  // Symbol W
		       end
		5'd14: begin
			decodedData = 5'd6;  // Symbol G
		       end
		5'd15: begin
			decodedData = 5'd23;  // Symbol X
		       end
		5'd16: begin
			decodedData = 5'd14;  // Symbol O
		       end
		5'd17: begin
			decodedData = 5'd5;  // Symbol F
		       end
		5'd18: begin
			decodedData = 5'd13;  // Symbol N
		       end
		5'd19: begin
			decodedData = 5'd24;  // Symbol Y
		       end
		5'd20: begin
			decodedData = 5'd4;  // Symbol E
		       end
		5'd21: begin
			decodedData = 5'd25;  // Symbol Z
		       end
		5'd22: begin
			decodedData = 5'd26;  // Symbol a
		       end
		5'd23: begin
			decodedData = 5'd3;  // Symbol D
		       end
		5'd24: begin
			decodedData = 5'd2;  // Symbol C
		       end
		5'd25: begin
			decodedData = 5'd1;  // Symbol B
		       end
		5'd26: begin
			decodedData = 5'd29;  // Symbol d
		       end
		5'd27: begin
			decodedData = 5'd30;  // Symbol e
		       end
		5'd28: begin
			decodedData = 5'd28;  // Symbol c
		       end
		5'd29: begin
			decodedData = 5'd27;  // Symbol b
		       end
		5'd30: begin
			decodedData = 5'd31;  // Symbol f
		       end
		5'd31: begin
			decodedData = 5'd0;  // Symbol A
		       end
		default: begin
		          decodedData = 5'd0;  // Symbol A
		         end
               endcase
           else begin
	        decodedData = 5'hzz;
	   end
end
endmodule
