//Ripple carry adder

module ripple_adder(a, b, cin, sum, cout);

input [7:0] a, b;
input cin;
output [7:0]sum;
output cout;
wire[6:0] c;

full_adder  u_adder0(
                    .a       (a[0]),
                    .b       (b[0]),
                    .cin     (cin),
                    .sum     (sum[0]),
                    .cout    (c[0]));

genvar        i ;
generate
    for(i=1; i<7 ; i=i+1) begin: adder_gen
    full_adder  u_adder(
        .a     (a[i]),
        .b     (b[i]),
        .cin   (c[i-1]),
        .sum   (sum[i]),
        .cout  (c[i]));
    end
endgenerate

full_adder  u_adder1(
        .a       (a[7]),
        .b       (b[7]),
        .cin     (c[6]),
        .sum     (sum[7]),
        .cout    (cout));

endmodule

module full_adder(a, b, cin, sum, cout);
    input a;
    input b;
    input cin;
    output sum;
    output cout;

    assign sum=(a^b^cin);
    assign cout=((a&b)|(b&cin)|(a&cin));
endmodule