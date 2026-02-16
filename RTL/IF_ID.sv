`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2025
// Module Name: IF_ID
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//   Instruction Fetch / Instruction Decode (IF/ID) pipeline register.
//   Holds instruction and PC values from IF stage and passes them to ID stage.
//   Supports pipeline stall (enable) and flush (for branch misprediction or hazards).
//
// Dependencies: None
//
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

module IF_ID(
    input  logic        clk,    // Clock signal
    input  logic        reset,  // Active-high synchronous reset
    input  logic        en,     // Enable signal for stalling
    input  logic        flush,  // Flush signal for branch misprediction
    input  logic [31:0] InstrF,    // Instruction from IF stage
    input  logic [31:0] PCF,       // PC value from IF stage
    input  logic [31:0] PCPlus4F,  // PC+4 value from IF stage
    output logic [31:0] InstrD,    // Instruction passed to ID stage
    output logic [31:0] PCD,       // PC passed to ID stage
    output logic [31:0] PCPlus4D   // PC+4 passed to ID stage
);

    // Sequential logic: capture IF stage outputs on clock edge
    always_ff @(posedge clk) begin
        if (reset | flush) begin
            // On reset or flush, clear the pipeline register
            InstrD    <= 32'b0;
            PCD       <= 32'b0;
            PCPlus4D  <= 32'b0;
        end
        else if (en) begin
            // If enabled (no stall), capture IF stage outputs
            InstrD    <= InstrF;
            PCD       <= PCF;
            PCPlus4D  <= PCPlus4F;
        end
        // If enable is low (stall), hold the current values
    end

endmodule

