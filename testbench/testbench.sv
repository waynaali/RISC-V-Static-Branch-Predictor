`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2025 04:04:23 PM
// Design Name: 
// Module Name: testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//   This is a simple testbench for the 'top' module of a RISC-V processor design.
//   It generates a clock, applies reset, and runs the simulation for a fixed time.
//
// Dependencies: 
//   Requires the 'top' module to be defined elsewhere in the project.
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//   Clock period is 10 ns (5 ns high, 5 ns low)
//   Simulation finishes after 2000 ns
//
//////////////////////////////////////////////////////////////////////////////////

module tb_risc;
    // Testbench signals
    logic clk;    // Clock signal for the processor
    logic reset;  // Reset signal for the processor

    // Instantiate the top module (RISC-V processor)
    top top(
        .clk(clk), 
        .reset(reset)
    );

    // Clock generation: 10 ns period (100 MHz)
    always #5 clk = ~clk; // Toggle clock every 5 ns

    // Initial block to control reset and simulation duration
    initial begin
        reset = 1;  // Apply reset at start
        clk = 0;    // Initialize clock to 0

        #20 reset = 0; // Deassert reset after 20 ns (2 clock cycles)

        #2000 $finish;  // End simulation after 2000 ns
    end

endmodule
