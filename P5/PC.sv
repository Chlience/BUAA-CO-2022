`timescale 1ns / 1ps
`include "MACRO.sv"

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2022 12:11:37 PM
// Design Name: 
// Module Name: PC
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

module PC(
    input   clk,
    input   reset,
    input   npcEn,
    input   [31:0]  npc,
    output  [31:0]  pc
    );
    
    logic   [31:0]  pcReg;
    
    always@(posedge clk) begin
        if(reset) begin
            pcReg <= `PCInitial;
        end
        else if(npcEn) begin
            pcReg <= npc;
        end
    end
    
    assign pc = pcReg;
endmodule
