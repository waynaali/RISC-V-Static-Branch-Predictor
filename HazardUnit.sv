`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Module Name: HazardUnit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//   Hazard detection unit for a pipelined RISC-V processor.
//   Detects load-use hazards and controls pipeline stalls and flushes.
//
// Dependencies: None
//
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

module HazardUnit(
    input  logic [4:0] Rs1D, Rs2D, // Source registers in ID stage
    input  logic [4:0] RdE,        // Destination register in EX stage
    input  logic       PCSrcE,      // Branch/jump taken in EX stage
    input  logic       ResultSrcE0, // Indicates a load instruction in EX stage
    output logic StallF, StallD,   // Stall signals for IF and ID stages
    output logic FlushE, FlushD    // Flush signals for EX and ID stages
);

    // -------------------------------
    // Load-use hazard detection
    // -------------------------------
    // lwStall is true if:
    // 1) Instruction in EX stage is a load (ResultSrcE0 = 1)
    // 2) Instruction in ID stage reads a register that EX stage will write
    // 3) Destination register is not x0
    logic lwStall;
    assign lwStall = ResultSrcE0 && ((Rs1D == RdE) || (Rs2D == RdE)) && (RdE != 0);

    // -------------------------------
    // Flush signals
    // -------------------------------
    // Flush EX stage if there's a load-use hazard or a branch/jump taken
    assign FlushE = lwStall | PCSrcE;

    // Flush ID stage only on branch/jump taken
    assign FlushD = PCSrcE;

    // -------------------------------
    // Stall signals
    // -------------------------------
    // Stall IF and ID stages if there's a load-use hazard
    assign StallF = lwStall;
    assign StallD = lwStall;

endmodule
