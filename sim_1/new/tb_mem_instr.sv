`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2026 10:17:11 PM
// Design Name: 
// Module Name: tb_mem_instr
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


module tb_mem_instr;

    logic clk_a;
    logic ena;
    logic [15:0] addr_in;
    logic [15:0] instr_out;

    mem_instr dut (
        .clk_a(clk_a),
        .ena(ena),
        .addr_in(addr_in),
        .instr_out(instr_out)
    );

    initial begin
        clk_a = 1'b0;
        ena = 1'b1;
        addr_in = 16'd10;

        #5 clk_a = 1'b1;
        #5 clk_a = 1'b0; addr_in = 16'd12;

        #5 clk_a = 1'b1;
        #5 clk_a = 1'b0; addr_in = 16'd14;

        #5 clk_a = 1'b1;
        #5 clk_a = 1'b0; addr_in = 16'd16;

        #5 clk_a = 1'b1;
        #5 clk_a = 1'b0; addr_in = 16'd18;

        #5 $stop;
    end

endmodule