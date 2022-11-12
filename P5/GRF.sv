`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2022 02:04:13 PM
// Design Name: 
// Module Name: GRF
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

module GRF(
    input   clk,
    input   reset,
    input   [4:0]   a1, //register address
    input   [4:0]   a2,
    input   [4:0]   a3,
    input   [31:0]  wData,
    input           wEn,
    input   [31:0]  pc,
    output  [31:0]  v1, //register value
    output  [31:0]  v2
    );
    
    logic   [31:0]  regReg[31:0];
        
    assign  v1  =   regReg[a1];
    assign  v2  =   regReg[a2];
    
    always@(posedge clk) begin
        if(reset) begin
            for(integer i = 0; i <= 31; i = i + 1)
                regReg[i]   <= 32'h00000000;
        end
        else begin
            if(wEn && (a3 != 5'b00000)) begin
                regReg[a3]  <= wData;
                $display("%d@%h: $%d <= %h", $time, pc, a3, wData);
            end
        end
    end
endmodule
