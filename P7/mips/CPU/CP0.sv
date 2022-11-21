`timescale 1ns / 1ps

`define ErrorCode 32'hffffffff

// 忽略软件中断
// 软件中断和硬件中断响应的时间似乎不太一致

`define IM			SR[15:10]	// （硬件）中断屏蔽。高电平表示接受该种类型中断
`define EXL			SR[1]		// 异常级。异常发生时变为高电平，强行进入核心态并屏蔽中断。
`define IE			SR[0]		// 全局中断使能。
`define	BD			Cause[31]	// 分支延迟
`define IP			Cause[15:10]// 待决的（硬件）中断
`define ExcCode		Cause[6:2]	// 异常编码

module CP0 (
	input			clk, reset,
	input			CP0En,		// 写使能信号
	input	[4:0]	CP0Addr,	// 寄存器地址
	input	[31:0]	CP0In,		// CP0 写入数据
	output	[31:0]	CP0Out,		// CP0 读出数据
	input	[31:0]	VPC,		// 受害 PC
	input			BDIn,		// 是否是延迟槽指令
	input	[4:0]	ExcCodeIn,	// 记录异常类型
	input	[5:0]	HWInt,		// 输入中断信号
	input			EXLClr,		// 用来复位 EXL
	output	[31:0]	EPCOut,		// EPC 的值
	output			Req			// 进入处理程序请求
);
	logic	[31:0]	SR;		// 12 SR
	logic	[31:0]	Cause;	// 13 Cause 寄存器只用来保存状态，说明引发异常的原因
	logic	[31:0]	EPC;	// 14
	logic	[31:0]	PRId;	// 15

	logic	IntReq, ExcReq;
	assign	IntReq 	= (~`EXL) && (|(`IM & HWInt)) && `IE;	// 是否发生被接受的外部中断
	assign	ExcReq 	= (|ExcCodeIn);							// 是否发生除了中断之外的异常
	assign	Req		= IntReq || ExcReq;						// 是否发生异常

	assign	EPCOut	= EPC;

	assign	CP0Out	=	CP0Addr == 32'd12 ? SR		:
						CP0Addr == 32'd13 ? Cause	:
						CP0Addr == 32'd14 ? EPC		:
						CP0Addr == 32'd15 ? PRId	:
											`ErrorCode;

	always@(posedge clk) begin
		if(reset) begin
			SR			<= 32'b0;
			Cause		<= 32'b0;
			EPC			<= 32'b0;
			PRId		<= 32'b0;
		end
		else begin
			`IP				<= HWInt;	// 待决的（硬件）中断，照抄硬件信号
			if(Req) begin	// 发生异常 保存状态
				`ExcCode	<= IntReq ? 0 : ExcCodeIn;
				`BD			<= BDIn;
				EPC			<= BDIn ? VPC - 4 : VPC;
				`EXL		<= 1;	// 置高异常级，进入核心态并不再响应中断
			end
			else if(EXLClr) begin	// 异常处理结束，回到用户态并开始响应中断
				`EXL		<= 0;
			end
			else if(CP0En) begin	// 写寄存器
				case(CP0Addr)
					32'd12 : SR		<= CP0In;
					32'd13 : Cause	<= CP0In;
					32'd14 : EPC	<= CP0In;
					32'd15 : PRId	<= CP0In;
				endcase
			end
		end
	end

endmodule