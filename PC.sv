`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Module Name: program_counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//   32-bit program counter (PC) module for a pipelined processor.
//   Updates PC on the rising edge of the clock or resets it to 0.
//   PC can also be stalled using an enable signal.
//
// Dependencies: None
//
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

module program_counter(
    input  logic        clk,    // Clock signal
    input  logic        reset,  // Active-high synchronous reset
    input  logic        en,     // Enable signal (stall control)
    input  logic [31:0] PCNext, // Next PC value
    output logic [31:0] PC      // Current PC value
);

    // Sequential logic: update PC on clock edge or reset
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset PC to 0 on reset
            PC <= 32'h00000000;
        end
        else if (en) begin
            // Update PC if enable is high (no stall)
            PC <= PCNext;
        end
        // If enable is low (stall), PC retains its previous value
    end

endmodule
