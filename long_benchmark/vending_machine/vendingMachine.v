// vending-machine
module vending_machine(
    input wire clk,
    input wire reset,
    input wire condition,
    input wire sel,
    input wire [63:0] discountA,
    input wire [63:0] discountB,
    input wire [63:0] discountC,
    input wire [63:0] discountD,
    output reg output_signal,
    output reg [63:0] total_discount
);

    // State encoding
    localparam S0 = 4'b0000,
               S1 = 4'b0001,
               S2 = 4'b0010,
               S5 = 4'b0101;

    reg [3:0] next_state;
    reg [3:0] state;  // 3-bit state representation for S0 to S6
    reg [63:0] discount1, discount2;

    // Sequential logic for state transitions
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S0;  // Reset to state S0
        end else begin
            state <= next_state;
        end
    end

    // Combinatorial logic for next state and output
    always @(*) begin
    	// selective sum issue
    	if (sel) begin
            discount1 = discountA;
            discount2 = discountB;
        end else begin
            discount1 = discountC;
            discount2 = discountD;
        end
        total_discount = discount1 + discount2;

        case (state)
            S0: begin
                next_state = condition ? S2 : S1;
                output_signal = 1'b1;
            end
            S1: begin
                next_state = condition ? S5 : S0;
                output_signal = 1'b1;
            end
            S2: begin
                next_state = condition ? S2 : S5;
                output_signal = 1'b0;
            end
            S5: begin
                next_state = condition ? S0 : S2;
                output_signal = 1'b0;
            end
            default: begin
                next_state = S0;  // Default to state S0 if an undefined state is encountered
                output_signal = 1'b0;
            end
        endcase
    end
endmodule
