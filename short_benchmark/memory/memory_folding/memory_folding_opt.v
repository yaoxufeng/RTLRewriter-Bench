module memory_folding_opt(
    input clk,
    input rst,
    input start_process,
    input [7:0] data_in,
    input write_enable,
    output reg [7:0] data_out,
    output reg busy
);

    // Define a single memory block that will be used for both inputs and outputs.
    reg [7:0] mem[15:0];  // Small memory block for demonstration
    integer i;

    // State machine for processing
    reg [1:0] state;  // State definitions: 0 - Idle, 1 - Processing, 2 - Storing Results

    always @(posedge clk) begin
        if (rst) begin
            state <= 0;
            busy <= 0;
            data_out <= 0;
        end
        else begin
            case(state)
                0: begin  // Idle state
                    if (start_process && write_enable) begin
                        for (i = 0; i < 16; i = i + 1) begin
                            mem[i] <= data_in;  // Initialize memory with input data
                        end
                        state <= 1;
                        busy <= 1;
                    end
                end

                1: begin  // Processing state
                    for (i = 0; i < 16; i = i + 1) begin
                        mem[i] <= mem[i] + 1;  // Simple processing: increment each element
                    end
                    state <= 2;
                end

                2: begin  // Storing results
                    for (i = 0; i < 16; i = i + 1) begin
                        data_out <= mem[i];  // Output the results sequentially
                    end
                    state <= 0;
                    busy <= 0;
                end
            endcase
        end
    end

endmodule