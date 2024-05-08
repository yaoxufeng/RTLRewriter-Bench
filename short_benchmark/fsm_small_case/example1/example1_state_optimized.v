module example (
    input wire clk,
    input wire reset,
    input wire [1:0] input_signal,  // 2-bit input for 4 different inputs (0-3)
    output reg output_signal
);

    // Define state codes
    parameter S0 = 2'b00,
              S1 = 2'b01,
              S2 = 2'b10,
              S3 = 2'b11;

    // Define states as a reg type for sequential logic
    reg [1:0] current_state, next_state;

    // Sequential logic for state transitions
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= S0;  // Start at S0 on reset
        end else begin
            current_state <= next_state;
        end
    end

    // Combinational logic for next state and output signal
    always @(*) begin
        // Defaults for next state and output
        next_state = current_state;
        output_signal = 1'b0;

        case (current_state)
            S0: begin
                case (input_signal)
                    2'b00: begin next_state = S0; output_signal = 1'b1; end
                    2'b01: begin next_state = S1; output_signal = 1'b1; end
                    2'b10: begin next_state = S2; output_signal = 1'b1; end
                    2'b11: begin next_state = S3; output_signal = 1'b1; end
                endcase
            end
            S1: begin
                case (input_signal)
                    2'b00: next_state = S0;
                    // For input 2'b01 and 2'b11, next_state remains S3, as shown in the table.
                    2'b01: next_state = S3;
                    //2'b10: next_state = S1;
                    2'b11: next_state = S3;
                endcase
            end
            S2: begin
                case (input_signal)
                    2'b00: begin next_state = S1; output_signal = 1'b1; end
                    2'b01: begin next_state = S3; output_signal = 1'b1; end
                    2'b10: begin next_state = S2; output_signal = 1'b1; end
                    2'b11: begin next_state = S0; output_signal = 1'b1; end
                endcase
            end
            S3: begin
                case (input_signal)
                    2'b00: next_state = S1;
                    2'b01: next_state = S0;
                    2'b10: next_state = S0;
                    2'b11: next_state = S3;
                endcase
            end
            default: begin
                next_state = S0;
                output_signal = 1'b0;
            end
        endcase
    end
endmodule
