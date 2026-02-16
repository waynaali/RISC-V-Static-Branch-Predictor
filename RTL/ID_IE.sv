`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2025
// Module Name: ID_IE
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//   ID/EX pipeline register for a pipelined RISC-V processor.
//   Transfers all decoded signals and data from ID stage to EX stage.
//   Supports reset and flush (for hazards or branch misprediction).
//
// Dependencies: None
//
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

module ID_IE(
    input  logic        clk, reset, flush,      // Clock, reset, and flush
    input  logic [31:0] rd1D, rd2D,             // Register file outputs from ID stage
    input  logic [31:0] PCD,                    // PC from ID stage
    input  logic [4:0]  rs1D, rs2D, rdD,        // Register addresses from ID stage
    input  logic [31:0] ImmExtendD, PCPlus4D,   // Extended immediate and PC+4 from ID
    input  logic        RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD, // Control signals
    input  logic [1:0]  ResultSrcD,             // Control signal for WB mux
    input  logic [2:0]  ALUControlD,            // ALU operation control
    output logic [31:0] rd1E, rd2E,             // Outputs to EX stage
    output logic [31:0] PCE,                     // PC in EX stage
    output logic [4:0]  rs1E, rs2E, rdE,        // Register addresses in EX
    output logic [31:0] ImmExtendE, PCPlus4E,   // Immediate and PC+4 in EX
    output logic        RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE, 
    output logic [1:0]  ResultSrcE,             // WB mux control in EX
    output logic [2:0]  ALUControlE             // ALU control in EX
);

    // Sequential logic: latch all ID stage signals to EX stage
    always_ff @(posedge clk) begin
        if (reset) begin
            // On reset, clear all EX stage registers
            rd1E        <= 32'b0;
            rd2E        <= 32'b0; 
            PCE         <= 32'b0; 
            rs1E        <= 5'b0;
            rs2E        <= 5'b0;
            rdE         <= 5'b0; 
            ImmExtendE  <= 32'b0;
            PCPlus4E    <= 32'b0;
            RegWriteE   <= 1'b0;
            ResultSrcE  <= 2'b0;
            MemWriteE   <= 1'b0;
            JumpE       <= 1'b0; 
            BranchE     <= 1'b0;
            ALUSrcE     <= 1'b0;
            ALUControlE <= 3'b0;
        end
        else if (flush) begin
            // On flush (e.g., branch misprediction), insert a bubble in EX stage
            rd1E        <= rd1D;
            rd2E        <= rd2D; 
            PCE         <= PCD; 
            rs1E        <= rs1D;
            rs2E        <= rs2D;
            rdE         <= rdD; 
            ImmExtendE  <= ImmExtendD;
            PCPlus4E    <= PCPlus4D;
            RegWriteE   <= 1'b0;       // Disable register write
            ResultSrcE  <= 2'b0;       // Clear WB mux control
            MemWriteE   <= 1'b0;       // Disable memory write
            JumpE       <= 1'b0; 
            BranchE     <= 1'b0;
            ALUSrcE     <= 1'b0;
            ALUControlE <= 3'b0;
        end
        else begin
            // Normal operation: pass all ID stage signals to EX stage
            rd1E        <= rd1D;
            rd2E        <= rd2D; 
            PCE         <= PCD; 
            rs1E        <= rs1D;
            rs2E        <= rs2D;
            rdE         <= rdD; 
            ImmExtendE  <= ImmExtendD;
            PCPlus4E    <= PCPlus4D;
            RegWriteE   <= RegWriteD;
            ResultSrcE  <= ResultSrcD;
            MemWriteE   <= MemWriteD;
            JumpE       <= JumpD; 
            BranchE     <= BranchD;
            ALUSrcE     <= ALUSrcD;
            ALUControlE <= ALUControlD;
        end
    end

endmodule
