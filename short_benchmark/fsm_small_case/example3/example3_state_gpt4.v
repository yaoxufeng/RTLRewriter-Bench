module example (
    input wire clk,
    input wire reset,
    input wire x,
    output reg output_signal
);

    // State encoding using localparam for better readability and maintainability
    localparam S0 = 3'b000,
               S1 = 3'b001,
               S2 = 3'b010,
               S3 = 3'b011,
               S4 = 3'b100,
               S5 = 3'b101,
               S6 = 3'b110;

    reg [2:0] state;  // Current state

    // State transition and output logic combined in a single always block for clarity
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S0;  // Reset to state S0
            output_signal <= 1'b1;  // Default output signal during reset
        end else begin
            // Decision making based on current state and input x
            case (state)
                S0: begin
                    state <= x ? S2 : S1;
                    output_signal <= 1'b1;
                end
                S1: begin
                    state <= x ? S5 : S3;
                    output_signal <= 1'b1;
                end
                S2: begin
                    state <= x ? S4 : S5;
                    output_signal <= 1'b0;
                end
                S3: begin
                    state <= x ? S6 : S1;
                    output_signal <= 1'b1;
                end
                S4: begin
                    state <= x ? S2 : S5;
                    output_signal <= 1'b0;
                end
                S5: begin
                    state <= x ? S3 : S4;
                    output_signal <= 1'b0;
                end
                S6: begin
                    state <= x ? S6 : S5;
                    output_signal <= 1'b0;
                end
                default: begin
                    state <= S0;  // Fallback to S0 on undefined states
                    output_signal <= 1'b0;
                end
            endcase
        end
    end

endmodule
