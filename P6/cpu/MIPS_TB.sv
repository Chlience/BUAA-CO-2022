`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2022 12:56:36 PM
// Design Name: 
// Module Name: MIPS_tb
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
module mips_txt;
    logic clk;
    logic reset;

    logic [31:0] i_inst_addr;
    logic [31:0] i_inst_rdata;

    logic [31:0] m_data_addr;
    logic [31:0] m_data_rdata;
    logic [31:0] m_data_wdata;
    logic [3 :0] m_data_byteen;

    logic [31:0] m_inst_addr;

    logic w_grf_we;
    logic [4:0]  w_grf_addr;
    logic [31:0] w_grf_wdata;

    logic [31:0] w_inst_addr;

    integer i;
    logic [31:0] fixed_addr;
    logic [31:0] fixed_wdata;
    logic [31:0] data [4095:0];
    logic [31:0] inst [4095:0];
    
    assign m_data_rdata = data[m_data_addr >> 2];
    assign i_inst_rdata = inst[(i_inst_addr - 32'h3000) >> 2];

    integer file;
    initial begin
        file = $fopen("/home/chlience/cpu_sv.out");
        for (i = 0; i < 4096; i = i + 1) data[i] = 0;
        for (i = 0; i < 4096; i = i + 1) inst[i] = 0;
        $readmemh("/home/chlience/code.txt", inst);
    end

    initial begin
        clk = 0;
        reset = 1;
        #12 reset = 0;
    end
    always #5 clk <= ~clk;

    always @(*) begin
        fixed_wdata = data[m_data_addr >> 2];
        fixed_addr = m_data_addr & 32'hfffffffc;
        if (m_data_byteen[3]) fixed_wdata[31:24] = m_data_wdata[31:24];
        if (m_data_byteen[2]) fixed_wdata[23:16] = m_data_wdata[23:16];
        if (m_data_byteen[1]) fixed_wdata[15: 8] = m_data_wdata[15: 8];
        if (m_data_byteen[0]) fixed_wdata[7 : 0] = m_data_wdata[7 : 0];
    end

    always @(posedge clk) begin
        if (reset)
            for (i = 0; i < 4096; i = i + 1)
                data[i] <= 0;
        else if (|m_data_byteen) begin
            data[fixed_addr >> 2] <= fixed_wdata;
            $display("%d@%h: *%h <= %h", $time, m_inst_addr, fixed_addr, fixed_wdata);
            $fdisplay(file, "%d@%h: *%h <= %h", $time, m_inst_addr, fixed_addr, fixed_wdata);
        end
    end

    always @(posedge clk) begin
        if (~reset) begin
            if (w_grf_we && (w_grf_addr != 0)) begin
                $display("%d@%h: $%d <= %h", $time, w_inst_addr, w_grf_addr, w_grf_wdata);
                $fdisplay(file, "%d@%h: $%d <= %h", $time, w_inst_addr, w_grf_addr, w_grf_wdata);
            end
        end
    end

    mips uut(
        .clk(clk),
        .reset(reset),

        .i_inst_addr(i_inst_addr),
        .i_inst_rdata(i_inst_rdata),

        .m_data_addr(m_data_addr),
        .m_data_rdata(m_data_rdata),
        .m_data_wdata(m_data_wdata),
        .m_data_byteen(m_data_byteen),

        .m_inst_addr(m_inst_addr),

        .w_grf_we(w_grf_we),
        .w_grf_addr(w_grf_addr),
        .w_grf_wdata(w_grf_wdata),

        .w_inst_addr(w_inst_addr)
    );

endmodule
