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


module MIPS_TB();
    logic   clk;
    logic   reset;
    MIPS uut(
        .clk(clk),
        .reset(reset)
    );
    initial begin
        clk = 0;
        reset = 1;
        #12; // phase: 2ns
        reset = 0;
    end
    
    always #5 clk = ~clk; // 10ns for a circle
endmodule
