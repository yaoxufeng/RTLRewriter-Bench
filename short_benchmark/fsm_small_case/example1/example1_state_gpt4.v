module example(
    input wire clk,
    input wire reset,
    input wire [1:0] input_signal, // 2-bit input to represent four possible inputs (0-3)
    output reg output_signal
);

    // Define state codes
    parameter S0 = 3'b000,
              S1 = 3'b001,
              S2 = 3'b010,
              S3 = 3'b011,
              S4 = 3'b100,
              S5 = 3'b101;

    // State register
    reg [2:0] current_state, next_state;

    // Output logic based on the current state
    always @(current_state) begin
        // Use a single assignment with default to 0
        output_signal = (current_state == S0 || current_state == S2 || current_state == S4) ? 1 : 0;
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
        next_state = current_state; // Default to staying in the same state

        // Simplified next state determination
        case (current_state)
            S0: next_state = (input_signal == 2'b01) ? S1 :
                             (input_signal == 2'b10) ? S2 :
                             (input_signal == 2'b11) ? S3 : S0;
            S1: next_state = (input_signal == 2'b00) ? S0 :
                             (input_signal == 2'b01) ? S3 :
                             (input_signal == 2'b11) ? S5 : S1;
            S2: next_state = (input_signal == 2'b00) ? S1 :
                             (input_signal == 2'b01) ? S3 :
                             (input_signal == 2'b11) ? S4 : S2;
            S3: next_state = (input_signal == 2'b00) ? S1 :
                             (input_signal == 2'b01) ? S0 :
                             (input_signal == 2'b10) ? S4 : S5;
            S4: next_state = (input_signal == 2'b00) ? S0 :
                             (input_signal == 2'b01) ? S1 :
                             (input_signal == 2'b10) ? S2 : S5;
            S5: next_state = (input_signal == 2'b00) ? S1 :
                             (input_signal == 2'b01) ? S4 :
                             (input_signal == 2'b10) ? S0 : S5;
        endcase
    end
endmodule
