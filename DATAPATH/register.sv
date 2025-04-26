`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.04.2025 22:49:08
// Design Name: 
// Module Name: logicister
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Note that the RISC-V logicisters are defined as follows:
//                      Zero logicister: x0
//                      Return address: x1
//                      Stack pointer: x2
//                      Global pointer: x3
//                      Thread pointer: x4
//                      Temporary logicisters: x5-x7, x28-x31
//                      Saved logicister/Frame pointer: x8
//                      Saved logicisters x9, x18-x27
//                      Function arguments and return values: x10- x17 
//////////////////////////////////////////////////////////////////////////////////

              

module register (
    input         clk,
    input         reset,
    input  [4:0]  read_reg1, read_reg2, write_reg,
    input  [31:0] write_data,
    input         regwrite,
    output [31:0] read_data1, read_data2
);

    // logicister file with 32 logicisters of 32 bits
    logic [31:0] register_file [31:0];
    integer i;

    // Synchronous reset and write logic
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            for (i = 0; i < 32; i = i + 1)
                register_file[i] <= 32'b0;
        end
        else begin
            $readmemh("C:/0.Official/6. RISC_VLSI_Arch/IMPLEMENTATION/REGISTER.txt",register_file);
            if (regwrite && write_reg != 0) begin
                // Writing to x0 is ignored (standard in RISC-V)
                register_file[write_reg] <= write_data;
            end
           end
    end

    // Combinational read ports (dual-port read)
    assign read_data1 = register_file[read_reg1];
    assign read_data2 = register_file[read_reg2];

endmodule