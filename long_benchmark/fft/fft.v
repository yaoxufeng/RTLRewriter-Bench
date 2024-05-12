`timescale 1 ns / 100 ps

module filtered_power_fft8 (
    input                    clk,
    input                    rstn,
    input                    en,
    input                    sel,
    input signed [23:0]      x0_real,
    input signed [23:0]      x0_imag,
    input signed [23:0]      x1_real,
    input signed [23:0]      x1_imag,
    input signed [23:0]      x2_real,
    input signed [23:0]      x2_imag,
    input signed [23:0]      x3_real,
    input signed [23:0]      x3_imag,
    input signed [23:0]      x4_real,
    input signed [23:0]      x4_imag,
    input signed [23:0]      x5_real,
    input signed [23:0]      x5_imag,
    input signed [23:0]      x6_real,
    input signed [23:0]      x6_imag,
    input signed [23:0]      x7_real,
    input signed [23:0]      x7_imag,
    output                   valid,
    output signed [23:0]     y0_real,
    output signed [23:0]     y0_imag,
    output signed [23:0]     y1_real,
    output signed [23:0]     y1_imag,
    output signed [23:0]     y2_real,
    output signed [23:0]     y2_imag,
    output signed [23:0]     y3_real,
    output signed [23:0]     y3_imag,
    output signed [23:0]     y4_real,
    output signed [23:0]     y4_imag,
    output signed [23:0]     y5_real,
    output signed [23:0]     y5_imag,
    output signed [23:0]     y6_real,
    output signed [23:0]     y6_imag,
    output signed [23:0]     y7_real,
    output signed [23:0]     y7_imag,
    output [23:0] power
    );

    //operating data
    wire [23:0]                    power0, power1, power2, power3, power4, power5, power6, power7;
    wire signed [23:0]             xm_real [3:0] [7:0];
    wire signed [23:0]             xm_imag [3:0] [7:0];
    wire                           en_connect [15:0] ;
    assign                         en_connect[0] = en;
    assign                         en_connect[1] = en;
    assign                         en_connect[2] = en;
    assign                         en_connect[3] = en;

    //factor, multiplied by 0x2000
    wire signed [15:0]             factor_real [3:0] ;
    wire signed [15:0]             factor_imag [3:0];
    assign factor_real[0]        = 16'h2000; //1
    assign factor_imag[0]        = 16'h0000; //0
    assign factor_real[1]        = 16'h16a0; //sqrt(2)/2
    assign factor_imag[1]        = 16'he95f; //-sqrt(2)/2
    assign factor_real[2]        = 16'h0000; //0
    assign factor_imag[2]        = 16'he000; //-1
    assign factor_real[3]        = 16'he95f; //-sqrt(2)/2
    assign factor_imag[3]        = 16'he95f; //-sqrt(2)/2

    //输入初始化，和码位有关倒置
    assign xm_real[0][0] = x0_real;
    assign xm_real[0][1] = x4_real;
    assign xm_real[0][2] = x2_real;
    assign xm_real[0][3] = x6_real;
    assign xm_real[0][4] = x1_real;
    assign xm_real[0][5] = x5_real;
    assign xm_real[0][6] = x3_real;
    assign xm_real[0][7] = x7_real;
    assign xm_imag[0][0] = x0_imag;
    assign xm_imag[0][1] = x4_imag;
    assign xm_imag[0][2] = x2_imag;
    assign xm_imag[0][3] = x6_imag;
    assign xm_imag[0][4] = x1_imag;
    assign xm_imag[0][5] = x5_imag;
    assign xm_imag[0][6] = x3_imag;
    assign xm_imag[0][7] = x7_imag;

    //butter instantiaiton
    //integer              index[11:0] ;
    genvar               m, k;
    generate
    //3 stage
    for(m=0; m<=2; m=m+1) begin: stage
        for (k=0; k<=3; k=k+1) begin: unit

            butterfly           u_butter(
               .clk        (clk                 ) ,
               .rstn       (rstn                ) ,
               .en         (en_connect[m*4 + k] ) ,
               .xp_real    (xm_real[ m ] [k[m:0] < (1<<m) ?
                           (k[3:m] << (m+1)) + k[m:0] :
                           (k[3:m] << (m+1)) + (k[m:0]-(1<<m))] ),
               .xp_imag    (xm_imag[ m ] [k[m:0] < (1<<m) ?
                           (k[3:m] << (m+1)) + k[m:0] :
                           (k[3:m] << (m+1)) + (k[m:0]-(1<<m))] ),
               .xq_real    (xm_real[ m ] [(k[m:0] < (1<<m) ?
                           (k[3:m] << (m+1)) + k[m:0] :
                           (k[3:m] << (m+1)) + (k[m:0]-(1<<m))) + (1<<m) ]),
               .xq_imag    (xm_imag[ m ] [(k[m:0] < (1<<m) ?
                           (k[3:m] << (m+1)) + k[m:0] :
                           (k[3:m] << (m+1)) + (k[m:0]-(1<<m))) + (1<<m) ]),

               .factor_real(factor_real[k[m:0]<(1<<m)?
                            k[m:0] : k[m:0]-(1<<m) ]),
               .factor_imag(factor_imag[k[m:0]<(1<<m)?
                            k[m:0] : k[m:0]-(1<<m) ]),

               //output data
               .valid      (en_connect[ (m+1)*4 + k ]  ),
               .yp_real    (xm_real[ m+1 ][k[m:0] < (1<<m) ?
                           (k[3:m] << (m+1)) + k[m:0] :
                           (k[3:m] << (m+1)) + (k[m:0]-(1<<m))] ),
               .yp_imag    (xm_imag[ m+1 ][(k[m:0]) < (1<<m) ?
                           (k[3:m] << (m+1)) + k[m:0] :
                           (k[3:m] << (m+1)) + (k[m:0]-(1<<m))] ),
               .yq_real    (xm_real[ m+1 ][(k[m:0] < (1<<m) ?
                           (k[3:m] << (m+1)) + k[m:0] :
                           (k[3:m] << (m+1)) + (k[m:0]-(1<<m))) + (1<<m) ]),
               .yq_imag    (xm_imag[ m+1 ][((k[m:0]) < (1<<m) ?
                           (k[3:m] << (m+1)) + k[m:0] :
                           (k[3:m] << (m+1)) + (k[m:0]-(1<<m))) + (1<<m) ])
               );
            end
        end
    endgenerate

    assign     valid = en_connect[12];
    assign     y0_real = xm_real[3][0] ;
    assign     y0_imag = xm_imag[3][0] ;
    assign     y1_real = xm_real[3][1] ;
    assign     y1_imag = xm_imag[3][1] ;
    assign     y2_real = xm_real[3][2] ;
    assign     y2_imag = xm_imag[3][2] ;
    assign     y3_real = xm_real[3][3] ;
    assign     y3_imag = xm_imag[3][3] ;
    assign     y4_real = xm_real[3][4] ;
    assign     y4_imag = xm_imag[3][4] ;
    assign     y5_real = xm_real[3][5] ;
    assign     y5_imag = xm_imag[3][5] ;
    assign     y6_real = xm_real[3][6] ;
    assign     y6_imag = xm_imag[3][6] ;
    assign     y7_real = xm_real[3][7] ;
    assign     y7_imag = xm_imag[3][7] ;

    always @(*) begin
        if (sel) begin
            power0 = y0_real;
            power1 = y0_imag;
            power2 = y1_real;
            power3 = y1_imag;
            power4 = y2_real;
            power5 = y2_imag;
            power6 = y3_real;
            power7 = y3_imag;
        end else begin
            power0 = y4_real;
            power1 = y4_imag;
            power2 = y5_real;
            power3 = y5_imag;
            power4 = y6_real;
            power5 = y6_imag;
            power6 = y7_real;
            power7 = y7_imag;
        end
        power = power0 * power0 + power1 * power1 + power2 * power2 + power3 * power3 +power4 * power4 + power5 * power5 +power6 * power6 + power7 * power7;
    end
endmodule


