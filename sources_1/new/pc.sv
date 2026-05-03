`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2026 03:17:33 PM
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
    input logic clk_a,
    input logic [1:0]  pc_op_in,
    input logic [15:0] pc_in,
    output logic [15:0] pc_out
);
    logic [15:0] pc_reg = 16'h0000;

    always_ff @(posedge clk_a) begin
        case (pc_op_in)
            2'b00: pc_reg <= 16'h0000;         // reset
            2'b01: pc_reg <= pc_reg + 16'd1;   // increment
            2'b10: pc_reg <= pc_in;            // branch
            2'b11: pc_reg <= pc_reg;           // NOP
            default: pc_reg <= pc_reg;
        endcase
    end

    assign pc_out = pc_reg;

endmodule