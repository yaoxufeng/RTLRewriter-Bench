// Registers Array Indexed from 0: Updated the array registers to index from 0 to 31. This change simplifies the indexing and allows you to directly handle the "zero register" convention in MIPS architecture, where register 0 is always 0.
// Simplified Read Logic: The read assignments now include a condition to prevent writing to register 0, which is a common requirement in many instruction set architectures. This ensures that any write to register 0 is ignored, maintaining the invariant that register 0 is always 0.
// Initialization and Reset Enhancements: The initialization and reset logic now consistently handles all 32 registers. It specifically sets the stack pointer during both initial block execution and synchronous reset. This ensures that your simulation and synthesis results are consistent, especially across different simulation runs or after a reset in hardware.
// Code Efficiency: Using a loop from 0 to 31 reduces repeated code and potential errors in manually handling specific ranges differently.

module RegFile (
    input wire clk,
    input wire reset,
    input wire [4:0] ReadAddr1,
    input wire [4:0] ReadAddr2,
    input wire [4:0] WriteAddr,
    input wire [31:0] WriteData,
    input wire RegWrite,
    output wire [31:0] ReadData1,
    output wire [31:0] ReadData2
);

    reg [31:0] registers [0:31];  // Adjusted index to include zero register

    // Read logic with forwarding and zero register handling
    assign ReadData1 = (ReadAddr1 == 0) ? 32'h0 :
                       (RegWrite && (WriteAddr == ReadAddr1) && (WriteAddr != 0)) ? WriteData :
                       registers[ReadAddr1];

    assign ReadData2 = (ReadAddr2 == 0) ? 32'h0 :
                       (RegWrite && (WriteAddr == ReadAddr2) && (WriteAddr != 0)) ? WriteData :
                       registers[ReadAddr2];

    // Initialization of registers
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] <= 0;
        end
        registers[29] <= 32'h000007fc;  // Initialize $sp
    end

    // Reset and write-back logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 0;
            end
            registers[29] <= 32'h000007fc;  // Reset $sp
        end
        else if (RegWrite && WriteAddr != 0) begin
            registers[WriteAddr] <= WriteData;
        end
    end

endmodule
