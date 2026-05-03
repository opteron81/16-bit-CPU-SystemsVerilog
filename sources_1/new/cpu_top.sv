`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2026 10:31:46 PM
// Design Name: 
// Module Name: cpu_top
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


module cpu_top (
    input  logic        clk_in,
    input  logic        rst,
    input  logic        ena_in,

    output logic [15:0] pc_out_debug,
    output logic [15:0] instruction_debug,
    output logic [3:0]  opcode_debug,
    output logic [15:0] alu_result_debug,
    output logic [15:0] reg_write_data_debug,
    output logic [15:0] mem_data_out_debug,
    output logic        negative_debug,
    output logic        carry_debug,
    output logic        overflow_debug,
    output logic        cmp_equal_debug
);

    // ---------------------------
    // Internal signals
    // ---------------------------
    logic [15:0] pc_out;
    logic [15:0] pc_in;
    logic [1:0]  pc_op;

    logic [15:0] instruction;

    logic [3:0]  opcode_dec;
    logic        s_bit_dec;
    logic [7:0]  imm_data_dec;
    logic [4:0]  imm5_dec;
    logic        we_dec;
    logic [2:0]  sel_R1_dec;
    logic [2:0]  sel_R2_dec;
    logic [2:0]  sel_Rd_dec;

    logic [3:0]  alu_opcode_ctrl;
    logic [1:0]  pc_op_ctrl;
    logic        reg_write_en_ctrl;
    logic        mem_read_en_ctrl;
    logic        mem_write_en_ctrl;
    logic        imm_to_reg_ctrl;
    logic        mem_to_reg_ctrl;

    logic [15:0] reg_data1;
    logic [15:0] reg_data2;
    logic [15:0] reg_write_data;

    logic [15:0] alu_result;
    logic        alu_negative;
    logic        alu_carry;
    logic        alu_overflow;

    logic [15:0] mem_data_out;

    logic        cmp_equal_flag;
    logic [15:0] branch_target;

    // ---------------------------
    // Program Counter
    // ---------------------------
    pc pc_u (
        .clk_in(clk_in),
        .pc_op_in(pc_op),
        .pc_in(pc_in),
        .pc_out(pc_out)
    );

    // ---------------------------
    // Instruction Memory
    // ---------------------------
    mem_instr mem_instr_u (
        .clk_in(clk_in),
        .ena_in(ena_in),
        .address_in(pc_out),
        .instruction_out(instruction)
    );

    // ---------------------------
    // Decoder
    // ---------------------------
    decoder decoder_u (
        .instruction_in(instruction),
        .opcode_out(opcode_dec),
        .s_bit_out(s_bit_dec),
        .imm_data_out(imm_data_dec),
        .imm5_out(imm5_dec),
        .we_out(we_dec),
        .sel_R1_out(sel_R1_dec),
        .sel_R2_out(sel_R2_dec),
        .sel_Rd_out(sel_Rd_dec)
    );

    // ---------------------------
    // Control
    // ---------------------------
    control control_u (
        .opcode_in(opcode_dec),
        .s_bit_in(s_bit_dec),
        .cmp_equal_in(cmp_equal_flag),
        .alu_opcode_out(alu_opcode_ctrl),
        .pc_op_out(pc_op_ctrl),
        .reg_write_en_out(reg_write_en_ctrl),
        .mem_read_en_out(mem_read_en_ctrl),
        .mem_write_en_out(mem_write_en_ctrl),
        .imm_to_reg_out(imm_to_reg_ctrl),
        .mem_to_reg_out(mem_to_reg_ctrl)
    );

    // ---------------------------
    // Register File
    // ---------------------------
    register_log regfile_u (
        .clk_a(clk_in),
        .rst(rst),
        .R1(sel_R1_dec),
        .R2(sel_R2_dec),
        .Rd(sel_Rd_dec),
        .wr_data_in(reg_write_data),
        .ena(ena_in),
        .we(we_dec && reg_write_en_ctrl),
        .data1_out(reg_data1),
        .data2_out(reg_data2)
    );

    // ---------------------------
    // ALU
    // ---------------------------
    alu alu_u (
        .a(reg_data1),
        .b(reg_data2),
        .imm5(imm5_dec),
        .opcode(alu_opcode_ctrl),
        .s_bit(s_bit_dec),
        .result(alu_result),
        .negative(alu_negative),
        .carry(alu_carry),
        .overflow(alu_overflow)
    );

    // ---------------------------
    // Data Memory
    // ---------------------------
    mem_data mem_data_u (
        .clk_in(clk_in),
        .rst(rst),
        .ena_in(ena_in),
        .we_in(mem_write_en_ctrl),
        .address_in(reg_data1),
        .data_in(reg_data2),
        .data_out(mem_data_out)
    );

    // ---------------------------
    // Branch target
    // BRCH uses signed imm8
    // ---------------------------
    assign branch_target = pc_out + {{8{imm_data_dec[7]}}, imm_data_dec};

    always_comb begin
        pc_op = pc_op_ctrl;

        if (pc_op_ctrl == 2'b10)
            pc_in = branch_target;
        else
            pc_in = 16'h0000;
    end

    // ---------------------------
    // Writeback mux
    // IMM:
    //   S=0 -> load low byte  : 0x00ii
    //   S=1 -> load high byte : ii00
    // ---------------------------
    always_comb begin
        if (imm_to_reg_ctrl) begin
            if (s_bit_dec == 1'b0)
                reg_write_data = {8'h00, imm_data_dec};
            else
                reg_write_data = {imm_data_dec, 8'h00};
        end
        else if (mem_to_reg_ctrl) begin
            reg_write_data = mem_data_out;
        end
        else begin
            reg_write_data = alu_result;
        end
    end

    // ---------------------------
    // CMP flag register
    // Stores result of previous CMP
    // ---------------------------
    always_ff @(posedge clk_in) begin
        if (rst) begin
            cmp_equal_flag <= 1'b0;
        end
        else if (ena_in && (opcode_dec == 4'b1000)) begin
            cmp_equal_flag <= (reg_data1 == reg_data2);
        end
    end

    // ---------------------------
    // Debug outputs
    // ---------------------------
    assign pc_out_debug         = pc_out;
    assign instruction_debug    = instruction;
    assign opcode_debug         = opcode_dec;
    assign alu_result_debug     = alu_result;
    assign reg_write_data_debug = reg_write_data;
    assign mem_data_out_debug   = mem_data_out;
    assign negative_debug       = alu_negative;
    assign carry_debug          = alu_carry;
    assign overflow_debug       = alu_overflow;
    assign cmp_equal_debug      = cmp_equal_flag;

endmodule
