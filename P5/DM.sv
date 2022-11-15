`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2022 02:34:46 PM
// Design Name: 
// Module Name: DM
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


module DM(
    input   [31:0]  pc,
    input   clk, reset,
    input   [13:2]  a,
    input   [31:0]  wData,
    input           wEn,
    output  [31:0]  v
    );
    logic   [31:0]  ram[4095:0];
    assign  v   = ram[a];

    always@(posedge clk) begin
        if(reset) begin
            for(integer i = 0; i <= 4095; i = i + 1)
                ram[i] <= 0;
        end
        else begin
            if(wEn) begin
                ram[a]  <= wData;
                $display("%d@%h: *00000%h <= %h", $time, pc, a << 2, wData);
            end
        end
    end
    
endmodule
