module example (
    input wire clk,
    input wire reset,
    input wire x,
    output reg output_signal
);

    // State encoding after optimization
    localparam S0 = 3'b000,
               S1 = 3'b001,
               S2_4 = 3'b010, // Merged state S2 and S4
               S3 = 3'b011,
               S5 = 3'b100,
               S6 = 3'b101;

    reg [2:0] next_state;
    reg [2:0] state;  // Updated state representation

    // Sequential logic for state transitions
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S0;  // Reset to state S0
        end else begin
            state <= next_state;
        end
    end

    // Combinational logic for next state and output
    always @(*) begin
        case (state)
            S0: begin
                next_state = x ? S2_4 : S1; // Updated state transition
                output_signal = 1'b1;
            end
            S1: begin
                next_state = x ? S5 : S3;
                output_signal = 1'b1;
            end
            S2_4: begin // Merged state handling
                next_state = x ? S2_4 : S5; // Both transitions from S2 and S4 are handled
                output_signal = 1'b0;
            end
            S3: begin
                next_state = x ? S6 : S1;
                output_signal = 1'b1;
            end
            S5: begin
                next_state = x ? S3 : S2_4; // Updated state transition
                output_signal = 1'b0;
            end
            S6: begin
                next_state = x ? S6 : S5;
                output_signal = 1'b0;
            end
            default: begin
                next_state = S0;  // Default to state S0 if an undefined state is encountered
                output_signal = 1'b0;
            end
        endcase
    end
endmodule
