`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.04.2025 16:14:34
// Design Name: 
// Module Name: datapath
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

module Datapath(
    input logic clk,
    input logic reset,
    input logic [1:0]ImmSel,           // Immediate Select signal
    input logic RegWrite,
    input logic MemWrite,
    input logic MemRead,
    input logic ALUSrc,
    input logic MemtoReg,
    input logic PCSrc,
    input logic [3:0] ALUControl,
    output logic [31:0] pc_out,
    output logic [31:0] ALUResult,
    output logic zero,
    output logic [31:0] instruction
);

    logic [31:0] pc_next;
    logic [31:0] pc_plus4;
    logic [31:0] read_data1, read_data2;
    logic [31:0] Imm_out;
    logic [31:0] alu_src_b;
    logic [31:0] mem_data_out;
    logic [31:0] write_back_data;

    // PC Register
    pc pc_reg (
        .clk(clk),
        .reset(reset),
        .pc_in(pc_next),
        .d(pc_out) // pc_out connects to instruction memory address input
    );

    // Instruction Memory
    instr_mem instr_memory (
        .im_add(pc_out), // Address input is PC output
        .instruction(instruction)
    );

    // Adder: PC + 4
    Adder adder_pc4 (
        .A(pc_out),
        .B(32'd4),
        .sum(pc_plus4)
    );

    // Immediate Generator
    ImmGeneratorUnit imm_gen (
        .instruction(instruction),
        .ImmSel(ImmSel),
        .Imm_out(Imm_out)
    );

    // Register File
    register reg_file (
        .clk(clk),
        .reset(reset),
        .read_reg1(instruction[19:15]),
        .read_reg2(instruction[24:20]),
        .write_reg(instruction[11:7]),
        .write_data(write_back_data),
        .regwrite(RegWrite),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // ALU Src Mux: select between ReadData2 and Immediate
    mux_2 alu_src_mux (
        .a(read_data2),
        .b(Imm_out),
        .sel(ALUSrc),
        .mux_out(alu_src_b)
    );

    // ALU
    ALU alu_unit (
        .SrcA(read_data1),
        .SrcB(alu_src_b),
        .ALUControl(ALUControl),
        .zero(zero),
        .ALUResult(ALUResult)
    );

    // Data Memory
    data_mem data_memory (
        .clk(clk),
        .reset(reset),
        .memread(MemRead),
        .memwrite(MemWrite),
        .address(ALUResult),
        .write_data(read_data2),
        .read_data(mem_data_out)
    );

    // MemtoReg Mux: select between ALUResult and Memory Data
    mux_2 mem_to_reg_mux (
        .a(ALUResult),
        .b(mem_data_out),
        .sel(MemtoReg),
        .mux_out(write_back_data)
    );

    // PCSrc Mux: select between PC+4 and Branch Target
    logic [31:0] branch_target;
    
    Adder branch_adder (
        .A(pc_out),
        .B(Imm_out), // assuming Imm_out already left shifted
        .sum(branch_target)
    );

    mux_2 pc_src_mux (
        .a(pc_plus4),
        .b(branch_target),
        .sel(PCSrc & zero),
        .mux_out(pc_next)
    );

endmodule



