// vending-machine
module vending_machine_raw (
    input wire clk,
    input wire reset,
    input wire condition,
    input wire sel,
    input wire [63:0] discountA,
    input wire [63:0] discountB,
    input wire [63:0] discountC,
    input wire [63:0] discountD,
    output reg sell_signal,
    output reg [63:0] total_discount
);

    // State encoding
    localparam S0 = 4'b0000,
               S1 = 4'b0001,
               S2 = 4'b0010,
               S3 = 4'b0011,
               S4 = 4'b0100,
               S5 = 4'b0101,
               S6 = 4'b0110,
               S7 = 4'b0111,
               S8 = 4'b1000,
               S9 = 4'b1001,
               S10 = 4'b1010;

    reg [3:0] next_state;
    reg [3:0] state;  // 3-bit state representation for S0 to S6

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
            total_discount = discountA + discountB;
        end else begin
            total_discount = discountC + discountD;
        end

        case (state)
            S0: begin
                next_state = condition ? S2 : S1;
                sell_signal = 1'b1;
            end
            S1: begin
                next_state = condition ? S5 : S3;
                sell_signal = 1'b1;
            end
            S2: begin
                next_state = condition ? S4 : S5;
                sell_signal = 1'b0;
            end
            S3: begin
                next_state = condition ? S6 : S1;
                sell_signal = 1'b1;
            end
            S4: begin
                next_state = condition ? S2 : S5;
                sell_signal = 1'b0;
            end
            S5: begin
                next_state = condition ? S3 : S4;
                sell_signal = 1'b0;
            end
            S6: begin
                next_state = condition ? S6 : S5;
                sell_signal = 1'b0;
            end
            S7: begin
                next_state = condition ? S4 : S9;
                sell_signal = 1'b0;
            end
            S8: begin
                next_state = condition ? S6 : S10;
                sell_signal = 1'b1;
            end
            S9: begin
                next_state = condition ? S0 : S2;
                sell_signal = 1'b0;
            end
            S10: begin
                next_state = condition ? S5 : S0;
                sell_signal = 1'b1;
            end
            default: begin
                next_state = S0;  // Default to state S0 if an undefined state is encountered
                sell_signal = 1'b0;
            end
        endcase
    end
endmodule


