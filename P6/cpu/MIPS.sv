`timescale 1ns / 1ps
`include "MACRO.sv"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2022 11:57:01 AM
// Design Name: 
// Module Name: mips
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
module mips(
	input   clk,
	input   reset,
	
	output  [31:0]  i_inst_addr,
	input   [31:0]  i_inst_rdata,
	
	input   [31:0]  m_data_rdata,
	output  [31:0]  m_data_addr,
	output  [31:0]  m_data_wdata,
	output  [3:0]   m_data_byteen,
	
	output  [31:0]  m_inst_addr,
	
	output          w_grf_we,
	output  [4:0]   w_grf_addr,
	output  [31:0]  w_grf_wdata,

	output  [31:0]  w_inst_addr
	);
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
		if(`MULT_D || `MULTU_D || `DIV_D || `DIVU_D || `MFHI_D || `MFLO_D || `MTHI_D || `MTLO_D) begin
			mdStall = startMdE || busyMdE;
		end
		else
			mdStall = 1'd0;
		a1Stall =	a1StallD2E |	a1StallE2M 	|	a1StallM2W;
		a2Stall = 	a2StallD2E |	a2StallE2M 	| 	a2StallM2W;
		Stall   = 	a1Stall    | 	a2Stall		|	mdStall;
	end
	
	// Fetch (F)
	// Fetch (F)
	
	logic   [31:0]  pcF;
	logic   [31:0]  npcF;
	logic   [31:0]  instrF;
	logic   npcEnF;
	assign  npcEnF  = ~ Stall;

	logic   [31:0]  jpcD;
	logic           jpcEnD;
	
	PC  PC_0(.clk(clk), .reset(reset), .pc(pcF), .npc(npcF), .npcEn(npcEnF));
	assign  instrF      = i_inst_rdata;
	assign  i_inst_addr = pcF;
	NPC NPC_0(.pc(pcF), .jpc(jpcD), .jpcEn(jpcEnD), .npc(npcF));
	
	// Fetch to Decode
	// Fetch to Decode
	
	logic   [31:0]  pcF2D;
	logic   [31:0]  instrF2D;
	always@(posedge clk) begin // pc, instruction
		if(reset) begin
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
		if(`ADD_D || `SUB_D || `AND_D || `OR_D || `SLT_D || `MULT_D || `MULTU_D || `DIV_D || `DIVU_D) begin
			a1Use   = instrF2D[`A1];
			t1Use   = 2'd1;
			a2Use   = instrF2D[`A2];
			t2Use   = 2'd1;
		end
		else if(`LB_D || `LH_D || `LW_D || `SLTI_D || `MTHI_D || `MTLO_D) begin
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
		else begin
			a1Use   = 5'd0;
			t1Use   = 2'd0;
			a2Use   = 5'd0;
			t2Use   = 2'd0;
		end
	end

	logic   [4:0]   a1GrfD;
	logic   [4:0]   a2GrfD;
	assign  a1GrfD  = instrF2D[`A1];
	assign  a2GrfD  = instrF2D[`A2];
	
	// W declare move here
	logic   [4:0]   aGrfW;
	logic   [31:0]  wDataGrfW;
	logic           wEnGrfW;
	logic   [31:0]  pcM2W;
	
	logic   [31:0]  v1GrfD;
	logic   [31:0]  v2GrfD;

	GRF GRF_0(.clk(clk), .reset(reset),
	.a1(a1GrfD), .a2(a2GrfD), .a3(aGrfW),
	.wData(wDataGrfW), .wEn(wEnGrfW),
	.v1(v1GrfD), .v2(v2GrfD));
	assign  w_grf_we    = wEnGrfW;
	assign  w_grf_addr  = aGrfW;
	assign  w_grf_wdata = wDataGrfW;
	assign  w_inst_addr = pcM2W;
	
	logic   [4:0]   a1D, a2D;
	logic   [31:0]  v1D, v2D;
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

	/* Declare move to F
	logic   [31:0]  jpcD;
	logic           jpcEnD;
	*/
	always@(*) begin
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

	logic   [4:0]   aNewD;
	logic   [1:0]   tNewD;
	logic   [31:0]  vNewD;
	always@(*) begin // aNew, tNew, vNew
		if(`ADD_D || `SUB_D || `AND_D || `OR_D || `SLT_D || `MFHI_D || `MFLO_D) begin
			aNewD   = instrF2D[`A3];
			tNewD   = 2'd1;
			vNewD   = 32'd0;
		end
		else if(`ORI_D || `SLTI_D || `ADDI_D || `ANDI_D) begin
			aNewD   = instrF2D[`A2];
			tNewD   = 2'd1;
			vNewD   = 32'd0;
		end
		else if(`LB_D || `LH_D || `LW_D) begin
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
	
	// Decode to Execute
	// Decode to Execute
	
	logic   [31:0]  pcD2E;
	logic   [31:0]  instrD2E;
	always@(posedge clk) begin // pc, instruction
		if(reset || Stall) begin
			pcD2E       <= 32'd0;
			instrD2E    <= 32'd0;
		end
		else begin
			pcD2E       <= pcF2D;
			instrD2E    <= instrF2D;
		end
	end
	always@(posedge clk) begin // aNew, tNew, vNew
		if(reset || Stall) begin
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
	logic   [31:0]  v1D2E;
	logic   [31:0]  v2D2E;
	always@(posedge clk) begin // other register
		if(reset || Stall) begin
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

	logic   [4:0]   a1E, a2E;
	logic   [31:0]  v1E, v2E;
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
	
	logic   [31:0]  v1AluE;
	logic   [31:0]  v2AluE;
	logic   [15:0]  imm16AluE;
	assign  v1AluE     = v1E;
	assign  v2AluE     = v2E;
	assign  imm16AluE  = instrD2E[`IMM16];
	logic   [3:0]   optAluE;
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
		else if(`SLTI_E)
			optAluE	= 4'd9;
		else if(`LUI_E)
			optAluE	= 4'd15;
		else
			optAluE	= 4'd0;
	end
	
	logic	[31:0]	v1MdE;
	logic	[31:0]	v2MdE;
	assign 	v1MdE	= v1E;
	assign	v2MdE	= v2E;
	logic	[2:0]	optMdE;
	logic			startMdE;
	always@(*) begin
		optMdE		= 	`MULT_E		?	3'b000 :
						`MULTU_E	?	3'b001 :
						`DIV_E		?	3'b010 :
						`DIVU_E		?	3'b011 :
						`MTHI_E		?   3'b100 :
										3'b101 ;
		startMdE	=	`MULT_E || `MULTU_E || `DIV_E || `DIVU_E || `MTHI_E || `MTLO_E;
	end
	logic			busyMdE;
	logic	[31:0]	hiMdE;
	logic	[31:0]	loMdE;
	MD MD_0(.clk(clk), .reset(reset),
	.v1(v1MdE), .v2(v2MdE), .opt(optMdE), .start(startMdE),
	.busy(busyMdE), .hi(hiMdE), .lo(loMdE));

	logic   [31:0]  resAluE;
	ALU ALU_0(.v1(v1AluE), .v2(v2AluE), .imm16(imm16AluE), .opt(optAluE),
	.res(resAluE)/*, .overf()*/);
	
	logic 	[31:0] 	vE;
	always@(*) begin
		if(`ADD_E || `SUB_E || `AND_E || `OR_E || `ORI_E || `SLT_E || `SLTI_E || `ADDI_E || `ANDI_E)
			vE = resAluE;
		else if(`MFHI_E)
			vE = hiMdE;
		else if(`MFLO_E)
			vE = loMdE;
		else
			vE = resAluE;
	end

	logic   [31:0]  vNewE;
	always@(*) begin
		if(`ADD_E || `SUB_E || `AND_E || `OR_E || `ORI_E || `SLT_E || `SLTI_E || `ADDI_E || `ANDI_E)
			vNewE = resAluE;
		else if(`MFHI_E)
			vNewE = hiMdE;
		else if(`MFLO_E)
			vNewE = loMdE;
		else
			vNewE = vNewD2E;
	end
	
	// Execute to Memory (E2M)
	// Execute to Memory (E2M)
	
	logic   [31:0]  pcE2M;
	logic   [31:0]  instrE2M;
	always@(posedge clk) begin // pc, instrution
		if(reset) begin
			pcE2M     <= 32'd0;
			instrE2M  <= 32'd0;
		end
		else begin
			pcE2M     <= pcD2E;
			instrE2M  <= instrD2E;
		end
	end
	always@(posedge clk) begin // aNew, tNew, vNew
		if(reset) begin
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
	logic   [31:0]  v2E2M;
	logic   [31:0]  vE2M;
	always@(posedge clk) begin // other register
		if(reset) begin
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

	logic   [4:0]   a2M;
	logic   [31:0]  v2M;
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

	logic   [31:0]  aDmM;
	logic   [31:0]  wDataDmM;
	assign  aDmM        = vE2M;
	assign  wDataDmM    = v2M;
	logic   [3:0]   wByteEnDmM;
	always@(*) begin
		if(`SB_W)
			wByteEnDmM 	= aDmM[1:0] == 	2'b00 ? 4'b0001 :
										2'b01 ? 4'b0010 :
										2'b10 ? 4'b0100 :
												4'b1000;
		else if(`SH_W)
			wByteEnDmM 	= aDmM[1]	==	1'b0  ? 4'b0011 :
												4'b1100 ;
		else if(`SW_M)
			wByteEnDmM = 4'b1111;
		else
			wByteEnDmM = 4'b0000;
	end

	assign  m_data_addr     = aDmM;
	assign  m_data_wdata    = wDataDmM;
	assign  m_data_byteen   = wByteEnDmM;
	assign  m_inst_addr     = pcE2M;

	logic   [31:0]  vM;
	always@(*) begin
		if(`LB_M)
			vM	= aDmM[1:0] == 	2'b00 ? {{16{m_data_rdata[7]}} , m_data_rdata[7:0]}   : 
								2'b01 ? {{16{m_data_rdata[15]}}, m_data_rdata[15:8]}  : 
								2'b10 ? {{16{m_data_rdata[23]}}, m_data_rdata[23:16]} : 
										{{16{m_data_rdata[31]}}, m_data_rdata[31:24]} ;
		else if(`LH_M)
			vM	= aDmM[1]	==	1'b0  ? {{8{m_data_rdata[15]}} , m_data_addr[15:0]}   :
										{{8{m_data_rdata[31]}} , m_data_addr[31:16]}  ;
		else if(`LB_M)
			vM	= m_data_addr;
		else
			vM	= vE2M;
	end

	logic   [31:0]  vNewM;
	assign  vNewM = (`LB_M || `LH_M || `LW_M) ? vM : vNewE2M;
	
	// Memory to Writeback (M2W)
	// Memory to Writeback (M2W)
	
	/* Declare move to D
	logic   [31:0]  pcM2W; */
	logic   [31:0]  instrM2W;
	always@(posedge clk) begin // pc, instruction
		if(reset) begin
			pcM2W     <= 32'd0;
			instrM2W  <= 32'd0;
		end
		else begin
			pcM2W     <= pcE2M;
			instrM2W  <= instrE2M;
		end
	end
	always@(posedge clk) begin // aNew, tNew, vNew
		if(reset) begin
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
	logic   [31:0]  vM2W;
	always@(posedge clk) begin // other register
		if(reset)
			vM2W  <= 32'd0;
		else
			vM2W  <= vM;
	end
	
	// Writeback (W)
	// Writeback (W)
	
	/* Declare move to D
	logic   [4:0]   aGrfW;
	logic   [31:0]  wDataGrfW;
	logic           wEnGrfW; */
	always@(*) begin
		if(`ADD_W || `SUB_W || `AND_W || `OR_W || `SLT_W || `MFHI_W || `MFLO_W) begin
			aGrfW      = instrM2W[`A3];
			wDataGrfW  = vM2W;
			wEnGrfW    = 1'b1;
		end
		else if(`ORI_W || `LB_W || `LH_W || `LW_W || `LUI_W || `SLTI_W || `ADDI_W || `ANDI_W) begin
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