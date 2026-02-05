`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2025
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//   Top-level module of a pipelined RISC-V processor with hazard detection, 
//   forwarding, and branch prediction. Implements standard 5-stage pipeline: 
//   IF -> ID -> EX -> MEM -> WB.
// 
// Dependencies: 
//   All pipeline stage modules, ALU, register file, memory units, and hazard units
//
//////////////////////////////////////////////////////////////////////////////////

module top(input logic clk, reset);

    // Pipeline control signals
    logic ZeroE;          // ALU zero flag for branch decision
    logic StallF, StallD; // Stall signals for IF and ID stages
    logic PCSrcE;         // Select PC source (branch/jump)
    logic branch_taken;   // Output from branch predictor
    logic RegWriteM, RegWriteE, RegWriteD, RegWriteW; // Write enable for registers
    logic MemWriteM, MemWriteE, MemWriteD;            // Memory write enable
    logic FlushE, FlushD; // Flush signals for EX and ID stages

    // Forwarding signals
    logic [1:0] ForwardAE, ForwardBE; 

    // Multiplexer control signals
    logic [1:0] ResultSrcD, ResultSrcE, ResultSrcM, ResultSrcW; 

    // Jump and branch signals
    logic JumpD, BranchD, JumpE, BranchE;

    // ALU control signals
    logic ALUSrcE, ALUSrcD;       
    logic [2:0] ALUControlD, ALUControlE; 
    logic [1:0] ImmSrcD;          // Immediate type for ID stage

    // Data signals
    logic [31:0] SrcAE, SrcBE, SrcB;           // ALU input signals
    logic [31:0] ALUResultE, ALUResultM, ALUResultW; 
    logic [31:0] ReadDataM, ReadDataW;        // Memory read data
    logic [31:0] PCTargetE, PCNext;           // PC calculation
    logic [31:0] ResultW;                     // Write-back result
    logic [31:0] RD1D, RD2D;                  // Register file outputs
    logic [31:0] RD1E, RD2E, RD2M;            // EX and MEM stage data
    logic [31:0] InstrF, InstrD;              // Instruction fetch/decode
    logic [31:0] PCE, PCD, PCF;               // Pipeline PC registers
    logic [31:0] PCPlus4F, PCPlus4D, PCPlus4E, PCPlus4M, PCPlus4W; 
    logic [31:0] ImmExtendD, ImmExtendE;      // Extended immediate values

    // Register addresses
    logic [4:0] rs1E, rs2E, rdE, rdM, rdW;    

    // Determine PC source for branching/jumping
    assign PCSrcE = (BranchE & ZeroE) | JumpE;

    // Forwarding unit: resolves data hazards
    forwarding_unit forwarding_unit(
        .Rs2E(rs2E),
        .Rs1E(rs1E),
        .RdM(rdM),
        .RdW(rdW),
        .RegWriteM(RegWriteM), 
        .RegWriteW(RegWriteW),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE)
    );

    // PC + 4 adder
    Adder PC_Plus_4(.A(PCF), .B(32'd4), .Sum(PCPlus4F));

    // Branch target calculation
    Adder PC_Target(.A(PCE), .B(ImmExtendE), .Sum(PCTargetE));

    // Static branch predictor
    static_branch_predictor sbp(
        .current_pc(PCF),
        .target_pc(PCD + ImmExtendD),
        .branch_instruction(BranchD),
        .branch_taken(branch_taken)
    );

    // Select next PC: sequential or branch/jump target
    mux2 PC_Next(.d0(PCPlus4F), .d1(PCTargetE), .s(PCSrcE), .y(PCNext));

    // Program counter register
    program_counter ProgramCounter(
        .clk(clk),
        .reset(reset),
        .en(~StallF), 
        .PCNext(PCNext),
        .PC(PCF)
    );

    // Instruction memory
    instr_mem instruction_memory(
        .A(PCF),
        .RD(InstrF)
    );

    // IF/ID pipeline register
    IF_ID IF_ID(
        .clk(clk),
        .reset(reset),
        .flush(FlushD),
        .en(~StallD),
        .InstrF(InstrF),
        .PCF(PCF),
        .PCPlus4F(PCPlus4F),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D)
    );

    // Register file
    register_file register_file(
        .clk(clk),
        .A1(InstrD[19:15]),
        .A2(InstrD[24:20]),
        .A3(rdW),
        .wd3(ResultW),
        .we(RegWriteW),
        .rd1(RD1D),
        .rd2(RD2D)
    );

    // Immediate extension unit
    ExtendUnit Extend(
        .Instr(InstrD),
        .ImmSrc(ImmSrcD),
        .ImmExtend(ImmExtendD)
    );

    // Control unit: generates control signals based on opcode/funct
    control_unit control_unit(
        .op(InstrD[6:0]),
        .funct3(InstrD[14:12]),
        .funct7b5(InstrD[30]),
        .Branch(BranchD),
        .Jump(JumpD),
        .ResultSrc(ResultSrcD),
        .MemWrite(MemWriteD),
        .ImmSrc(ImmSrcD),
        .RegWrite(RegWriteD),
        .ALUSrc(ALUSrcD),
        .ALUControl(ALUControlD)
    );

    // Hazard detection unit
    HazardUnit hazard_unit(
        .Rs1D(InstrD[19:15]),
        .Rs2D(InstrD[24:20]),
        .RdE(rdE),
        .PCSrcE(PCSrcE),
        .ResultSrcE0(ResultSrcE[0]),
        .StallF(StallF),
        .StallD(StallD),
        .FlushE(FlushE),
        .FlushD(FlushD)
    );

    // ID/EX pipeline register
    ID_IE ID_IE(
        .clk(clk),
        .reset(reset),
        .flush(FlushE),
        .rd1D(RD1D),
        .rd2D(RD2D),
        .PCD(PCD),
        .rs1D(InstrD[19:15]),
        .rs2D(InstrD[24:20]),
        .rdD(InstrD[11:7]),
        .ImmExtendD(ImmExtendD),
        .PCPlus4D(PCPlus4D),
        .RegWriteD(RegWriteD),
        .ResultSrcD(ResultSrcD),
        .MemWriteD(MemWriteD),
        .JumpD(JumpD),
        .BranchD(BranchD),
        .ALUSrcD(ALUSrcD),
        .ALUControlD(ALUControlD),
        .rd1E(RD1E),
        .rd2E(RD2E),
        .PCE(PCE),
        .rs1E(rs1E),
        .rs2E(rs2E),
        .rdE(rdE),
        .ImmExtendE(ImmExtendE),
        .PCPlus4E(PCPlus4E),
        .RegWriteE(RegWriteE),
        .ResultSrcE(ResultSrcE),
        .MemWriteE(MemWriteE),
        .JumpE(JumpE),
        .BranchE(BranchE),
        .ALUSrcE(ALUSrcE),
        .ALUControlE(ALUControlE)
    );

    // ALU input multiplexers with forwarding
    mux2 Src_B(.d0(SrcB), .d1(ImmExtendE), .s(ALUSrcE), .y(SrcBE));
    mux3to1 mux(.d0(RD1E), .d1(ResultW), .d2(ALUResultM), .s(ForwardAE), .y(SrcAE));
    mux3to1 mux2(.d0(RD2E), .d1(ResultW), .d2(ALUResultM), .s(ForwardBE), .y(SrcB));

    // ALU
    ALU ALU(
        .SrcA(SrcAE),
        .SrcB(SrcBE),
        .ALUControl(ALUControlE),
        .ALUResult(ALUResultE),
        .Zero(ZeroE)
    );

    // EX/MEM pipeline register
    IE_IM IE_IM(
        .clk(clk),
        .reset(reset),
        .ALUResultE(ALUResultE),
        .RD2E(RD2E),
        .RegWriteM(RegWriteM),
        .MemWriteM(MemWriteM),
        .ResultSrcM(ResultSrcM),
        .RegWriteE(RegWriteE),
        .MemWriteE(MemWriteE),
        .ResultSrcE(ResultSrcE),
        .rdE(rdE),
        .PCPlus4E(PCPlus4E),
        .ALUResultM(ALUResultM),
        .RD2M(RD2M),
        .rdM(rdM),
        .PCPlus4M(PCPlus4M)
    );

    // Data memory
    data_mem data_memory(
        .clk(clk),
        .we(MemWriteM),
        .A(ALUResultM),
        .WD(RD2M),
        .ReadData(ReadDataM)
    );

    // MEM/WB pipeline register
    IM_IW IM_IW(
        .clk(clk),
        .reset(reset),
        .ALUResultM(ALUResultM),
        .ReadDataM(ReadDataM),
        .PCPlus4M(PCPlus4M),
        .RegWriteM(RegWriteM),
        .ResultSrcM(ResultSrcM),
        .rdM(rdM),
        .ALUResultW(ALUResultW),
        .ReadDataW(ReadDataW),
        .PCPlus4W(PCPlus4W),
        .rdW(rdW),
        .RegWriteW(RegWriteW),
        .ResultSrcW(ResultSrcW)
    );

    // Write-back multiplexer
    mux3to1 result(
        .d0(ALUResultW),
        .d1(ReadDataW),
        .d2(PCPlus4W),
        .s(ResultSrcW),
        .y(ResultW)
    );

endmodule
