`timescale 1ns / 1ps

module viterbi(
    input clk,
    input reset,
    input start,
    input [7:0] obs,  // Observation input as a stream
    output reg [7:0] path,  // Path output as a stream
    output reg done
);

// Constants
parameter N_STATES = 64;
parameter N_OBS = 140;
parameter N_TOKENS = 64;

// Data types in HLS translated to Verilog
reg [63:0] init[N_STATES-1:0];
reg [63:0] transition[N_STATES*N_STATES-1:0];
reg [63:0] emission[N_STATES*N_TOKENS-1:0];

// Internal variables for algorithm
reg [63:0] llike[N_OBS-1:0][N_STATES-1:0];
integer t, prev, curr, s;
reg [63:0] min_p, p;
reg [7:0] min_s;

// Control FSM states
localparam IDLE = 0, INIT = 1, TIMESTEP = 2, END = 3, BACKTRACK = 4;
reg [2:0] state = IDLE;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        done <= 0;
    end else begin
        case (state)
        IDLE: begin
            if (start) state <= INIT;
        end
        INIT: begin
            // Initialize with first observation and initial probabilities
            for (s = 0; s < N_STATES; s = s + 1) begin
                llike[0][s] <= init[s] + emission[s * N_TOKENS + obs];
            end
            state <= TIMESTEP;
        end
        TIMESTEP: begin
            // Iteratively compute the probabilities over time
            for (t = 1; t < N_OBS; t = t + 1) begin
                for (curr = 0; curr < N_STATES; curr = curr + 1) begin
                    prev = 0;
                    min_p = llike[t-1][prev] + transition[prev*N_STATES+curr] + emission[curr*N_TOKENS+obs];
                    for (prev = 1; prev < N_STATES; prev = prev + 1) begin
                        p = llike[t-1][prev] + transition[prev*N_STATES+curr] + emission[curr*N_TOKENS+obs];
                        if (p < min_p) begin
                            min_p = p;
                        end
                    end
                    llike[t][curr] <= min_p;
                end
            end
            state <= END;
        end
        END: begin
            // Identify end state
            min_s = 0;
            min_p = llike[N_OBS-1][min_s];
            for (s = 1; s < N_STATES; s = s + 1) begin
                p = llike[N_OBS-1][s];
                if (p < min_p) begin
                    min_p = p;
                    min_s = s;
                end
            end
            path[N_OBS-1] <= min_s;
            state <= BACKTRACK;
        end
        BACKTRACK: begin
            // Backtrack to recover full path
            for (t = N_OBS-2; t >= 0; t = t - 1) begin
                min_s = 0;
                min_p = llike[t][min_s] + transition[min_s*N_STATES+path[t+1]];
                for (s = 1; s < N_STATES; s = s + 1) begin
                    p = llike[t][s] + transition[s*N_STATES+path[t+1]];
                    if (p < min_p) begin
                        min_p = p;
                        min_s = s;
                    end
                end
                path[t] <= min_s;
            end
            done <= 1;
            state <= IDLE;
        end
        endcase
    end
end

endmodule