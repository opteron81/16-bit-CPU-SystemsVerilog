`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2026 10:32:53 PM
// Design Name: 
// Module Name: tb_cpu_top
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


module tb_cpu_top;

    logic clk_a;
    logic rst;
    logic ena;
    logic [15:0] pc_out_debug;
    logic [15:0] instruction_debug;
    logic [3:0] opcode_debug;
    logic [15:0] alu_result_debug;
    logic [15:0] reg_write_data_debug;
    logic [15:0] mem_data_out_debug;
    logic negative_debug;
    logic carry_debug;
    logic overflow_debug;
    logic  cmp_equal_debug;

    cpu_top dut (
        .clk_in(clk_in),
        .rst(rst),
        .ena_in(ena_in),
        .pc_out_debug(pc_out_debug),
        .instruction_debug(instruction_debug),
        .opcode_debug(opcode_debug),
        .alu_result_debug(alu_result_debug),
        .reg_write_data_debug(reg_write_data_debug),
        .mem_data_out_debug(mem_data_out_debug),
        .negative_debug(negative_debug),
        .carry_debug(carry_debug),
        .overflow_debug(overflow_debug),
        .cmp_equal_debug(cmp_equal_debug)
    );

    initial begin
        clk_a = 1'b0;
        forever #5 clk_a = ~clk_a;
    end

    initial begin
        rst = 1'b1;
        ena = 1'b0;

        #12;
        rst = 1'b0;
        ena = 1'b1;

        #200;
        $stop;
    end

endmodule