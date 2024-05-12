/**************** butter unit *************************
Xm(p) ------------------------> Xm+1(p)
           -        ->
             -    -
                -
              -   -
            -        ->
Xm(q) ------------------------> Xm+1(q)
      Wn          -1
*//////////////////////////////////////////////////////
module butterfly
    (
     input                       clk,
     input                       rstn,
     input                       en,
     input signed [23:0]         xp_real, // Xm(p)
     input signed [23:0]         xp_imag,
     input signed [23:0]         xq_real, // Xm(q)
     input signed [23:0]         xq_imag,
     input signed [15:0]         factor_real, // Wnr
     input signed [15:0]         factor_imag,

     output                      valid,
     output signed [23:0]        yp_real, //Xm+1(p)
     output signed [23:0]        yp_imag,
     output signed [23:0]        yq_real, //Xm+1(q)
     output signed [23:0]        yq_imag);

    reg [4:0]                    en_r ;
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            en_r   <= 'b0 ;
        end
        else begin
            en_r   <= {en_r[3:0], en} ;
        end
    end

    //=====================================================//
    //(1.0) Xm(q) mutiply and Xm(p) delay
    reg signed [39:0] xq_wnr_real0;
    reg signed [39:0] xq_wnr_real1;
    reg signed [39:0] xq_wnr_imag0;
    reg signed [39:0] xq_wnr_imag1;
    reg signed [39:0] xp_real_d;
    reg signed [39:0] xp_imag_d;
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            xp_real_d    <= 'b0;
            xp_imag_d    <= 'b0;
            xq_wnr_real0 <= 'b0;
            xq_wnr_real1 <= 'b0;
            xq_wnr_imag0 <= 'b0;
            xq_wnr_imag1 <= 'b0;
        end
        else if (en) begin
            xq_wnr_real0 <= xq_real * factor_real;
            xq_wnr_real1 <= xq_imag * factor_imag;
            xq_wnr_imag0 <= xq_real * factor_imag;
            xq_wnr_imag1 <= xq_imag * factor_real;
            //expanding 8192 times as Wnr
            xp_real_d    <= {{4{xp_real[23]}}, xp_real[22:0], 13'b0};
            xp_imag_d    <= {{4{xp_imag[23]}}, xp_imag[22:0], 13'b0};
        end
    end

    //(1.1) get Xm(q) mutiplied-results and Xm(p) delay again
    reg signed [39:0] xp_real_d1;
    reg signed [39:0] xp_imag_d1;
    reg signed [39:0] xq_wnr_real;
    reg signed [39:0] xq_wnr_imag;
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            xp_real_d1     <= 'b0;
            xp_imag_d1     <= 'b0;
            xq_wnr_real    <= 'b0 ;
            xq_wnr_imag    <= 'b0 ;
        end
        else if (en_r[0]) begin
            xp_real_d1     <= xp_real_d;
            xp_imag_d1     <= xp_imag_d;
            //提前设置好位宽余量，防止数据溢出
            xq_wnr_real    <= xq_wnr_real0 - xq_wnr_real1 ;
            xq_wnr_imag    <= xq_wnr_imag0 + xq_wnr_imag1 ;
      end
    end

   //======================================================//
   //(2.0) butter results
    reg signed [39:0] yp_real_r;
    reg signed [39:0] yp_imag_r;
    reg signed [39:0] yq_real_r;
    reg signed [39:0] yq_imag_r;
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            yp_real_r      <= 'b0;
            yp_imag_r      <= 'b0;
            yq_real_r      <= 'b0;
            yq_imag_r      <= 'b0;
        end
        else if (en_r[1]) begin
            yp_real_r      <= xp_real_d1 + xq_wnr_real;
            yp_imag_r      <= xp_imag_d1 + xq_wnr_imag;
            yq_real_r      <= xp_real_d1 - xq_wnr_real;
            yq_imag_r      <= xp_imag_d1 - xq_wnr_imag;
        end
    end

    //(3) discard the low 13bits because of Wnr
    assign yp_real = {yp_real_r[39], yp_real_r[13+23:13]};
    assign yp_imag = {yp_imag_r[39], yp_imag_r[13+23:13]};
    assign yq_real = {yq_real_r[39], yq_real_r[13+23:13]};
    assign yq_imag = {yq_imag_r[39], yq_imag_r[13+23:13]};
    assign valid   = en_r[2];
endmodule
