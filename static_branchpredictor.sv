`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/31/2026 10:29:14 AM
// Design Name: 
// Module Name: static_branchpredictor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module static_branch_predictor(
    input  logic [31:0] current_pc,
    input  logic [31:0] target_pc,             // Calculated branch target address
    input  logic  branch_instruction,    // 1 if instruction is branch
    output logic  branch_taken
    );

    // Predict backward branches as taken, forward branches as not taken
    assign branch_taken = branch_instruction && (target_pc < current_pc);
endmodule
