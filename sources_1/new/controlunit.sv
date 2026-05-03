`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2026 04:17:31 PM
// Design Name: 
// Module Name: controlunit
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


module control (
    input logic [3:0] op_in,
    input logic s_bit_in,
    input logic cmp,  
    output logic [3:0] alu_op_out,
    output logic [1:0] pc_op_out,
    output logic reg_we_out,
    output logic mem_re_out,
    output logic mem_we_out,
    output logic imm_reg_out,
    output logic mem_reg_out
);

    always_comb begin
        alu_op_out = 4'b0000;
        pc_op_out = 2'b01;  
        reg_we_out = 1'b0;
        mem_re_out = 1'b0;
        mem_we_out = 1'b0;
        imm_reg_out = 1'b0;
        mem_reg_out = 1'b0;

        case (op_in)

            4'b0000, // ADD
            4'b0001, // SUB
            4'b0010, // AND
            4'b0011, // NOT
            4'b0100, // ORR
            4'b0101, // EOR
            4'b0110, // SLL
            4'b0111: begin // SLR
                alu_op_out   = op_in;
                reg_we_out = 1'b1;
            end

            // CMP
            4'b1000: begin
                alu_op_out = op_in;
                reg_we_out = 1'b0;
            end

            // IMM
            4'b1001: begin
                reg_we_out = 1'b1;
                imm_reg_out = 1'b1;
            end

            // LDR
            4'b1010: begin
                reg_we_out = 1'b1;
                mem_re_out  = 1'b1;
                mem_reg_out   = 1'b1;
            end

            // STR
            4'b1011: begin
                mem_we_out = 1'b1;
            end

            // BRCH
            4'b1100: begin
                if ((s_bit_in == 1'b0 && cmp == 1'b0) ||
                    (s_bit_in == 1'b1 && cmp == 1'b1)) begin
                    pc_op_out = 2'b10; 
                end
                else begin
                    pc_op_out = 2'b01; 
                end
            end

            // NOP
            4'b1101: begin
                pc_op_out = 2'b01;
            end

            default: begin
                pc_op_out = 2'b01;
            end
        endcase
    end

endmodule
