`define N 494
`define L 10
`define NNZ 1666

module ellpack(
  input [`N*`L-1:0] nzval,
  input [31:0] cols,
  input [`N-1:0] vec,
  output [`N-1:0] out
);

  integer i, j;
  reg [`N-1:0] sum;
  reg [`N-1:0] Si;

  always @(nzval, cols, vec) begin
    for(i=0; i<`N; i=i+1) begin
      sum[i] = out[i];
        for(j=0; j<`L; j=j+1) begin
          Si = nzval[j + i*`L] * vec[cols[j + i*`L]];
          sum[i] = sum[i] + Si;
        end
       out[i] = sum[i];
     end
  end

endmodule