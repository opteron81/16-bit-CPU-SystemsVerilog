`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2026 05:20:45 PM
// Design Name: 
// Module Name: mem_instr
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


module mem_instr (
    input logic clk_a,
    input logic ena,
    input logic [15:0] addr_in,
    output logic [15:0] instr_out
);
    logic [15:0] rom [0:255];

    initial begin
        rom[0] = 16'h0000;
        rom[1] = 16'h0000;
        rom[2] = 16'h0000;
        rom[3] = 16'h0000;
    end

    always_ff @(posedge clk_a) begin
        if (ena) begin
            instr_out <= rom[addr_in[7:0]];
        end
    end

endmodule
