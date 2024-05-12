module MergeSort(
    input clk,
    input rst,
    input start_sort,
    output reg done_sort,
    input [1023:0] data_in,
    output reg [1023:0] data_out
);

parameter SIZE = 2048;
reg [31:0] a[0:SIZE-1];
reg [31:0] a_backup[0:SIZE-1];  // Redundant backup array
reg [31:0] temp[0:SIZE-1];
integer i, j, k, m, from, mid, to;
integer start, stop;

reg [2:0] state;
localparam IDLE = 0, PRE_SORT = 1, SORT = 2, POST_SORT = 3, MERGE = 4, DONE = 5;

always @(posedge clk) begin
    if (rst) begin
        state <= IDLE;
        done_sort <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (start_sort) begin
                    for (i = 0; i < SIZE; i++) begin
                        a[i] <= data_in[i];
                        a_backup[i] <= data_in[i];  // Redundant copying
                    end
                    start <= 0;
                    stop <= SIZE;
                    m <= 1;
                    state <= PRE_SORT;
                end
            end
            PRE_SORT: begin
                state <= SORT;  // Additional redundant state
            end
            SORT: begin
                if (m < stop - start) begin
                    state <= MERGE;
                    i <= start;
                end else begin
                    state <= POST_SORT;
                end
            end
            POST_SORT: begin
                state <= DONE;  // Additional redundant state
            end
            MERGE: begin
                state <= SORT;
            end
            DONE: begin
                for (i = 0; i < SIZE; i++) begin
                    data_out[i] <= a[i];
                end
                done_sort <= 1;
                state <= IDLE;
            end
        endcase
    end
end

endmodule
