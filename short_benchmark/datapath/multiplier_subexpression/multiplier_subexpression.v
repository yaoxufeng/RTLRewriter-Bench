// This implementation generates and adds partial products independently for each bit of the multiplier and multiplicand without reusing any computational results.

module basic_array_multiplier(
    input [7:0] multiplicand,  // 8-bit multiplicand
    input [7:0] multiplier,    // 8-bit multiplier
    output [15:0] product      // 16-bit product output
);

// Two-dimensional array to hold all partial products
wire [7:0] partial_products[7:0];

genvar i, j;
generate
    for (i = 0; i < 8; i = i + 1) begin: gen_rows
        for (j = 0; j < 8; j = j + 1) begin: gen_cols
            // Generate each partial product separately
            assign partial_products[i][j] = multiplicand[i] & multiplier[j];
        end
    end
endgenerate

// Summing all partial products into the final product
wire [15:0] sum[7:0]; // Intermediate sums

// Initialize the first sum with the least significant partial product row
assign sum[0] = {8'b0, partial_products[0]};

// Accumulate each row of partial products into the sum
generate
    for (i = 1; i < 8; i = i + 1) begin: gen_sum
        wire [15:0] shifted_partial = {8'b0, partial_products[i]} << i;
        assign sum[i] = sum[i-1] + shifted_partial;
    end
endgenerate

// The final product is the sum of the last accumulation
assign product = sum[7];

endmodule