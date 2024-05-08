`timescale 100 ns / 10 ps

//this modules takes as inputs the image, a row number and a column number
//it fills the output array with matrices of the parts of the image to be sent to the conv units

module RFselector_raw(image, rowNumber, column, sel, imageA, imageB, imageC, imageD, receptiveField, receptiveFieldSum1, receptiveFieldSum2, receptiveFieldSumAccumulation, imageSel);

parameter DATA_WIDTH = 4;         // 16
parameter D = 1; //Depth of the filter
parameter H = 16; //Height of the image
parameter W = 16; //Width of the image
parameter F = 5; //Size of the filter

input [0:D*H*W*DATA_WIDTH-1] image;
input [0:D*H*W*DATA_WIDTH-1] imageA, imageB, imageC, imageD;
input [5:0] rowNumber, column;
input sel;
output reg [0:(((W-F+1)/2)*D*F*F*DATA_WIDTH)-1] receptiveField;  //array to hold the matrices (parts of the image) to be sent to the conv units
output reg [0:F*DATA_WIDTH-1] receptiveFieldSum1, receptiveFieldSum2, receptiveFieldSumAccumulation;
output reg [0:D*H*W*DATA_WIDTH-1] imageSel;


//address: counter to fill the receptive filed array
//c: counter to loop on the columns of the input image
//k: counter to loop on the depth of the input image
//i: counter to loop on the rows of the input image
integer address, c, k, i, address2;

always @ (image or rowNumber or column) begin
	address = 0;
	if (column == 0) begin //if the column is zero fill the array with the parts of the image corresponding to the first half of pixels of the row (with rowNumber) of the output image
		for (c = 0; c < (W-F+1)/2; c = c + 1) begin
			for (k = 0; k < D; k = k + 1) begin
				for (i = 0; i < F; i = i + 1) begin
					receptiveField[address*F*DATA_WIDTH+:F*DATA_WIDTH] = image[rowNumber*W*DATA_WIDTH+c*DATA_WIDTH+k*H*W*DATA_WIDTH+i*W*DATA_WIDTH+:F*DATA_WIDTH];
					address = address + 1;
				end
			end
		end
	end else begin //if the column is zero fill the array with the parts of the image corresponding to the second half of pixels of the row (with rowNumber) of the output image
		for (c = (W-F+1)/2; c < (W-F+1); c = c + 1) begin
			for (k = 0; k < D; k = k + 1) begin
				for (i = 0; i < F; i = i + 1) begin
					receptiveField[address*F*DATA_WIDTH+:F*DATA_WIDTH] = image[rowNumber*W*DATA_WIDTH+c*DATA_WIDTH+k*H*W*DATA_WIDTH+i*W*DATA_WIDTH+:F*DATA_WIDTH];
					address = address + 1;
				end
			end
		end
	end

	// sum order issue
    receptiveFieldSum1 = image[rowNumber*W*DATA_WIDTH+0*DATA_WIDTH+0*H*W*DATA_WIDTH+0*W*DATA_WIDTH+:F*DATA_WIDTH] + image[rowNumber*W*DATA_WIDTH+1*DATA_WIDTH+0*H*W*DATA_WIDTH+1*W*DATA_WIDTH+:F*DATA_WIDTH] + image[rowNumber*W*DATA_WIDTH+2*DATA_WIDTH+0*H*W*DATA_WIDTH+2*W*DATA_WIDTH+:F*DATA_WIDTH];
    receptiveFieldSum2 = image[rowNumber*W*DATA_WIDTH+2*DATA_WIDTH+0*H*W*DATA_WIDTH+2*W*DATA_WIDTH+:F*DATA_WIDTH] + image[rowNumber*W*DATA_WIDTH+1*DATA_WIDTH+0*H*W*DATA_WIDTH+1*W*DATA_WIDTH+:F*DATA_WIDTH] + image[rowNumber*W*DATA_WIDTH+0*DATA_WIDTH+0*H*W*DATA_WIDTH+0*W*DATA_WIDTH+:F*DATA_WIDTH];

	// selective sum issue
	if (sel) begin
        imageSel = imageA + imageB;
    end else begin
        imageSel = imageC + imageD;
    end

    // sum accumulation
	// receptiveFieldSumAccumulation = image[rowNumber*W*DATA_WIDTH+0*DATA_WIDTH+0*H*W*DATA_WIDTH+0*W*DATA_WIDTH+:F*DATA_WIDTH] + image[rowNumber*W*DATA_WIDTH+0*DATA_WIDTH+0*H*W*DATA_WIDTH+1*W*DATA_WIDTH+:F*DATA_WIDTH] + image[rowNumber*W*DATA_WIDTH+0*DATA_WIDTH+0*H*W*DATA_WIDTH+2*W*DATA_WIDTH+:F*DATA_WIDTH] + image[rowNumber*W*DATA_WIDTH+1*DATA_WIDTH+0*H*W*DATA_WIDTH+0*W*DATA_WIDTH+:F*DATA_WIDTH] + image[rowNumber*W*DATA_WIDTH+1*DATA_WIDTH+0*H*W*DATA_WIDTH+1*W*DATA_WIDTH+:F*DATA_WIDTH] + image[rowNumber*W*DATA_WIDTH+1*DATA_WIDTH+0*H*W*DATA_WIDTH+2*W*DATA_WIDTH+:F*DATA_WIDTH] + image[rowNumber*W*DATA_WIDTH+2*DATA_WIDTH+0*H*W*DATA_WIDTH+0*W*DATA_WIDTH+:F*DATA_WIDTH] + image[rowNumber*W*DATA_WIDTH+2*DATA_WIDTH+0*H*W*DATA_WIDTH+1*W*DATA_WIDTH+:F*DATA_WIDTH] + image[rowNumber*W*DATA_WIDTH+2*DATA_WIDTH+0*H*W*DATA_WIDTH+2*W*DATA_WIDTH+:F*DATA_WIDTH];

end
endmodule

