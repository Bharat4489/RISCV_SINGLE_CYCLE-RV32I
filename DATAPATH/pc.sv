`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.04.2025 23:35:06
// Design Name: 
// Module Name: pc
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


module pc (
    input logic [31:0] pc_in,
    input logic clk,
    input logic reset,
    output logic [31:0] d
);

    always_ff @(posedge clk or negedge reset) begin
        if (!reset)
            d <= 32'b0;
        else
            d <= pc_in;
    end

endmodule
