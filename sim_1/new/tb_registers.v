`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2026 11:03:32 PM
// Design Name: 
// Module Name: tb_registers
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


module tb_registers;

    logic clk_a;
    logic rst;
    logic [2:0] R1;
    logic [2:0] R2;
    logic [2:0] Rd;
    logic [15:0] wr_data_in;
    logic ena;
    logic we;

    logic [15:0] data1_out;
    logic [15:0] data2_out;

    register_log dut (
        .clk_a(clk_a),
        .rst(rst),
        .R1(R1),
        .R2(R2),
        .Rd(Rd),
        .wr_data_in(wr_data_in),
        .ena(ena),
        .we(we),
        .data1_out(data1_out),
        .data2_out(data2_out)
    );

    initial begin
        clk_a = 1'b0;
        forever #5 clk_a = ~clk_a;
    end

    initial begin
        rst = 1'b1;
        ena = 1'b0;
        we = 1'b0;
        R1 = 3'b000;
        R2 = 3'b000;
        Rd = 3'b000;
        wr_data_in = 16'h0000;

        // reset pulse
        #5  clk_a = 1'b1;
        #5  clk_a = 1'b0;
        rst = 1'b0;
        ena = 1'b1;

        // write 5 to R1
        #5  Rd = 3'b001; wr_data_in = 16'd5; we = 1'b1;
        #5  clk_a = 1'b1;
        #5  clk_a = 1'b0; we = 1'b0;

        // write 7 to R2
        #5  Rd = 3'b010; wr_data_in = 16'd7; we = 1'b1;
        #5  clk_a = 1'b1;
        #5  clk_a = 1'b0; we = 1'b0;

        // read R1 and R2
        #5  R1 = 3'b001; R2 = 3'b010;

        // try writing FFFF to R0 (should be ignored)
        #5  Rd = 3'b000; wr_data_in = 16'hFFFF; we = 1'b1;
        #5  clk_a = 1'b1;
        #5  clk_a = 1'b0; we = 1'b0;

        // read R0 and R2
        #5  R1 = 3'b000; R2 = 3'b010;

        // disable outputs
        #5  ena = 1'b0;

        // enable again and read R1/R2
        #5  ena = 1'b1; R1 = 3'b001; R2 = 3'b010;

        #10 $finish;
    end

endmodule
