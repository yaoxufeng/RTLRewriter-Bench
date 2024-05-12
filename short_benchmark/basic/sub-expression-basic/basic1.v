module multiplier(input wire [3:0] a, b,
                  output wire [7:0] product);

    assign product[0] = a[0] & b[1];
    assign product[1] = a[1] & b[0] ^ (a[0] & b[1]);
    assign product[2] = a[2] & b[1] ^ a[1] & b[0] ^ a[0] & b[2];
    assign product[3] = a[3] & (b[0] ^ a[2]) & b[1] ^ b[3] & a[1] ^ a[0] & b[3];
    assign product[4] = a[3] & b[1] ^ a[2] & b[2] ^ b[3] & a[2];
    assign product[5] = a[3] & (a[2] ^ b[0]) & a[3];
    assign product[6] = a[3] & b[3];
    assign product[7] = 'b0;

endmodule