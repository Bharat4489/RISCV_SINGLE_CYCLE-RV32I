`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.04.2025 20:58:47
// Design Name: 
// Module Name: mux_2
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


module mux_2 #(parameter MUX_2_WIDTH = 32)(
            input logic [MUX_2_WIDTH-1:0]a,b,
            input sel,
            output logic [MUX_2_WIDTH-1:0] mux_out
    );
    
    assign mux_out = sel?b:a;
    
endmodule
