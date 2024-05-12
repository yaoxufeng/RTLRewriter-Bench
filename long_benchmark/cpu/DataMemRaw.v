// This implementation is less efficient than the original implementation for the following reasons:
// Combinational Logic in Synchronous Block: The always block includes combinational logic for reading data from the memory and updating the output registers (ReadData, leds, AN, and BCD). This violates the best practice of separating combinational and sequential logic, leading to potential issues with synthesis and timing analysis.
// Redundant Address Decoding: The address decoding logic for handling special addresses (0x40000003 and 0x40000100) is duplicated for both the MemRead and MemWrite cases. This redundancy increases the complexity of the logic and can lead to increased area and power consumption.
// Unnecessary Assignments: The ReadData register is assigned a value of 0 at the beginning of the always block, even though it is reassigned later based on the MemRead condition. This unnecessary assignment can lead to unnecessary switching activity and power consumption.
// Inefficient Memory Access: The memory access logic is implemented using nested if statements, which can lead to longer combinational logic paths and potential timing issues. A more efficient approach would be to use a case statement or continuous assignments.

module DataMem_raw(
    input wire clk,
    input wire reset,
    input wire [31:0] addr,
    input wire [31:0] WriteData,
    input wire MemRead,
    input wire MemWrite,
    output wire [31:0] ReadData,
    output reg [7:0] leds,
    output reg [3:0] AN,
    output reg [7:0] BCD
);

parameter MEM_SIZE = 512;
reg [31:0] data [MEM_SIZE - 1:0];
reg [31:0] InternalReadData;
integer i;
  
always @(posedge clk or posedge reset) begin
    if (reset) begin
        leds <= 0;
        AN <= 0;
        BCD <= 0;
        InternalReadData <= 0;

        for (i = 0; i < MEM_SIZE; i = i + 1) begin
            data[i] <= 0;
        end
    end
    else begin
        InternalReadData <= 0;
        if (MemRead) begin
            if (addr[31:2] < MEM_SIZE) begin
                InternalReadData <= data[addr[31:2]];
            end
            else if (addr == 32'h40000003) begin
                InternalReadData <= {24'h0, leds};
            end
            else if (addr == 32'h40000100) begin
                InternalReadData <= {20'h0, AN, BCD};
            end
        end

        if (MemWrite) begin
            if (addr[31:2] < MEM_SIZE) begin
                data[addr[31:2]] <= WriteData;
            end
            else if (addr == 32'h40000003) begin
                leds <= WriteData[7:0];
            end
            else if (addr == 32'h40000100) begin
                BCD <= WriteData[7:0];
                AN <= WriteData[11:8];
            end
        end
    end
end

assign ReadData = InternalReadData;
endmodule