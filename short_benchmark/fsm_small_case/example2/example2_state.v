module fsm_raw (
    input wire clk,
    input wire reset,
    input wire x,
    output reg Z
);

    // State encoding
    localparam A = 3'b000,
               B = 3'b001,
               C = 3'b010,
               D = 3'b011,
               E = 3'b100,
               F = 3'b101;

    reg [2:0] next_state, state;

    // Sequential logic for state transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= A;  // Assuming A is the initial state
        end else begin
            state <= next_state;
        end
    end

    // Combinational logic for next state and output
    always @(*) begin
        case (state)
            A: if (x == 1) begin
                   next_state = D; Z = 1;
               end else begin
                   next_state = E; Z = 0;
               end
            B: if (x == 1) begin
                   next_state = D; Z = 0;
               end else begin
                   next_state = F; Z = 0;
               end
            C: if (x == 1) begin
                   next_state = B; Z = 1;
               end else begin
                   next_state = E; Z = 0;
               end
            D: if (x == 1) begin
                   next_state = B; Z = 0;
               end else begin
                   next_state = F; Z = 0;
               end
            E: if (x == 1) begin
                   next_state = F; Z = 1;
               end else begin
                   next_state = C; Z = 0;
               end
            F: if (x == 1) begin
                   next_state = C; Z = 0;
               end else begin
                   next_state = B; Z = 0;
               end
            default: begin
                next_state = A;
                Z = 0;
            end
        endcase
    end
endmodule