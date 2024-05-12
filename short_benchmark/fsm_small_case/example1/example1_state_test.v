module example(
    input wire clk,
    input wire reset,
    input wire [1:0] input_signal,
    output reg output_signal
);

    // Define state codes
    parameter S0 = 3'b000,
              S1 = 3'b001,
              S2 = 3'b010,
              S3 = 3'b011;  // Combined state of original S3 and S5

    // State register
    reg [2:0] current_state, next_state;

    // Output logic based on the current state
    always @(current_state) begin
        case (current_state)
            S0: output_signal = 1;
            S2: output_signal = 1;
            default: output_signal = 0;
        endcase
    end

    // Sequential logic for state transitions
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= S0; // Reset to state S0
        end else begin
            current_state <= next_state;
        end
    end

    // Combinational logic for next state
    always @(*) begin
        next_state = current_state;  // Default to staying in the same state
        case (current_state)
            S0: case (input_signal)
                2'b00: next_state = S0;
                2'b01: next_state = S1;
                2'b10: next_state = S2;
                2'b11: next_state = S3;  // Combined S3 and S5
            endcase
            S1: case (input_signal)
                2'b00: next_state = S0;
                2'b01: next_state = S3;
                2'b11: next_state = S3;
            endcase
            S2: case (input_signal)
                2'b00: next_state = S1;
                2'b01: next_state = S3;
                2'b10: next_state = S2;
                2'b11: next_state = S0;
            endcase
            S3: case(input_signal)
                2'b00: next_state = S1;
                2'b01: next_state = S0;
                2'b10: next_state = S0;
                2'b11: next_state = S3;
            endcase
        endcase
    end
endmodule