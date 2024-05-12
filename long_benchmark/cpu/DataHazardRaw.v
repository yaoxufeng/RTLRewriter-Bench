// This implementation is less efficient than the original implementation because:
// It uses a procedural block instead of continuous assignments, which can be less efficient in terms of hardware resources and timing.
// The nested if statements can lead to longer combinational logic paths, potentially impacting timing and area.
// The use of blocking assignments (=) inside the always block can lead to potential race conditions and unintended behavior if the inputs change during the evaluation of the block.
// Use more bits than needed

module DataHazard_raw(
    input wire ID_EX_RegWrite,
    input wire [4:0] ID_EX_WriteAddr,
    input wire EX_MEM_RegWrite,
    input wire [4:0] EX_MEM_WriteAddr,
    input wire [4:0] rs,
    input wire [4:0] rt,
    input wire ID_EX_MemRead,
    output wire [1:0] ForwardA,
    output wire [1:0] ForwardB,
    output wire LW_Stall
);

reg [8:0] InternalForwardA, InternalForwardB, InternalLW_Stall;
always @(*) begin
    // Default values
    InternalForwardA = 8'b00000000;
    InternalForwardB = 8'b00000000;
    InternalLW_Stall = 8'b00000000;

    // Check for forwarding and stalling conditions
    if (ID_EX_RegWrite && ID_EX_WriteAddr != 0) begin
        if (ID_EX_WriteAddr == rs)
            InternalForwardA = 8'b00000001;
        if (ID_EX_WriteAddr == rt)
            InternalForwardB = 8'b00000001;
    end
    else begin
        if (EX_MEM_RegWrite && EX_MEM_WriteAddr != 0) begin
            if (EX_MEM_WriteAddr == rs)
                InternalForwardA = 8'b00000010;
            if (EX_MEM_WriteAddr == rt)
                InternalForwardB = 8'b00000010;
        end
    end

    if (ID_EX_MemRead && (ID_EX_WriteAddr != 0) && (ID_EX_WriteAddr == rs || ID_EX_WriteAddr == rt))
        InternalLW_Stall = 1'b1;
    else
        InternalLW_Stall = 1'b0;
end


  assign ForwardA = InternalForwardA[1:0];
  assign ForwardB = InternalForwardB[1:0];
  assign LW_Stall = InternalLW_Stall[0];

endmodule