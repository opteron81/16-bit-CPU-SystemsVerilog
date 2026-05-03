`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2026 03:49:40 PM
// Design Name: 
// Module Name: decoder
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


module decoder (
    input  logic [15:0] instr_in,
    output logic [3:0] op_out,
    output logic s_bit_out,
    output logic [7:0] imm_data_out,
    output logic [4:0] imm5_out,
    output logic we_out,
    output logic [2:0] sel_R1_out,
    output logic [2:0] sel_R2_out,
    output logic [2:0] sel_Rd_out
);

    always_comb begin
        op_out = instr_in[15:12];
        s_bit_out = instr_in[11];
        sel_Rd_out = instr_in[10:8];
        sel_R1_out = instr_in[7:5];
        sel_R2_out = instr_in[4:2];
        imm_data_out = instr_in[7:0];
        imm5_out = instr_in[4:0];
        we_out = 1'b1;

        case (instr_in[15:12])
            4'b1000: we_out = 1'b0; // CMP
            4'b1011: we_out = 1'b0; // STR
            4'b1100: we_out = 1'b0; // BRCH
            4'b1101: we_out = 1'b0; // NON
            default: we_out = 1'b1;
        endcase
    end

endmodule
