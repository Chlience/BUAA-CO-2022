`timescale 1ns / 1ps
`include "MACRO.sv"

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2022 12:38:52 PM
// Design Name: 
// Module Name: IM
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

module IM(
    input   [31:0] pc,
    output  [31:0] instr
    );
    logic   [31:0] instrReg[4096];
    logic   [31:0] pcSub;
    
    assign pcSub = pc - `PCInitial;
    assign instr = instrReg[pcSub[13:2]];
    initial begin
        for(integer i = 0; i <= 4095; i = i + 1)
            instrReg[i] = 0;
        $readmemh("/home/chlience/cscore/BUAA-CO/P5/data/code.txt", instrReg);
    end

endmodule
