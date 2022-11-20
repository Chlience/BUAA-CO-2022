`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2022 01:28:41 PM
// Design Name: 
// Module Name: NPC
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


module NPC(
	input   [31:0]  pc,
	input   [31:0]  jpc,
	input           jpcEn,
	input   [31:0]  epc,
	input           epcEn,
	input 			req,
	output  [31:0]  npc
	);
	logic	[31:0]	NPC;
	assign	npc = NPC;
	always@(*) begin
		if(req)			NPC = 32'h00004180;
		else if(epcEn)	NPC = epc;
		else if(jpcEn)	NPC = jpc;
		else			NPC = pc + 32'h00000004;
	end
endmodule
