`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2026 09:51:41 PM
// Design Name: 
// Module Name: tb_alu
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


module tb_alu;

    logic [15:0] a;
    logic [15:0] b;
    logic [4:0] imm5;
    logic [3:0] opcode;
    logic s_bit;

    logic [15:0] result;
    logic neg;
    logic carry;
    logic overflow;

    alu dut (
        .a(a),
        .b(b),
        .imm5(imm5),
        .opcode(opcode),
        .s_bit(s_bit),
        .result(result),
        .negative(negative),
        .carry(carry),
        .overflow(overflow)
    );

    initial begin

        #0 a = 16'd5; // ADD unsigned: 5 + 3 = 8
        b = 16'd3;
        imm5 = 5'd0;
        opcode = 4'b0000;
        s_bit = 1'b0; 

        #5 a = 16'h7FFF; // ADD signed 32767 + 1 (overflow)
        b = 16'h0001;
        opcode = 4'b0000;
        s_bit = 1'b1;

        #5 a = 16'h7FFF;// ADD signed -32768 - 1 (overflow)
        a = 16'h8000; 
        b = 16'hFFFF; 
        opcode = 4'b0000; 
        s_bit = 1'b1;   

        #5 a = 16'd9;// SUB unsigned: 9 - 4 = 5
        b = 16'd4;
        opcode = 4'b0001; 
        s_bit = 1'b0;  

        #5 a = 16'h00F0; // AND
        b = 16'h0F0F;
        opcode = 4'b0010; 
        s_bit = 1'b0;

        #5 a = 16'h00F0; //NOT
        b = 16'h0000;
        opcode = 4'b0011; 
        s_bit = 1'b0;
 
        #5 a = 16'h00F0; // ORR
        b = 16'h0F0F;
        opcode = 4'b0100;
        s_bit = 1'b0;

        #5 a = 16'h00FF; // XOR
        b = 16'h0F0F;
        opcode = 4'b0101; 
        s_bit = 1'b0;

        #5 a = 16'h0003; //SLL
        b = 16'h0000;
        imm5 = 5'd2;
        opcode = 4'b0110;
        s_bit = 1'b0;;

        #5 a = 16'h0010; // SLR
        b = 16'h0000;
        imm5 = 5'd2;
        opcode = 4'b0111;
        s_bit = 1'b0;

        #5 a = 16'd5; // CMP unsigned: 5 vs 5
        b = 16'd5;
        opcode = 4'b1000; 
        s_bit = 1'b0;     
        
        #5 a = 16'hFFFD;     // CMP signed: -3 vs 2
        b = 16'h0002;    
        opcode = 4'b1000; 
        s_bit = 1'b1;    
    end

endmodule
