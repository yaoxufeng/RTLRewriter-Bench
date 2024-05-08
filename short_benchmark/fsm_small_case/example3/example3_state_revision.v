module example (
    input wire clk,
    input wire reset,
    input wire x,
    output reg output_signal
);

    // State encoding
    localparam S0 = 3'b000,
               S1 = 3'b001,
               S2 = 3'b010,
               S3 = 3'b011,
               S4 = 3'b100,
               S5 = 3'b101,
               S6 = 3'b110;

    reg [2:0] state, next_state;

    // Sequential logic for state transitions
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S0;  // Reset to state S0
        end else begin
            state <= next_state;
        end
    end

    // Combinational logic for next state
    always @(*) begin
        case (state)
            S0: next_state = x ? S2 : S1;
            S1: next_state = x ? S5 : S3;
            S2: next_state = x ? S4 : S5;
            S3: next_state = x ? S6 : S1;
            S4: next_state = x ? S2 : S5;
            S5: next_state = x ? S3 : S4;
            S6: next_state = x ? S6 : S5;
            default: next_state = S0;  // Default state
        endcase
    end

    // Output logic
    always @(state) begin
        case(state)
            S0: output_signal = 1'b1;
            S1: output_signal = 1'b1;
            S2: output_signal = 1'b0;
            S3: output_signal = 1'b1;
            S4: output_signal = 1'b0;
            S5: output_signal = 1'b0;
            S6: output_signal = 1'b0;
            default: output_signal = 1'b0;
        endcase
    end
endmodule
