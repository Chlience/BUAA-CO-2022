`define ErrorCode 32'h7fffffff

module BRIDGE (
	input   [31:0]  a,
	output  [31:0]  v,
	input   [31:0]  wData,
	input   [3:0]   wByteEn,

	output  [31:0]	aDm;
	input	[31:0]	vDm;
	output	[31:0]	wDataDm;
	output	[3:0]	wByteEnDm;

	output  [31:0]	aDev0;
	input	[31:0]	vDev0;
	output	[31:0]	wDataDev0;
	output			wEnDev0;

	output  [31:0]	aDev1;
	input	[31:0]	vDev1;
	output	[31:0]	wDataDev1;
	output			wEnDev1;

	output	[31:0]	m_int_addr;
	output	[3:0]	m_int_byteen;
);


	logic	Dm, Dev0, Dev1;
	assign	Dm		= 	PrAddr >= 32'h00000000 && PrAddr <= 32'h00002FFF;
	assign	Dev0 	= 	PrAddr >= 32'h00007F00 && PrAddr <= 32'h00007F0B;
	assign	Dev1 	=	PrAddr >= 32'h00007F10 && PrAddr <= 32'h00007F1B;
	assign	IntDev	=	PrAddr >= 32'h00007F20 && PrAddr <= 32'h00007F23;

	logic	wEnDev;
	assign	wEnDev = wByteEn == 4'b1111;

	assign v =	Dm		?	vDm			: 
				Dev0	?	vDev0		:
				Dev1	?	vDev1		:
							`ErrorCode	;

	assign  aDm			= Dm	?	a[31:0] : 0;
	assign  wEnDm		= Dm	?	wByteEn : 0;
	assign  wDataDm		= Dm	?	wData	: 0;

	assign	aDev0		= Dev0	?	a[31:2] : 0;
	assign	wEnDev0		= Dev0	?	wEnDev	: 0;
	assign	wDataDev0	= Dev0	?	wData	: 0;

	assign	aDev1		= Dev1	?	a[31:2] : 0;
	assign	wEnDev1		= Dev1	?	wEnDev	: 0;
	assign	wDataDev1	= Dev1	?	wData	: 0;

	assign	m_int_addr	 = IntDev ? m_int_addr : 0;
	assign	m_int_byteen = IntDev ? wByteEn    : 0;
endmodule