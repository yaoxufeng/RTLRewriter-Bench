//Carry lookahead adder -8bit inputs

module carry_look_ahead(a,b,cin, sum, cout);

input [7:0]a, b;
input cin;
output [7:0] sum;
output cout;
wire [7:0]p,g;
wire [6:0]c;

partial_full_adder p_adder_0(p[0],sum[0],g[0],a[0],b[0],cin);
assign c[0]=g[0]|(p[0]&cin);

genvar        i ;
generate
    for(i=1; i<7 ; i=i+1) begin: adder_gen
    partial_full_adder  p_adder(
            .pi     (p[i]),
            .si     (sum[i]),
            .gi     (g[i]),
            .ai     (a[i]),
            .bi    (b[i]),
            .ci    (c[i-1]));

    assign c[i]=g[i]|(p[i]&c[i-1]);
    end
endgenerate

partial_full_adder p_adder_1(p[7],sum[7],g[7],a[7],b[7],c[6]);
assign cout=g[7]|(p[7]&c[6]);
endmodule

//Partial Full adder code
module partial_full_adder(pi,si,gi,ai,bi,ci);
output pi;
output si;
output gi;
input ai;
input bi;
input ci;

wire pi2;
xor (pi,ai,bi);
xor (pi2,ai,bi);
xor (si,pi2,ci);
and (gi,ai,bi);
endmodule