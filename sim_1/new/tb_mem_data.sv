module tb_mem_data;

    logic clk_a;
    logic rst;
    logic ena;
    logic we_in;
    logic [15:0] addr_in;
    logic [15:0] data_in;
    logic [15:0] data_out;

    mem_data dut (
        .clk_in(clk_a),
        .rst(rst),
        .ena_in(ena),
        .we_in(we_in),
        .address_in(addr_in),
        .data_in(data_in),
        .data_out(data_out)
    );

    initial begin
        clk_a = 1'b0;
        rst = 1'b1;
        ena = 1'b0;
        we_in = 1'b0;
        addr_in = 16'h0000;
        data_in = 16'h0000;

        #5 clk_a = 1'b1;
        #5 clk_a = 1'b0;
        rst = 1'b0;
        ena = 1'b1;

        #5 we_in = 1'b1; addr_in = 16'h0009; data_in = 16'h3333;
        #5 clk_a = 1'b1;
        #5 clk_a = 1'b0; we_in = 1'b0;

        #5 addr_in = 16'h0009;
        #5 clk_a = 1'b1;
        #5 clk_a = 1'b0;

        #5 $stop;
    end

endmodule