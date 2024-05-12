// vending-machine
module vending_machine(
                      clk,
                      reset,
                      condition,
                      sel,
                      discountA,
                      discountB,
                      discountC,
                      discountD,
                      total_discount,
                      sell_signal
                      );
    // State encoding
    localparam  S0 = 4'b0000,
               S1 = 4'b0001,
               S2 = 4'b0010,
               S5 = 4'b0011;

    parameter DATA_WIDTH = 64;
    parameter K = 16;

    input wire clk, reset, condition, sel;
    input wire [K*DATA_WIDTH-1:0] discountA, discountB, discountC, discountD;

    output reg sell_signal;
    output reg [K*DATA_WIDTH-1:0] total_discount;

    reg [3:0] next_state;
    reg [3:0] state;  // 3-bit state representation for S0 to S6
    reg [K*DATA_WIDTH-1:0] discount1, discount2;

    // Sequential logic for state transitions
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S0;  // Reset to state S0
        end else begin
            state <= next_state;
        end
    end

   always @(*) begin
        if (sel) begin
            discount1 = discountA;
            discount2 = discountB;
        end else begin
            discount1 = discountC;
            discount2 = discountD;
        end
        total_discount = discount1 + discount2;
    end

    // Combinatorial logic for next state and output
    always @(*) begin
        case (state)
            S0: begin
                next_state = condition ? S2 : S1;
                sell_signal = 1'b1;
                //total_discount = discountA + discountB;
            end
            S1: begin
                next_state = condition ? S5 : S0;
                sell_signal = 1'b1;
                //total_discount = discountA + discountB;
            end
            S2: begin
                next_state = condition ? S2 : S5;
                sell_signal = 1'b0;
                //total_discount = discountC + discountD;
            end
            S5: begin
                next_state = condition ? S0 : S2;
                sell_signal = 1'b0;
                //total_discount = discountC + discountD;
            end
            default: begin
                next_state = S0;  // Default to state S0 if an undefined state is encountered
                sell_signal = 1'b0;
                //total_discount = discountC + discountD;
            end
        endcase
    end
endmodule
