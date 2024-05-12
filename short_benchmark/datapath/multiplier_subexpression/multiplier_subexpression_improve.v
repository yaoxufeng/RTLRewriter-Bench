module multiplier_with_subexpression_sharing(
    input [7:0] multiplicand,  // 8-bit multiplicand
    input [7:0] multiplier,    // 8-bit multiplier
    output [15:0] product      // 16-bit product output
);

wire [15:0] partial_products[7:0];  // Array to hold partial products

// Generate partial products using subexpression sharing
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
        assign partial_products[i] = (multiplier[i] ? {8'b0, multiplicand} << i : 16'b0);
    end
endgenerate

// Add all partial products using a binary tree reduction for further optimization
wire [15:0] sum_stage1[3:0];
wire [15:0] sum_stage2[1:0];

assign sum_stage1[0] = partial_products[0] + partial_products[1];
assign sum_stage1[1] = partial_products[2] + partial_products[3];
assign sum_stage1[2] = partial_products[4] + partial_products[5];
assign sum_stage1[3] = partial_products[6] + partial_products[7];

assign sum_stage2[0] = sum_stage1[0] + sum_stage1[1];
assign sum_stage2[1] = sum_stage1[2] + sum_stage1[3];

assign product = sum_stage2[0] + sum_stage2[1];

endmodule
