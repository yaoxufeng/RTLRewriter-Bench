module fsm (
    input wire clk,
    input wire reset,
    input wire x,
    output reg Z
);

    // State encoding
    localparam [3:0] AC = 4'b0001,
                     BD = 4'b0011,
                     E  = 4'b0010,
                     F  = 4'b0110;

    reg [3:0] next_state, state;

    // Sequential logic for state transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= AC; // Assuming AC is the initial state
        end else begin
            state <= next_state;
        end
    end

    // Combinational logic for next state and output
    always @(*) begin
        case (state)
            AC: if (x == 1) begin
                    next_state = BD; Z = 1;
                end else begin
                    next_state = E; Z = 0;
                end
            BD: if (x == 1) begin
                    next_state = BD; Z = 0;
                end else begin
                    next_state = F; Z = 0;
                end
            E: if (x == 1) begin
                    next_state = F; Z = 1;
                end else begin
                    next_state = AC; Z = 0;
                end
            F: if (x == 1) begin
                    next_state = AC; Z = 0;
                end else begin
                    next_state = BD; Z = 0;
                end
            default: begin
                next_state = AC; // Default to state AC if an undefined state is encountered
                Z = 0;
            end
        endcase
    end
endmodule