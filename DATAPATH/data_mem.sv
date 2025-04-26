`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.04.2025 23:19:47
// Design Name: 
// Module Name: data_mem
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


module data_mem(
    input         clk,
    input         reset,           // Active-low reset
    input         memread,
    input         memwrite,
    input  [31:0] address,
    input  [31:0] write_data,
    output logic [31:0] read_data
);

    logic [31:0] memory [0:63];      // 64 x 32-bit memory
    integer i;

    // Memory reset and write
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            for (i = 0; i < 64; i = i + 1)
                memory[i] <= 32'b0;
            read_data <= 32'b0;
        end
        else begin
            $readmemh("C:/0.Official/6. RISC_VLSI_Arch/IMPLEMENTATION/DATA_MEM.txt",memory);
        
            // Write operation
            if (memwrite) begin
                memory[address[5:0]] <= write_data;
            end

            // Read operation (logicistered read)
            if (memread) begin
                read_data <= memory[address[5:0]];
            end
            else begin
                read_data <= 32'b0;
            end
        end
    end

endmodule

