module fsm(
    input wire clk,
    input wire reset,
    input wire [1:0] input_signal, // 2-bit input to represent four possible inputs (0-3)
    output reg output_signal,
    output reg [1:0] state // 2-bit state code for four states (A, S1, S2, B)
);

    // Define state codes
    parameter A  = 2'b00, // Merged S0 and S4
              S1 = 2'b01,
              S2 = 2'b10,
              B  = 2'b11; // Merged S3 and S5

    // State register
    reg [1:0] current_state, next_state;

    // Output logic based on the current state
    always @(current_state) begin
        // By default, set output to 0
        output_signal = 0;

        // Update the output signal based on the current state
        case (current_state)
            A:  output_signal = 1; // S0 and S4 had output 1
            S2: output_signal = 1;
            default: output_signal = 0; // S1 and B (S3, S5) had output 0
        endcase
    end

    // Sequential logic for state transitions
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= A; // Reset to state A
        end else begin
            current_state <= next_state;
        end
    end

    // Combinational logic for next state
    always @(*) begin
        // Default to staying in the same state
        next_state = current_state;

        // Determine the next state based on the current state and input
        case (current_state)
            A: case (input_signal)
                2'b00: next_state = A;
                2'b01: next_state = S1;
                2'b10: next_state = S2;
                2'b11: next_state = B;
            endcase
            S1: case (input_signal)
                2'b00: next_state = A;
                2'b01: next_state = B;
                2'b11: next_state = B;
            endcase
            S2: case (input_signal)
                2'b00: next_state = S1;
                2'b01: next_state = B;
                2'b10: next_state = S2;
                2'b11: next_state = A;
            endcase
            B: case (input_signal)
                2'b00: next_state = S1;
                2'b01: next_state = A;
                2'b10: next_state = A;
                2'b11: next_state = B;
            endcase
        endcase
    end
endmodule