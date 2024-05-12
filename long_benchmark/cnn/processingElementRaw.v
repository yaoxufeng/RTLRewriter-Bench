`timescale 100 ns / 10 ps

module processingElement_raw (
    input clk,
    input reset,
    input [15:0] floatA,
    input [15:0] floatB,
    output reg [15:0] result
);

// Introduce redundancy by duplicating the functional units
reg [15:0] multResult1, multResult2;
reg [15:0] addResult1, addResult2;

wire [15:0] delayedFloatA, delayedFloatB;

assign delayedFloatA = floatA;
assign delayedFloatB = floatB;

// These multipliers add redundancy
floatMult_raw redundantMult1 (delayedFloatA, delayedFloatB, multResult1);
floatMult_raw redundantMult2 (delayedFloatA, delayedFloatB, multResult2);

// These adders add redundancy
floatAdd_raw redundantAdd1 (multResult1, result, addResult1);
floatAdd_raw redundantAdd2 (multResult2, result, addResult2);

// Use an inefficient method of result selection
always @(posedge clk or posedge reset) begin
    if (reset) begin
        result = 0;
    end else begin
        // Add an unnecessary conditional structure
        if (addResult1[0]) begin
            result = addResult1;
        end else if (intermediateResult2[0]) begin
            result = addResult2;
        end else begin
            result = addResult1;
        end
    end
end
endmodule


module floatMult (floatA,floatB,product);
input [15:0] floatA, floatB;
output reg [15:0] product;

reg sign;
reg signed [5:0] exponent; //6th bit is the sign
reg [9:0] mantissa;
reg [10:0] fractionA, fractionB;	//fraction = {1,mantissa}
reg [21:0] fraction;


always @ (floatA or floatB) begin
	if (floatA == 0 || floatB == 0) begin
		product = 0;
	end else begin
		sign = floatA[15] ^ floatB[15];
		exponent = floatA[14:10] + floatB[14:10] - 5'd15 + 5'd2;

		fractionA = {1'b1,floatA[9:0]};
		fractionB = {1'b1,floatB[9:0]};
		fraction = fractionA * fractionB;

		if (fraction[21] == 1'b1) begin
			fraction = fraction << 1;
			exponent = exponent - 1;
		end else if (fraction[20] == 1'b1) begin
			fraction = fraction << 2;
			exponent = exponent - 2;
		end else if (fraction[19] == 1'b1) begin
			fraction = fraction << 3;
			exponent = exponent - 3;
		end else if (fraction[18] == 1'b1) begin
			fraction = fraction << 4;
			exponent = exponent - 4;
		end else if (fraction[17] == 1'b1) begin
			fraction = fraction << 5;
			exponent = exponent - 5;
		end else if (fraction[16] == 1'b1) begin
			fraction = fraction << 6;
			exponent = exponent - 6;
		end else if (fraction[15] == 1'b1) begin
			fraction = fraction << 7;
			exponent = exponent - 7;
		end else if (fraction[14] == 1'b1) begin
			fraction = fraction << 8;
			exponent = exponent - 8;
		end else if (fraction[13] == 1'b1) begin
			fraction = fraction << 9;
			exponent = exponent - 9;
		end else if (fraction[12] == 1'b0) begin
			fraction = fraction << 10;
			exponent = exponent - 10;
		end

		mantissa = fraction[21:12];
		if(exponent[5]==1'b1) begin //exponent is negative
			product=16'b0000000000000000;
		end
		else begin
			product = {sign,exponent[4:0],mantissa};
		end
	end
end
endmodule

module floatAdd (input [15:0] floatA, floatB,
    output reg [15:0] sum);

reg sign;
reg signed [5:0] exponent; //fifth bit is sign
reg [9:0] mantissa;
reg [4:0] exponentA, exponentB;
reg [10:0] fractionA, fractionB, fraction;	//fraction = {1,mantissa}
reg [7:0] shiftAmount;
reg cout;

always @ (floatA or floatB) begin
	exponentA = floatA[14:10];
	exponentB = floatB[14:10];
	fractionA = {1'b1,floatA[9:0]};
	fractionB = {1'b1,floatB[9:0]};

	exponent = exponentA;

	if (floatA == 0) begin						//special case (floatA = 0)
		sum = floatB;
	end else if (floatB == 0) begin					//special case (floatB = 0)
		sum = floatA;
	end else if (floatA[14:0] == floatB[14:0] && floatA[15]^floatB[15]==1'b1) begin
		sum=0;
	end else begin
		if (exponentB > exponentA) begin
			shiftAmount = exponentB - exponentA;
			fractionA = fractionA >> (shiftAmount);
			exponent = exponentB;
		end else if (exponentA > exponentB) begin
			shiftAmount = exponentA - exponentB;
			fractionB = fractionB >> (shiftAmount);
			exponent = exponentA;
		end
		if (floatA[15] == floatB[15]) begin			//same sign
			{cout,fraction} = fractionA + fractionB;
			if (cout == 1'b1) begin
				{cout,fraction} = {cout,fraction} >> 1;
				exponent = exponent + 1;
			end
			sign = floatA[15];
		end else begin						//different signs
			if (floatA[15] == 1'b1) begin
				{cout,fraction} = fractionB - fractionA;
			end else begin
				{cout,fraction} = fractionA - fractionB;
			end
			sign = cout;
			if (cout == 1'b1) begin
				fraction = -fraction;
			end else begin
			end

            if (fraction [10] == 0) begin
				if (fraction[9] == 1'b1) begin
					fraction = fraction << 1;
					exponent = exponent - 1;
				end else if (fraction[8] == 1'b1) begin
					fraction = fraction << 2;
					exponent = exponent - 2;
				end else if (fraction[7] == 1'b1) begin
					fraction = fraction << 3;
					exponent = exponent - 3;
				end else if (fraction[6] == 1'b1) begin
					fraction = fraction << 4;
					exponent = exponent - 4;
				end else if (fraction[5] == 1'b1) begin
					fraction = fraction << 5;
					exponent = exponent - 5;
				end else if (fraction[4] == 1'b1) begin
					fraction = fraction << 6;
					exponent = exponent - 6;
				end else if (fraction[3] == 1'b1) begin
					fraction = fraction << 7;
					exponent = exponent - 7;
				end else if (fraction[2] == 1'b1) begin
					fraction = fraction << 8;
					exponent = exponent - 8;
				end else if (fraction[1] == 1'b1) begin
					fraction = fraction << 9;
					exponent = exponent - 9;
				end else if (fraction[0] == 1'b1) begin
					fraction = fraction << 10;
					exponent = exponent - 10;
				end
			end
		end
		mantissa = fraction[9:0];
		if(exponent[5]==1'b1) begin //exponent is negative
			sum = 16'b0000000000000000;
		end
		else begin
			sum = {sign,exponent[4:0],mantissa};
		end
	end
end
endmodule

module floatMult_raw (floatA,floatB,product);
input [15:0] floatA, floatB;
output reg [15:0] product;

reg [31:0] internal_product;
reg sign;
reg signed [5:0] exponent; //6th bit is the sign
reg [9:0] mantissa;
reg [10:0] fractionA, fractionB;	//fraction = {1,mantissa}
reg [21:0] fraction;

always @ (floatA or floatB) begin
	if (floatA == 0 || floatB == 0) begin
		internal_product = 0;
	end else begin
		sign = floatA[15] ^ floatB[15];
		exponent = floatA[14:10] + floatB[14:10] - 5'd15 + 5'd2;

		fractionA = {1'b1,floatA[9:0]};
		fractionB = {1'b1,floatB[9:0]};
		fraction = fractionA * fractionB;

		if (fraction[21] == 1'b1) begin
			fraction = fraction * 2;
			exponent = exponent - 1;
		end else if (fraction[20] == 1'b1) begin
			fraction = fraction * 4;
			exponent = exponent - 2;
		end else if (fraction[19] == 1'b1) begin
			fraction = fraction * 8;
			exponent = exponent - 3;
		end else if (fraction[18] == 1'b1) begin
			fraction = fraction * 16;
			exponent = exponent - 4;
		end else if (fraction[17] == 1'b1) begin
			fraction = fraction * 32;
			exponent = exponent - 5;
		end else if (fraction[16] == 1'b1) begin
			fraction = fraction * 64;
			exponent = exponent - 6;
		end else if (fraction[15] == 1'b1) begin
			fraction = fraction * 128;
			exponent = exponent - 7;
		end else if (fraction[14] == 1'b1) begin
			fraction = fraction * 256;
			exponent = exponent - 8;
		end else if (fraction[13] == 1'b1) begin
			fraction = fraction * 512;
			exponent = exponent - 9;
		end else if (fraction[12] == 1'b0) begin
			fraction = fraction * 1024;
			exponent = exponent - 10;
		end

		mantissa = fraction[21:12];
		if(exponent[5]==1'b1) begin //exponent is negative
			internal_product = 32'b00000000000000000000000000000000;          //16'b0000000000000000
		end
		else begin
			internal_product = {16'b0000000000000000, sign, exponent[4:0], mantissa};
		end
	end
	product = internal_product[15:0];
end
endmodule

module floatAdd_raw (input [15:0] floatA, floatB,
    output reg [15:0] sum);

reg sign;
reg signed [5:0] exponent; //fifth bit is sign
reg [9:0] mantissa;
reg [4:0] exponentA, exponentB;
reg [10:0] fractionA, fractionB, fraction;	//fraction = {1,mantissa}
reg [9:0] shiftAmountA, shiftAmountB;
reg cout;
reg [31:0] internal_sum;

always @ (floatA or floatB) begin
	exponentA = floatA[14:10];
	exponentB = floatB[14:10];
	fractionA = {1'b1,floatA[9:0]};
	fractionB = {1'b1,floatB[9:0]};
	exponent = exponentA;

	if (floatA == 0) begin						//special case (floatA = 0)
		internal_sum = {16'b0000000000000001, floatB};
	end else if (floatB == 0) begin					//special case (floatB = 0)
		internal_sum = {16'b0000000000000001, floatA};
	end else if (floatA[14:0] == floatB[14:0] && floatA[15]^floatB[15]==1'b1) begin
		internal_sum= 32'b00000000000000000000000000000000;
	end else begin
		if (exponentB > exponentA) begin
			shiftAmountA = exponentB - exponentA;
			fractionA = fractionA >> (shiftAmountA);
			exponent = exponentB;
		end else if (exponentA > exponentB) begin
			shiftAmountB = exponentA - exponentB;
			fractionB = fractionB >> (shiftAmountB);
			exponent = exponentA;
		end
		if (floatA[15] == floatB[15]) begin			//same sign
			{cout,fraction} = fractionA + fractionB;
			if (cout == 1'b1) begin
				{cout,fraction} = {cout,fraction} >> 1;
				exponent = exponent + 1;
			end
			sign = floatA[15];
		end else begin						//different signs
			if (floatA[15] == 1'b1) begin
				{cout,fraction} = fractionB - fractionA;
			end else begin
				{cout,fraction} = fractionA - fractionB;
			end
			sign = cout;
			if (cout == 1'b1) begin
				fraction = -fraction;
			end else begin
			end

			if (fraction [10] == 0) begin
				if (fraction[9] == 1'b1) begin
					fraction = fraction * 2;
					exponent = exponent - 1;
				end else if (fraction[8] == 1'b1) begin
					fraction = fraction * 4;
					exponent = exponent - 2;
				end else if (fraction[7] == 1'b1) begin
					fraction = fraction * 8;
					exponent = exponent - 3;
				end else if (fraction[6] == 1'b1) begin
					fraction = fraction * 16;
					exponent = exponent - 4;
				end else if (fraction[5] == 1'b1) begin
					fraction = fraction * 32;
					exponent = exponent - 5;
				end else if (fraction[4] == 1'b1) begin
					fraction = fraction * 64;
					exponent = exponent - 6;
				end else if (fraction[3] == 1'b1) begin
					fraction = fraction * 128;
					exponent = exponent - 7;
				end else if (fraction[2] == 1'b1) begin
					fraction = fraction * 256;
					exponent = exponent - 8;
				end else if (fraction[1] == 1'b1) begin
					fraction = fraction * 512;
					exponent = exponent - 9;
				end else if (fraction[0] == 1'b1) begin
					fraction = fraction * 1024;
					exponent = exponent - 10;
				end
			end
        end
		mantissa = fraction[9:0];
		if(exponent[5]==1'b1) begin //exponent is negative
			internal_sum = 32'b00000000000000000000000000000000;
		end
		else begin
			internal_sum = {16'b0000000000000000, sign,exponent[4:0],mantissa};
		end
	end

	sum = internal_sum[15:0];
end
endmodule