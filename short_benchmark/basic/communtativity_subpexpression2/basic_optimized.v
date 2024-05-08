module example(
    input [31:0] X, Y, Z, P, Q, R, S, T,
    output [31:0] output1, output2, output3, output4, output5, output6
);

    wire [31:0] mx_XY, add_ZP, sub_QR, add_XP;
    assign mx_XY = X * Y ;
    assign add_ZP = Z + P;
    assign sub_QR = Q - R ;
    assign add_XP = X + P ;

    // Original expressions showing potential for optimization via commutativity and associativity
    assign output1 = mx_XY + add_ZP;
    assign output2 = add_ZP * sub_QR;
    assign output3 = (Y + S + X) + T;
    assign output4 = (mx_XY + Q) * add_XP;
    assign output5 = (mx_XY + P) - (R + add_XP);
    assign output6 = (add_XP + Y) * sub_QR;

endmodule