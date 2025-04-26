`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.04.2025 22:31:22
// Design Name: 
// Module Name: ALU_CONTROL
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


module ALUOp(
    input logic [2:0]opcode,
    output logic [1:0]ALUOp
    );
    
    always_comb begin
        case(opcode)
            3'b011: ALUOp = 2'b10; // R-type-add,sub,AND,OR
            3'b010, 3'b000: ALUOp = 2'b00; //store & load
            3'b001: ALUOp = 2'b10; //I-type
            3'b110: ALUOp = 2'b01; //branch
            default: ALUOp = 2'bx;
        endcase
    end
endmodule


//finally making 4 bit ALUControl using output of ALUOp & funct3 all bits &funct7[5] as only R-type uses and only this bit changes
module ALUControl (
    input  logic [1:0] ALUOp,        // From ALUOp module
    input  logic [2:0] funct3,       // funct3 field of instruction
    input  logic       funct7_30,    // Bit 30 of funct7
    output logic [3:0] ALUControl
);

    always_comb begin
        case (ALUOp)
            2'b00: ALUControl = 4'b0010; // Load/Store -> ADD
            2'b01: ALUControl = 4'b0110; // Branch -> SUB
            2'b10: begin                 // R-type or I-type ALU ops
                case (funct3)
                    3'b000: ALUControl = (funct7_30) ? 4'b0110 : 4'b0010; // SUB or ADD
                    3'b111: ALUControl = 4'b0000; // AND
                    3'b110: ALUControl = 4'b0001; // OR
                    3'b100: ALUControl = 4'b1100; // XOR 
                    3'b010: ALUControl = 4'b0100; // SLT (Signed)
                    3'b011: ALUControl = 4'b0111; // SLTU (Unsigned)
                    default: ALUControl = 4'b1111; // Undefined
                endcase
            end
            default: ALUControl = 4'b1111; // Undefined
        endcase
    end
endmodule


