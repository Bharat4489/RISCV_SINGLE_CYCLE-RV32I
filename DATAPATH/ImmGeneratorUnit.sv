`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.04.2025 23:32:47
// Design Name: 
// Module Name: ImmGeneratorUnit
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


module ImmGeneratorUnit(
    input  logic [31:0] instruction,
    input  logic [1:0]  ImmSel,       // 00: I-type, 01: S-type, 10: SB-type
    output logic [31:0] Imm_out       // 32-bit sign-extended immediate
); 
 //COMMENTS ARE AFTER THE LOGIC \/  
    logic [11:0] imm_i, imm_s, imm_sb;
    //logic [31:0] sign_extended;

    always_comb begin
        // I-type: bits [31:20]
        imm_i = instruction[31:20];

        // S-type: bits [31:25] and [11:7]
        imm_s = {instruction[31:25], instruction[11:7]};

        // SB-type (Branch): [12|10:5|4:1|11] (then add 0 at LSB and sign-extend)
        imm_sb = {instruction[31], instruction[7], instruction[30:25], instruction[11:8]};

        // Mux selection and sign extension
        case (ImmSel)
            2'b00: Imm_out = {{20{imm_i[11]}}, imm_i};                    // I-type
            2'b01: Imm_out = {{20{imm_s[11]}}, imm_s};                    // S-type
            2'b10: Imm_out = {{19{imm_sb[11]}}, imm_sb, 1'b0};            // SB-type, add 0 as LSB
            default: Imm_out = 32'b0;
        endcase
    end

/*
---------------------------------------------------------------
| ImmSel | Instruction Type | Immediate Bits Used            |
|--------|------------------|--------------------------------|
|  00    | Load (I-type)     | instruction[31:20]             |
|  01    | Store (S-type)    | {instruction[31:25],           |
|        |                   |  instruction[11:7]}            |
|  10    | Branch (SB-type)  | {instruction[31],              |
|        |                   |  instruction[7],               |
|        |                   |  instruction[30:25],           |
|        |                   |  instruction[11:8]}            |
|  11    | Reserved/Invalid  | 12'bx                          |
---------------------------------------------------------------
*/

endmodule
