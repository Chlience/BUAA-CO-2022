`timescale 1ns / 1ps
`include "MACRO.sv"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2022 11:57:01 AM
// Design Name: 
// Module Name: PIPELINE
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
// 
//////////////////////////////////////////////////////////////////////////////////
module CPU(
	input   clk,
	input   reset,
	
	input   [31:0]  i_inst_rdata,
	output  [31:0]  i_inst_addr,

	input   [31:0]  m_data_rdata,
	output  [31:0]  m_data_addr,
	output  [31:0]  m_data_wdata,
	output  [3:0]   m_data_byteen,
	output  [31:0]  m_inst_addr,
	
	output          w_grf_we,
	output  [4:0]   w_grf_addr,
	output  [31:0]  w_grf_wdata,

	output  [31:0]  w_inst_addr,

	input	[5:0]	HWInt,
	output	[31:0]	macroscopic_pc
	);


	
    logic	[31:0]	pcF;		// F
    logic	[31:0]	instrF;
    logic   [31:0]  npc;
    logic   		npcEn;

    logic   [31:0]  pcF2D;		// F2D
    logic   [31:0]  instrF2D;
    logic			BD_F2D;

    logic   [31:0]  jpcD;		// D
    logic           jpcEnD;
    logic   [4:0]   a1GrfD;
    logic   [4:0]   a2GrfD;
    logic   [31:0]  v1GrfD;
    logic   [31:0]  v2GrfD;
    logic   [4:0]   a1D, a2D;
    logic   [31:0]  v1D, v2D;
    logic   [4:0]   aNewD;
    logic   [1:0]   tNewD;
    logic   [31:0]  vNewD;

    logic   [31:0]  pcD2E;		// D2E
    logic   [31:0]  instrD2E;
    logic   [31:0]  v1D2E;
    logic   [31:0]  v2D2E;
    logic			BD_D2E;
    
    logic   [4:0]   a1E, a2E;	// E
    logic   [31:0]  v1E, v2E;
    logic   [31:0]  v1AluE;
    logic   [31:0]  v2AluE;
    logic   [15:0]  imm16AluE;
    logic   [3:0]   optAluE;
    logic	[31:0]	v1MdE;
    logic	[31:0]	v2MdE;
    logic	[2:0]	optMdE;
    logic			startMdE;
    logic			busyMdE;
    logic	[31:0]	hiMdE;
    logic	[31:0]	loMdE;
    logic   [31:0]  resAluE;
    logic   		ovAluE;
    logic 	[31:0] 	vE;
    logic   [31:0]  vNewE;

    logic   [31:0]  pcE2M;		// E2M
    logic   [31:0]  instrE2M;
    logic   [31:0]  v2E2M;
    logic   [31:0]  vE2M;
    logic			BD_E2M;

    logic   [4:0]   a2M;		// M
    logic   [31:0]  v2M;
    logic   [31:0]  aDmM;
    logic   [31:0]  wDataDmM;
    logic   [3:0]   wByteEnDmM;

    logic	[4:0]	aCP0M;
    logic	[31:0]	wDataCP0M;
    logic			wEnCP0M;
    logic	[31:0]	vCP0M;
    logic	[31:0]	vpc;
    logic			BD;
    logic	[4:0]	ExcCodeM;
    logic			EXLClr;
    logic	[31:0]	epcM;
	logic	[31:0]	epcEnM;
    logic			req;

    logic   [31:0]  vM;
    logic   [31:0]  vNewM;

    logic   [31:0]  pcM2W;		// M2W
    logic   [31:0]  instrM2W;
    logic   [31:0]  vM2W;

    logic   [4:0]   aGrfW;		// W
    logic   [31:0]  wDataGrfW;
    logic           wEnGrfW;

	// Exception
	// Exception

	logic			AdEL_F, AdEL_D, AdEL_E;
	logic			AdES_F, AdES_D, AdES_E;
	logic			Syscall_F, Syscall_D, Syscall_E;
	logic			RI_F, RI_D, RI_E;
	logic			OV_F, OV_D, OV_E;
	logic	[4:0]	ExcCodeF2D, ExcCodeD2E, ExcCodeE2M;

	// AT Stall
	// AT Stall
	
	logic   [4:0]   a1Use, a2Use;
	logic   [1:0]   t1Use, t2Use;
	logic   [4:0]   aNewD2E, aNewE2M, aNewM2W;
	logic   [1:0]   tNewD2E, tNewE2M, tNewM2W;
	logic   [31:0]  vNewD2E, vNewE2M, vNewM2W;
	
	logic   Stall;
	logic   a1Stall, a2Stall, mdStall;
	logic   a1StallD2E, a2StallD2E;
	logic   a1StallE2M, a2StallE2M;
	logic   a1StallM2W, a2StallM2W;
	
	always@(*) begin // Stall
		if(a1Use != 0) begin
			if(a1Use == aNewD2E) begin
				a1StallD2E = (t1Use < tNewD2E);
				a1StallE2M = 1'd0;
				a1StallM2W = 1'd0;
			end
			else if(a1Use == aNewE2M) begin
				a1StallD2E = 1'd0;    
				a1StallE2M = (t1Use < tNewE2M);
				a1StallM2W = 1'd0;
			end
			else if(a1Use == aNewM2W) begin
				a1StallD2E = 1'd0;
				a1StallE2M = 1'd0;
				a1StallM2W = (t1Use < tNewM2W);
			end
			else begin
				a1StallD2E = 1'd0;
				a1StallE2M = 1'd0;
				a1StallM2W = 1'd0;
			end
		end
		else begin
			a1StallD2E = 1'd0;
			a1StallE2M = 1'd0;
			a1StallM2W = 1'd0;
		end
		if(a2Use != 0) begin
			if(a2Use == aNewD2E) begin
				a2StallD2E = (t2Use < tNewD2E);
				a2StallE2M = 1'd0;
				a2StallM2W = 1'd0;
			end
			else if(a2Use == aNewE2M) begin
				a2StallD2E = 1'd0;
				a2StallE2M = (t2Use < tNewE2M);
				a2StallM2W = 1'd0;
			end
			else if(a2Use == aNewM2W) begin
				a2StallD2E = 1'd0;
				a2StallE2M = 1'd0;
				a2StallM2W = (t2Use < tNewM2W);
			end
			else begin
				a2StallE2M = 1'd0;
				a2StallD2E = 1'd0;
				a2StallM2W = 1'd0;
			end
		end
		else begin
			a2StallE2M = 1'd0;
			a2StallD2E = 1'd0;
			a2StallM2W = 1'd0;
		end
		mdStall =	(`MFHI_D || `MFLO_D || `MTHI_D || `MTLO_D) && (busyMdE || startMdE);
		a1Stall =	a1StallD2E |	a1StallE2M 	|	a1StallM2W;
		a2Stall = 	a2StallD2E |	a2StallE2M 	| 	a2StallM2W;
		Stall   = 	a1Stall    | 	a2Stall		|	mdStall;
	end
	
	// Fetch (F)
	// Fetch (F)
	
	assign  npcEn  = ~ Stall;
	PC  PC_0(.clk(clk), .reset(reset), .pc(pcF), .npc(npc), .npcEn(npcEn));
	assign  instrF      = i_inst_rdata;
	assign  i_inst_addr = pcF;
	NPC NPC_0(.pc(pcF), .jpc(jpcD), .jpcEn(jpcEnD), .epc(epcM), .epcEn(epcEnM), .req(req), .npc(npc));

	assign	AdEL_F		= (pcF[1:0] != 2'b00) || (pcF < 32'h00003000) || (pcF >= 32'h00007000);
	assign	AdES_F		= 0;
	assign	Syscall_F	= 0;
	assign	RI_F		= 0;
	assign	OV_F		= 0;

	// Fetch to Decode (F2D)
	// Fetch to Decode (F2D)

	always@(posedge clk) begin
		if(reset || req) begin
			ExcCodeF2D	<=	5'd0;
			BD_F2D		<=	5'd0;
		end
		else begin
			if(AdEL_F)			ExcCodeF2D 	<=	`AdEL;
			else if(AdES_F)		ExcCodeF2D	<=	`AdES;
			else if(Syscall_F)	ExcCodeF2D	<=	`Syscall;
			else if(RI_F)		ExcCodeF2D	<=	`RI;
			else if(OV_F)		ExcCodeF2D	<=	`OV;
			else				ExcCodeF2D	<=	5'd0;
			BD_F2D <= (`BEQ_D || `BNE_D || `JAL_D || `JR_D);
		end
	end
	
	always@(posedge clk) begin // pc, instruction
		if(reset || req || (`ERET_D || `ERET_E)) begin
			pcF2D       <= 32'd0;
			instrF2D    <= 32'd0;
		end
		else if(~ Stall) begin
			pcF2D       <= pcF;
			instrF2D    <= instrF;
		end
	end
	
	// Decode (D)
	// Decode (D)

	always@(*) begin // aUse, tUse
		if(`ADD_D || `SUB_D || `AND_D || `OR_D || `SLT_D || `SLTU_D || `MULT_D || `MULTU_D || `DIV_D || `DIVU_D) begin
			a1Use   = instrF2D[`A1];
			t1Use   = 2'd1;
			a2Use   = instrF2D[`A2];
			t2Use   = 2'd1;
		end
		else if(`LB_D || `LH_D || `LW_D || `MTHI_D || `MTLO_D) begin
			a1Use   = instrF2D[`A1];
			t1Use   = 2'd1;
			a2Use   = 5'd0;
			t2Use   = 2'd0;
		end
		else if(`SB_D || `SH_D || `SW_D) begin
			a1Use   = instrF2D[`A1];
			t1Use   = 2'd1;
			a2Use   = instrF2D[`A2];
			t2Use   = 2'd2;
		end
		else if(`ORI_D || `ADDI_D || `ANDI_D) begin
			a1Use   = instrF2D[`A1];
			t1Use   = 2'd1;
			a2Use   = 5'd0;
			t2Use   = 2'd0;
		end
		else if(`BEQ_D || `BNE_D) begin
			a1Use   = instrF2D[`A1];
			t1Use   = 2'd0;
			a2Use   = instrF2D[`A2];
			t2Use   = 2'd0;
		end
		else if(`JR_D) begin
			a1Use   = instrF2D[`A1];
			t1Use   = 2'd0;
			a2Use   = 5'd0;
			t2Use   = 2'd0;
		end
		else if(`MTC0_D) begin
			a1Use   = 5'd0;
			t1Use   = 2'd0;
			a2Use   = instrF2D[`A2];
			t2Use   = 2'd2;
		end
		else begin
			a1Use   = 5'd0;
			t1Use   = 2'd0;
			a2Use   = 5'd0;
			t2Use   = 2'd0;
		end
	end

	assign  a1GrfD  = instrF2D[`A1];
	assign  a2GrfD  = instrF2D[`A2];
	GRF GRF_0(.clk(clk), .reset(reset),
        .a1(a1GrfD), .a2(a2GrfD), .a3(aGrfW),
        .wData(wDataGrfW), .wEn(wEnGrfW),
        .v1(v1GrfD), .v2(v2GrfD));
	assign  w_grf_we    = wEnGrfW;
	assign  w_grf_addr  = aGrfW;
	assign  w_grf_wdata = wDataGrfW;
	assign  w_inst_addr = pcM2W;
	
	assign  a1D     = instrF2D[`A1];
	assign  a2D     = instrF2D[`A2];
	always@(*) begin // trans: v1D, v2D
		if(a1D != 0) begin
			if(a1D == aNewD2E)
				v1D = tNewD2E ? v1GrfD : vNewD2E;
			else if(a1D == aNewE2M)
				v1D = tNewE2M ? v1GrfD : vNewE2M;
			else if(a1D == aNewM2W)
				v1D = tNewM2W ? v1GrfD : vNewM2W;
			else
				v1D = v1GrfD;
		end
		else v1D = v1GrfD;
		if(a2D != 0) begin
			if(a2D == aNewD2E)
				v2D = tNewD2E ? v2GrfD : vNewD2E;
			else if(a2D == aNewE2M)
				v2D = tNewE2M ? v2GrfD : vNewE2M;
			else if(a2D == aNewM2W)
				v2D = tNewM2W ? v2GrfD : vNewM2W;
			else
				v2D = v2GrfD;
		end
		else v2D = v2GrfD;
	end

	always@(*) begin // JPC, JPCEn
		if(`BEQ_D) begin
			jpcD    = pcF + {{14{instrF2D[15]}}, instrF2D[`IMM16], 2'b00}; // following the branch
			jpcEnD  = (v1D == v2D);
		end
		else if(`BNE_D) begin
			jpcD    = pcF + {{14{instrF2D[15]}}, instrF2D[`IMM16], 2'b00}; // following the branch
			jpcEnD  = (v1D != v2D);
		end
		else if(`JAL_D) begin
			jpcD    = {pcF[31:28], instrF2D[`IMM26], 2'b00};
			jpcEnD  = 1'b1;
		end
		else if(`JR_D) begin
			jpcD    = v1D;
			jpcEnD  = 1'b1;
		end
		else begin
			jpcD   = 32'b0;
			jpcEnD = 1'b0;
		end
	end

	always@(*) begin // aNew, tNew, vNew
		if(`ADD_D || `SUB_D || `AND_D || `OR_D || `SLT_D || `SLTU_D || `MFHI_D || `MFLO_D) begin
			aNewD   = instrF2D[`A3];
			tNewD   = 2'd1;
			vNewD   = 32'd0;
		end
		else if(`ORI_D || `ADDI_D || `ANDI_D) begin
			aNewD   = instrF2D[`A2];
			tNewD   = 2'd1;
			vNewD   = 32'd0;
		end
		else if(`LB_D || `LH_D || `LW_D || `MFC0_D) begin
			aNewD   = instrF2D[`A2];
			tNewD   = 2'd2;
			vNewD   = 32'd0;
		end
		else if(`JAL_D) begin
			aNewD   = 5'd31;
			tNewD   = 2'd0;
			vNewD   = pcF2D + 8;
		end
		else if(`LUI_D) begin
			aNewD   = instrF2D[`A2];
			tNewD   = 2'd0;
			vNewD   = {instrF2D[`IMM16], 16'b0};
		end
		else begin
			aNewD   = 5'd0;
			tNewD   = 2'd0;
			vNewD   = 32'd0;
		end
	end

	assign	AdEL_D		= 0;
	assign	AdES_D		= 0;
	assign	Syscall_D	= 0;
	assign	RI_D		= (!`DEF_D);
	assign	OV_D		= 0;

	// Decode to Execute
	// Decode to Execute

	always@(posedge clk) begin
		if(reset || req) begin
			ExcCodeD2E	<=	5'd0;
			BD_D2E		<=	5'd0;
		end
		else if(Stall) begin
			ExcCodeD2E	<=	5'd0;
		end
		else begin
			if(ExcCodeF2D)		ExcCodeD2E	<=	ExcCodeF2D;
			else if(AdEL_D)		ExcCodeD2E 	<=	`AdEL;
			else if(AdES_D)		ExcCodeD2E	<=	`AdES;
			else if(Syscall_D)	ExcCodeD2E	<=	`Syscall;
			else if(RI_D)		ExcCodeD2E	<=	`RI;
			else if(OV_D)		ExcCodeD2E	<=	`OV;
			else				ExcCodeD2E	<=	5'd0;
			BD_D2E		<=	BD_F2D;
		end
	end
	always@(posedge clk) begin // pc, instruction
		if(reset || req) begin
			pcD2E       <= 32'd0;
			instrD2E    <= 32'd0;
		end
		else if(Stall) begin
			instrD2E    <= 32'd0;
		end
		else begin
			pcD2E       <= pcF2D;
			instrD2E    <= instrF2D;
		end
	end
	always@(posedge clk) begin // aNew, tNew, vNew
		if(reset || Stall || req) begin
			aNewD2E     <= 5'd0;
			tNewD2E     <= 2'd0;
			vNewD2E     <= 32'd0;
		end
		else begin
			aNewD2E     <= aNewD;
			tNewD2E     <= tNewD;
			vNewD2E     <= vNewD;
		end
	end
	always@(posedge clk) begin // other register
		if(reset || Stall || req) begin
			v1D2E <= 32'd0;
			v2D2E <= 32'd0;
		end
		else begin
			v1D2E <= v1D;
			v2D2E <= v2D;
		end
	end
	
	// Execute (E)
	// Execute (E)

	assign  a1E     = instrD2E[`A1];
	assign  a2E     = instrD2E[`A2];
	always@(*) begin // trans
		if(a1E != 0) begin
			if(a1E == aNewE2M)
				v1E = tNewE2M ? v1D2E : vNewE2M;
			else if(a1E == aNewM2W)
				v1E = tNewM2W ? v1D2E : vNewM2W;
			else
				v1E = v1D2E;
		end
		else v1E = v1D2E;
		if(a2E != 0) begin
			if(a2E == aNewE2M)
				v2E = tNewE2M ? v2D2E : vNewE2M;
			else if(a2E == aNewM2W)
				v2E = tNewM2W ? v2D2E : vNewM2W;
			else
				v2E = v2D2E;
		end
		else v2E = v2D2E;
	end
	
	assign  v1AluE     = v1E;
	assign  v2AluE     = v2E;
	assign  imm16AluE  = instrD2E[`IMM16];
	always@(*) begin
		if(`ADD_E)
			optAluE	= 4'd0;
		else if(`SUB_E)
			optAluE	= 4'd1;
		else if(`AND_E)
			optAluE	= 4'd2;
		else if(`OR_E)
			optAluE	= 4'd3;
		else if(`ADDI_E)
			optAluE = 4'd4;
		else if(`LB_E || `LH_E || `LW_E || `SB_E || `SH_E || `SW_E)
			optAluE	= 4'd4;
		else if(`ANDI_E)
			optAluE = 4'd6;
		else if(`ORI_E)
			optAluE	= 4'd7;
		else if(`SLT_E)
			optAluE = 4'd8;
		else if(`SLTU_E)
			optAluE = 4'd9;
		else if(`LUI_E)
			optAluE	= 4'd15;
		else
			optAluE	= 4'd0;
	end
	
	assign 	v1MdE	= v1E;
	assign	v2MdE	= v2E;
	always@(*) begin
		optMdE	= 	`MULT_E		?	3'b000 :
					`MULTU_E	?	3'b001 :
					`DIV_E		?	3'b010 :
					`DIVU_E		?	3'b011 :
					`MTHI_E		?   3'b100 :
									3'b101 ;
		startMdE	=	`MULT_E || `MULTU_E || `DIV_E || `DIVU_E || `MTHI_E || `MTLO_E;
	end
	MD MD_0(.clk(clk), .reset(reset),
        .v1(v1MdE), .v2(v2MdE), .opt(optMdE), .start(startMdE),
        .busy(busyMdE), .hi(hiMdE), .lo(loMdE));
	ALU ALU_0(.v1(v1AluE), .v2(v2AluE), .imm16(imm16AluE), .opt(optAluE),
	   .res(resAluE), .ov(ovAluE));
	
	always@(*) begin
		if(`MFHI_E)
			vE = hiMdE;
		else if(`MFLO_E)
			vE = loMdE;
		else
			vE = resAluE;
	end
	always@(*) begin
		if(`ADD_E || `SUB_E || `AND_E || `OR_E || `ORI_E || `SLT_E || `SLTU_E || `ADDI_E || `ANDI_E)
			vNewE = resAluE;
		else if(`MFHI_E)
			vNewE = hiMdE;
		else if(`MFLO_E)
			vNewE = loMdE;
		else
			vNewE = vNewD2E;
	end

	assign	AdEL_E		= (`LB_E || `LH_E || `LW_E) && ovAluE;
	assign	AdES_E		= (`SB_E || `SH_E || `SW_E) && ovAluE;
	assign	Syscall_E	= 0;
	assign	RI_E		= 0;
	assign	OV_E		= (`ADD_E || `ADDI_E || `SUB_E) && ovAluE;

	// Execute to Memory (E2M)
	// Execute to Memory (E2M)

	always@(posedge clk) begin
		if(reset || req) begin
			ExcCodeE2M	<=	5'd0;
			BD_E2M		<=	5'd0;
		end
		else begin
			if(ExcCodeD2E)		ExcCodeE2M	<=	ExcCodeF2D;
			else if(AdEL_E)		ExcCodeE2M 	<=	`AdEL;
			else if(AdES_E)		ExcCodeE2M	<=	`AdES;
			else if(Syscall_E)	ExcCodeE2M	<=	`Syscall;
			else if(RI_E)		ExcCodeE2M	<=	`RI;
			else if(OV_E)		ExcCodeE2M	<=	`OV;
			else				ExcCodeE2M	<=	5'd0;
			BD_E2M		<=	BD_D2E;
		end
	end
	
	always@(posedge clk) begin // pc, instrution
		if(reset || req) begin
			pcE2M     <= 32'd0;
			instrE2M  <= 32'd0;
		end
		else begin
			pcE2M     <= pcD2E;
			instrE2M  <= instrD2E;
		end
	end
	always@(posedge clk) begin // aNew, tNew, vNew
		if(reset || req) begin
			aNewE2M   <= 5'd0;
			tNewE2M   <= 2'd0;
			vNewE2M   <= 32'd0; 
		end
		else begin
			aNewE2M   <= aNewD2E;
			tNewE2M   <= tNewD2E ? tNewD2E - 1 : tNewD2E;
			vNewE2M   <= vNewE;
		end
	end
	always@(posedge clk) begin // other register
		if(reset || req) begin
			v2E2M <= 32'd0;
			vE2M  <= 32'd0;
		end
		else begin
			v2E2M <= v2E;
			vE2M  <= vE;
		end
	end
	
	// Memory (M)
	// Memory (M)

	assign  a2M    = instrE2M[`A2];
	always@(*) begin // trans
		if(a2M != 0) begin
			if(a2M == aNewM2W)
				v2M = tNewM2W ? v2E2M : vNewM2W;
			else
				v2M = v2E2M;
		end
		else v2M = v2E2M;
	end

	assign  aDmM 	= vE2M;
	always@(*) begin
		if(`SB_M) begin
			case(aDmM[1:0])
				2'b00 : begin wByteEnDmM = 4'b0001; wDataDmM = {24'b0, v2M[7:0]};		end
				2'b01 : begin wByteEnDmM = 4'b0010; wDataDmM = {16'b0, v2M[7:0], 8'b0 };end
				2'b10 : begin wByteEnDmM = 4'b0100; wDataDmM = {8'b0, v2M[7:0], 16'b0};	end
				2'b11 : begin wByteEnDmM = 4'b1000; wDataDmM = {v2M[7:0], 24'b0};		end
			endcase
		end
		else if(`SH_M) begin
			case(aDmM[1])
				1'b0 : begin wByteEnDmM = 4'b0011; wDataDmM = {16'b0	, v2M[15:0]};	end
				1'b1 : begin wByteEnDmM = 4'b1100; wDataDmM = {v2M[15:0], 16'b0};		end
			endcase
		end
		else if(`SW_M) begin
			wByteEnDmM 	= 4'b1111;
			wDataDmM	= v2M;
		end
		else begin
			wByteEnDmM	= 4'b0000;
			wDataDmM	= v2M;
		end
	end

	assign  m_data_addr     = aDmM;
	assign  m_data_wdata    = wDataDmM;
	assign  m_data_byteen   = wByteEnDmM;
	assign  m_inst_addr     = pcE2M;

	assign	macroscopic_pc	= pcE2M;

	logic	DM, DEV0, DEV1;
	assign	DM		=	aDmM >= 32'h00000000 && aDmM <= 32'h00002FFF;
	assign	DEV0	=	aDmM >= 32'h00007F00 && aDmM <= 32'h00007F0B;
	assign	DEV1	=	aDmM >= 32'h00007F10 && aDmM <= 32'h00007F1B;
	assign	DEVINT	=	aDmM >= 32'h00007F20 && aDmM <= 32'h00007F23;

	assign	AdEL_M		= 	(`LW_M && (aDmM[1:0] != 2'b00))									// LW 取数地址未与 4 字节对齐。
						||	(`LH_M && (aDmM[0] != 1'b0))									// LH 取数地址未与 2 字节对齐。
						||	((`LB_M || `LH_M) && (DEV0 || DEV1))							// LB, LH 取 Timer 寄存器的值。
						|| 	((`LB_M || `LH_M || `LW_M ) && !(DM || DEV0 || DEV1 || DEVINT));	// 取数地址超出 DM、Timer0、Timer1、中断发生器的范围。
	assign	AdES_M		=	(`SW_M && (aDmM[1:0] != 2'b00))									// SW 存数地址未 4 字节对齐。
						||	(`SH_M && (aDmM[0] != 1'b0))									// SH 存数地址未 2 字节对齐。
						||	((`SB_M || `SH_M) && (DEV0 || DEV1))							// SB, SH 存 Timer 寄存器的值。
						||	(`SW_M && (DEV0 || DEV1) && aDmM[3:2] == 2'b10)					// 向计时器的 Count 寄存器存值。
						||	((`SB_M || `SH_M || `SW_M ) && !(DM || DEV0 || DEV1 || DEVINT));	// 存数地址超出 DM、Timer0、Timer1、中断发生器的范围。
	assign	Syscall_M	= `SYSCALL_M;
	assign	RI_M		= 0;
	assign	OV_M		= 0;
	
	assign	aCP0M		= instrE2M[`A3];
	assign	wDataCP0M	= v2M;
	assign	vpc			= pcE2M;
	assign	BD			= BD_E2M;
	always@(*) begin
		if(ExcCodeE2M)		ExcCodeM	=	ExcCodeE2M;
		else if(AdEL_M)		ExcCodeM	=	`AdEL;
		else if(AdES_M)		ExcCodeM	=	`AdES;
		else if(Syscall_M)	ExcCodeM	=	`Syscall;
		else if(RI_M)		ExcCodeM	=	`RI;
		else if(OV_M)		ExcCodeM	=	`OV;
		else				ExcCodeM	=	5'd0;
	end
	assign	EXLClr	= `ERET_M;
	assign	wEnCP0M	= `MTC0_M;
	assign	epcEmM	= `ERET_M;

	CP0 CP0_0(.clk(clk), .reset(reset),
		.CP0En(wEnCP0M), .CP0Addr(aCP0M), .CP0In(wDataCP0M), .CP0Out(vCP0M),
		.VPC(vpc), .BDIn(BD), .ExcCodeIn(ExcCodeM), .HWInt(HWInt), .EXLClr(EXLClr),
		.EPCOut(epc), .Req(req));

	always@(*) begin
		if(`LB_M)
			vM	= 	aDmM[1:0] 	== 	2'b00 	? 	{{24{m_data_rdata[7]}} , m_data_rdata[7:0]}   : 
					aDmM[1:0] 	== 	2'b01 	? 	{{24{m_data_rdata[15]}}, m_data_rdata[15:8]}  : 
					aDmM[1:0] 	== 	2'b10 	? 	{{24{m_data_rdata[23]}}, m_data_rdata[23:16]} : 
												{{24{m_data_rdata[31]}}, m_data_rdata[31:24]} ;
		else if(`LH_M)
			vM	= 	aDmM[1]		==	1'b0	? 	{{16{m_data_rdata[15]}}, m_data_rdata[15:0]}  :
												{{16{m_data_rdata[31]}}, m_data_rdata[31:16]} ;
		else if(`LW_M)
			vM	= 	m_data_rdata;
		else if(`MFC0_M)
			vM	= 	vCP0M;
		else
			vM	= 	vE2M;
	end

	assign  vNewM = (`LB_M || `LH_M || `LW_M || `MFC0_M) ? vM : vNewE2M;
	
	// Memory to Writeback (M2W)
	// Memory to Writeback (M2W)
	
	always@(posedge clk) begin // pc, instruction
		if(reset || req) begin
			pcM2W     <= 32'd0;
			instrM2W  <= 32'd0;
		end
		else begin
			pcM2W     <= pcE2M;
			instrM2W  <= instrE2M;
		end
	end
	always@(posedge clk) begin // aNew, tNew, vNew
		if(reset || req) begin
			aNewM2W   <= 5'd0;
			tNewM2W   <= 2'd0;
			vNewM2W   <= 32'd0;
		end
		else begin
			aNewM2W   <= aNewE2M;
			tNewM2W   <= tNewE2M ? tNewE2M - 1 : tNewE2M;
			vNewM2W   <= vNewM;
		end
	end
	always@(posedge clk) begin // other register
		if(reset || req)	vM2W  <= 32'd0;
		else				vM2W  <= vM;
	end
	
	// Writeback (W)
	// Writeback (W)
	
	always@(*) begin
		if(`ADD_W || `SUB_W || `AND_W || `OR_W || `SLT_W || `SLTU_W || `MFHI_W || `MFLO_W) begin
			aGrfW      = instrM2W[`A3];
			wDataGrfW  = vM2W;
			wEnGrfW    = 1'b1;
		end
		else if(`ORI_W || `LB_W || `LH_W || `LW_W || `LUI_W || `ADDI_W || `ANDI_W || `MFC0_W) begin
			aGrfW      = instrM2W[`A2];
			wDataGrfW  = vM2W;
			wEnGrfW    = 1'b1;
		end
		else if(`JAL_W) begin
			aGrfW      = 5'd31;
			wDataGrfW  = pcM2W + 8;
			wEnGrfW    = 1'b1; 
		end
		else begin
			aGrfW      = 5'd0;
			wDataGrfW  = 32'd0;
			wEnGrfW    = 1'b0;
		end
	end
endmodule
