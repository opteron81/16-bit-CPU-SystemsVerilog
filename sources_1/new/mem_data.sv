`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2026 10:15:20 PM
// Design Name: 
// Module Name: mem_data
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


module mem_data (
    input logic clk_a,
    input logic rst,
    input logic ena,
    input logic we_in,
    input logic [15:0] addr_in,
    input logic [15:0] data_in,

    output logic [15:0] data_out
);
    logic [15:0] ram [0:255];
    integer i;

    always_ff @(posedge clk_a) begin
        if (rst) begin
            for (i = 0; i < 256; i = i + 1) begin
                ram[i] <= 16'h0000;
            end
            data_out <= 16'h0000;
        end
        else if (ena) begin
            if (we_in) begin
                ram[addr_in[7:0]] <= data_in;
            end
            else begin
                data_out <= ram[addr_in[7:0]];
            end
        end
    end

endmodule
