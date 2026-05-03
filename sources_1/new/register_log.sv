`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2026 10:28:51 PM
// Design Name: 
// Module Name: register_log
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


module register_log(
        input logic clk_a,
        input logic rst,
        input logic [2:0] R1,
        input logic [2:0] R2,
        input logic [2:0] Rd,
        input logic [15:0] wr_data_in,
        input logic ena,
        input logic we,
        
        output logic [15:0] data1_out,
        output logic [15:0] data2_out
    );
    
    integer i;
    logic [15:0] reg_array [7:0];
    
    always_ff @(posedge clk_a) begin
        if (rst == 1'b1) begin
            foreach (reg_array[i]) begin
                reg_array[i] <= 16'b0000;
            end
        end 
        else begin
            if ((ena == 1'b0) && (we == 1'b1) && (Rd != 3'b000)) begin
                reg_array[Rd] <= wr_data_in;
            end
        end
    end
    
    always_comb begin
        if (ena == 1'b0) begin
            data1_out = 16'h0000;
            data2_out = 16'h0000;
        end
        else begin
            data1_out = (R1 == 3'b000) ? 16'h0000 : reg_array[R1];
            data2_out = (R2 == 3'b000) ? 16'h0000 : reg_array[R2];
        end
    end            
endmodule
