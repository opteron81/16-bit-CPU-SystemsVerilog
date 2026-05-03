`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2026 11:22:29 PM
// Design Name: 
// Module Name: alu
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

module alu (
    input  logic [15:0] a,                                                  // operand 1 from the decoder
    input  logic [15:0] b,                                                  // operand 2
    input  logic [4:0] imm5,                                                // shift value for SLL/SLR
    input  logic [3:0] opcode,                                              // operation code
    input  logic s_bit,                                                     // 0 = unsigned, 1 = signed

    output logic [15:0] result,
    output logic negative,
    output logic carry,
    output logic overflow
);

    logic [16:0] sum_ext;
    logic [16:0] sub_ext;
    logic [15:0] cmp_temp;

    always_comb begin
        // rst/default
        result   = 16'h0000;
        negative = 1'b0;
        carry    = 1'b0;
        overflow = 1'b0;

        sum_ext  = 17'h00000;
        sub_ext  = 17'h00000;
        cmp_temp = 16'h0000;

        case (opcode)

            4'b0000: begin // ADD
                sum_ext = {1'b0, a} + {1'b0, b};                            // concatenate 0 to each to fit 17 bit addition
                result = sum_ext[15:0];                                     // result excludes the concatenation

                if (s_bit == 1'b0) begin // unsigned 
                    carry = sum_ext[16];                                    // assign bit 17 to carry if there is one
                    overflow = 1'b0;                                        
                end
                else begin // signed 
                    carry = 1'b0;
                    overflow = (~(a[15] ^ b[15])) & (a[15] ^ result[15]);   // top bit in each operand shows pos(0) or neg(1)
                end
            end

            4'b0001: begin // SUB
                sub_ext = {1'b0, a} - {1'b0, b};
                result = sub_ext[15:0];                                     

                if (s_bit == 1'b0) begin // unsigned 
                    carry = sub_ext[16];                                    // high = borrow occured for subtraction
                    overflow = 1'b0;
                end
                else begin // signed
                    carry = 1'b0;
                    overflow = (a[15] ^ b[15]) & (a[15] ^ result[15]);      // inverse overflow reasoning from the ADD logic
                end
            end

            4'b0010: begin // AND
                result = a & b;
            end

            4'b0011: begin // NOT
                result = ~a;
            end

            4'b0100: begin // ORR
                result = a | b;
            end

            4'b0101: begin // EOR
                result = a ^ b;
            end

            4'b0110: begin // SLL
                result = a << imm5;
            end

            4'b0111: begin // SLR
                result = a >> imm5;
            end

            4'b1000: begin // CMP
                sub_ext  = {1'b0, a} - {1'b0, b};
                cmp_temp = sub_ext[15:0];
                result   = 16'h0000;                                        // CMP does not write back a result

                if (s_bit == 1'b0) begin // unsigned compare
                    carry    = sub_ext[16];
                    overflow = 1'b0;
                end
                else begin // signed compare
                    carry    = 1'b0;
                    overflow = (a[15] ^ b[15]) & (a[15] ^ cmp_temp[15]);
                end

                negative = cmp_temp[15];
            end

            default: begin
                result = 16'h0000;
            end
        endcase
        
        if (opcode != 4'b1000) begin                                        // negative flag for normal result OPERATIONS
            negative = result[15];
        end
    end

endmodule