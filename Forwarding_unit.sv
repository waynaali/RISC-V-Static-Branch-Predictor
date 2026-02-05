`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2025
// Module Name: forwarding_unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//   Forwarding unit for a pipelined RISC-V processor. 
//   Resolves data hazards by forwarding results from later pipeline stages 
//   (MEM or WB) back to the EX stage inputs to avoid stalls.
//
// Dependencies: None
//
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

module forwarding_unit(
    input logic [4:0] Rs1E, Rs2E,   // Source registers in EX stage
    input logic [4:0] RdM, RdW,     // Destination registers in MEM and WB stages
    input logic RegWriteM, RegWriteW, // Register write enables for MEM and WB stages
    output logic [1:0] ForwardAE, ForwardBE // Forwarding control signals for EX stage ALU inputs
);

    // Combinational logic for forwarding
    always_comb begin
        // -------------------------------
        // Forwarding for ALU input A (from Rs1E)
        // -------------------------------
        if ((Rs1E == RdM) && RegWriteM && (Rs1E != 0)) begin
            // Forward data from MEM stage to EX stage
            ForwardAE = 2'b10;
        end else if ((Rs1E == RdW) && RegWriteW && (Rs1E != 0)) begin
            // Forward data from WB stage to EX stage
            ForwardAE = 2'b01;
        end else begin
            // No forwarding needed, use data from register file
            ForwardAE = 2'b00;
        end

        // -------------------------------
        // Forwarding for ALU input B (from Rs2E)
        // -------------------------------
        if ((Rs2E == RdM) && RegWriteM && (Rs2E != 0)) begin
            // Forward data from MEM stage to EX stage
            ForwardBE = 2'b10;
        end else if ((Rs2E == RdW) && RegWriteW && (Rs2E != 0)) begin
            // Forward data from WB stage to EX stage
            ForwardBE = 2'b01;
        end else begin
            // No forwarding needed, use data from register file
            ForwardBE = 2'b00;
        end
    end

endmodule

