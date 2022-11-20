`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2022 06:00:00 PM
// Design Name: 
// Module Name: ALU
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

module mips(
	input 			clk, reset,
	input   [31:0]  i_inst_rdata,   // IM 读取数据
	output  [31:0]  i_inst_addr,    // IM 读取地址（取指 PC）
	input   [31:0]  m_data_rdata,   // DM 读取数据
	output  [31:0]  m_data_addr,    // DM 读写地址
	output  [31:0]  m_data_wdata,   // DM 待写入数据
	output  [3:0]   m_data_byteen,  // DM 字节使能信号
	output  [31:0]  m_inst_addr,    // M 级 PC
	output          w_grf_we,       // GRF 写使能信号
	output  [4 :0]  w_grf_addr,     // GRF 待写入寄存器编号
	output  [31:0]  w_grf_wdata,    // GRF 待写入数据
	output  [31:0]  w_inst_addr,	// W 级 PC

	output  [31:0]  macroscopic_pc,	// 宏观 PC
	input 			interrupt,		// 外部中断信号
	output  [31:0]  m_int_addr,     // 中断发生器待写入地址
	output  [3:0]   m_int_byteen	// 中断发生器字节使能信号
	);

	wire [31:2] TC0Addr, TC1Addr;
	wire [31:0] TC0WD, TC1WD;
	wire [31:0] TC0RD, TC1RD;
	wire IRQ0, IRQ1;
	wire TC0EN, TC1EN;

	TC TC0(
	   .clk(clk), .reset(reset),
	   .Addr(TC0Addr), .WE(TC0EN), .Din(TC0WD), .Dout(TC0RD), .IRQ(IRQ0));
	TC TC1(
	   .clk(clk), .reset(reset),
	   .Addr(TC1Addr), .WE(TC1EN), .Din(TC1WD), .Dout(TC1RD), .IRQ(IRQ1));

	CPU CPU_0(.clk(clk), .reset(reset),
		.i_inst_rdata(i_inst_rdata), .i_inst_addr(i_inst_addr),
		.m_data_rdata(m_data_rdata), .m_data_addr(m_data_addr), .m_data_wdata(m_data_wdata), .m_data_byteen(m_data_byteen), .m_inst_addr(m_inst_addr),
		.w_grf_we(w_grf_we), .w_grf_addr(w_grf_addr), .w_grf_wdata(w_grf_wdata), .w_inst_addr(w_inst_addr),
		.HWInt({3'b0, interrupt, IRQ1, IRQ0}), .macroscopic_pc(macroscopic_pc));
endmodule