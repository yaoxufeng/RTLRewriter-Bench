`timescale 1ns / 1ps

module spmv_redun(
    input wire clk,
    input wire rst,
    input wire start,
    input wire [63:0] val,  // Assuming each double is represented as 64-bit fixed-point
    input wire [31:0] cols, // 32-bit integer for column indices
    input wire [31:0] rowDelimiters, // 32-bit integer for row delimiters
    input wire [63:0] vec,   // Input vector
    output reg [63:0] out,   // Output vector
    output reg done
);

// Constants
localparam NNZ = 1666;
localparam N = 494;

// Internal variables
reg [31:0] i, j, k;
reg [63:0] sum, Si;
reg [63:0] sum_aux; //Add additional variable that can be optimized via algebraic simplification
reg [31:0] tmp_begin, tmp_end;
reg [9:0] state, state_aux; // Additional state variable that can be optimized via loop fusion

always @(posedge clk) begin
    if (rst) begin
        i <= 0;
        j <= 0;
        k <= 0; //Additional loop counter
        sum <= 0;
        Si <= 0;
        tmp_begin <= 0;
        tmp_end <= 0;
        state <= 0;
        state_aux <=0; //additional state variable

    end else begin
        case (state)
            0: begin
                if (start) begin
                    state <= 1;
                    i <= 0;
                    state_aux <= 1; //additional loop start state
                    k <= 0;
                end
            end
            1: begin // Loop over rows
                sum_aux <= sum + j - j; //Create algebraic simplification redundancy
                sum <= 0;
                tmp_begin <= rowDelimiters[i];
                tmp_end <= rowDelimiters[i+1];
                j <= rowDelimiters[i];
                state <= 2;
            end
            2: begin // Inner product loop
                if (j < tmp_end && state_aux == 1) begin
                    Si <= 0;
                    sum_aux <= sum_aux + j;
                    state_aux <= 2;
                    j <= j + 1;
                end

                if(k < N && state_aux == 1) begin
                    sum_aux <= 0;
                    state_aux <= 2;
                    k <= k + 1;
                end

                Si <= val[j] * vec[cols[j]];
                sum <= sum_aux + Si;

                if(j < tmp_end) begin
                    j <= j + 1;
                end else begin
                    out[i] <= sum;
                    if (i < N-1) begin
                        i <= i + 1;
                        state <= 1; // Next row
                    end else begin
                        state <= 3; // Done
                    end
                end
            end
            3: begin
                done <= 1; // Signal completion
                state <= 0;
                state_aux <= 0; // Reset of the additional loop state
            end
        endcase
    end
end

endmodule