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
    output  [31:0]  npc
    );
    assign npc = jpcEn ? jpc : (pc + 32'h00000004);
endmodule
