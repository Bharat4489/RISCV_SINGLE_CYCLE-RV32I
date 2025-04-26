`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.04.2025 22:09:41
// Design Name: 
// Module Name: instr_mem
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


module instr_mem(
    input logic [31:0] im_add,
    output logic [31:0] instruction
    );
    
    logic [31:0] im_reg [63:0];
    
    initial
        begin
            $readmemh("C:/0.Official/6. RISC_VLSI_Arch/IMPLEMENTATION/INSTR_MEM.txt",im_reg);
            
        end
        
        always @(*) begin
            instruction = im_reg[im_add[31:2]]; // Assuming word-addressable memory
            $display("instruction = %0xh",instruction);
        end


endmodule
