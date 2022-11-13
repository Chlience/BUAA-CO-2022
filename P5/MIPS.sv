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
module MIPS(
    input   clk,
    input   reset
    );
    
    // AT Stall
    // AT Stall
    
    logic   [4:0]   a1UseRR, a2UseRR;
    logic   [1:0]   t1UseRR, t2UseRR;
    logic   [4:0]   aNewRR, aNewEX, aNewDM, aNewRW;
    logic   [1:0]   tNewRR, tNewEX, tNewDM, tNewRW;
    logic   [31:0]  vNewRR, vNewEX, vNewDM, vNewRW;
    
    logic   Stall;
    logic   a1Stall, a2Stall;
    logic   a1StallEX, a2StallEX;
    logic   a1StallDM, a2StallDM;
    logic   a1StallRW, a2StallRW;
    
    always@(*) begin
        if(a1UseRR != 0) begin
            if(a1UseRR == aNewEX) begin
                a1StallEX = (t1UseRR > tNewEX);
                a1StallDM = 1'd0;
                a1StallRW = 1'd0;
            end if(a1UseRR == aNewDM) begin
                a1StallEX = 1'd0;    
                a1StallDM = (t1UseRR > tNewDM);
                a1StallRW = 1'd0;
            end if(a1UseRR == aNewRW) begin
                a1StallDM = 1'd0;
                a1StallEX = 1'd0;
                a1StallRW = (t1UseRR > tNewRW);
            end
            else begin
                a1StallDM = 1'd0;
                a1StallEX = 1'd0;
                a1StallRW = 1'd0;
            end
        end
        if(a2UseRR != 0) begin
            if(a2UseRR == aNewEX) begin
                a2StallEX = (t2UseRR > tNewEX);
                a2StallDM = 1'd0;
                a2StallRW = 1'd0;
            end if(a2UseRR == aNewDM) begin
                a2StallEX = 1'd0;
                a2StallDM = (t2UseRR > tNewDM);
                a2StallRW = 1'd0;
            end if(a2UseRR == aNewRW) begin
                a2StallEX = 1'd0;
                a2StallDM = 1'd0;
                a2StallRW = (t2UseRR > tNewRW);
            end
            else begin
                a2StallDM = 1'd0;
                a2StallEX = 1'd0;
                a2StallRW = 1'd0;
            end
        end
        a1Stall = a1StallEX | a1StallDM | a1StallRW;
        a2Stall = a2StallEX | a2StallDM | a2StallRW;
        Stall   = a1Stall   | a2Stall;
    end
    
    // Instrution Fetch (IF)
    // Instrution Fetch (IF)
    
    logic   [31:0]  pcIF;
    logic   [31:0]  npcIF;
    logic   [31:0]  instrIF;
    logic   npcEnIF;
    assign  npcEnIF = 1;
    
    PC  PC_0(.clk(clk), .reset(reset), .pc(pcIF), .npc(npcIF), .npcEn(npcEnIF));
    IM  IM_0(.pc(pcIF), .instr(instrIF));
    NPC NPC_0(.pc(pcIF), .npc(npcIF));
    
    // Instruction Fetch TO Register Read
    // Instruction Fetch TO Register Read
    
    logic   [31:0]  pcIF2RR;
    logic   [31:0]  instrIF2RR;
    always@(posedge clk) begin
        pcIF2RR     <= pcIF;
        instrIF2RR  <= instrIF;
    end
    logic   [4:0]   a1IF2RR;
    logic   [4:0]   a2IF2RR;
    always@(posedge clk) begin
        a1IF2RR     <= instrIF[`A1];
        a2IF2RR     <= instrIF[`A2];
    end
    
    // Register Read (RR)
    // Register Read (RR)
    
    always@(*) begin
        if(`ADD_RR) begin
            a1UseRR = a1IF2RR;
            a2UseRR = a2IF2RR;
            t1UseRR = 2'd1;
            t2UseRR = 2'd1;
        end
        else begin
            a1UseRR = 5'd0;
            a2UseRR = 5'd0;
            t1UseRR = 2'd0;
            t2UseRR = 2'd0;
        end
    end
    
    logic   [4:0]   a1GrfRR;
    logic   [4:0]   a2GrfRR;
    logic   [31:0]  v1GrfRR;
    logic   [31:0]  v2GrfRR;
    assign  a1GrfRR = a1IF2RR;
    assign  a2GrfRR = a2IF2RR;
    
    // RW declare move here
    logic           wEnGrfRW;
    logic   [4:0]   aGrfRW;
    logic   [31:0]  vGrfRW;
    logic   [31:0]  pcDM2RW;
    
    GRF GRF_0(.clk(clk), .reset(reset),
    .a1(a1GrfRR), .a2(a2GrfRR), .a3(aGrfRW),
    .wData(vGrfRW), .wEn(wEnGrfRW),
    .v1(v1GrfRR), .v2(v2GrfRR),
    .pc(pcDM2RW));
    
    always@(*) begin
        if(`ADD_RR) begin
            aNewRR  = instrIF2RR[`A3];
            tNewRR  = 2'd1;
            vNewRR  = 32'd0;
        end
        else begin
            aNewRR  = 5'd0;
            tNewRR  = 2'd0;
            vNewRR  = 32'd0;
        end
    end
    
    // Register Read TO Execute
    // Register Read TO Execute
    
    logic   [31:0]  pcRR2EX;
    logic   [31:0]  instrRR2EX;
    always@(posedge clk) begin
        pcRR2EX     <= pcIF2RR;
        instrRR2EX  <= instrIF2RR;
    end
    logic   [4:0]   aNewRR2EX;
    logic   [1:0]   tNewRR2EX;
    logic   [31:0]  vNewRR2EX;
    always@(posedge clk) begin
        aNewRR2EX   <= aNewRR;
        tNewRR2EX   <= tNewRR ? tNewRR - 1 : tNewRR;
        vNewRR2EX   <= vNewRR;
    end
    logic   [31:0]  v1RR2EX;
    logic   [31:0]  v2RR2EX;
    always@(posedge clk) begin
        v1RR2EX <= v1GrfRR;
        v2RR2EX <= v2GrfRR;
    end
    
    // Execute (EX)
    // Execute (EX)
    
    logic   [31:0]  v1AluEX;
    logic   [31:0]  v2AluEX;
    logic   [15:0]  immAluEX;
    assign  v1AluEX     = v1RR2EX;
    assign  v2AluEX     = v2RR2EX;
    assign  immAluEX    = instrRR2EX[15:0];
    logic   [3:0]   optAluEX;
    always@(*) begin
        if(`ADD_EX) begin
            optAluEX    = 4'd0;
        end
        else if(`LUI_EX) begin
            optAluEX    = 4'd2;
        end
        else begin
            optAluEX    = 4'd0;
        end
    end
    
    logic   [31:0]  resAluEX;
    ALU ALU_0(.v1(v1AluEX), .v2(v2AluEX), .imm(immAluEX), .opt(optAluEX),
    .res(resAluEX)/*, .overf()*/);
    
    always@(*) begin
        aNewEX = aNewRR2EX;
        tNewEX = tNewRR2EX;
        if(`ADD_EX) begin
            vNewEX  = resAluEX;
        end
        else begin
            vNewEX  = vNewRR2EX;
        end
    end
    
    // Execute to Data Memory (EX2DM)
    
    logic   [31:0]  pcEX2DM;
    logic   [31:0]  instrEX2DM;
    always@(posedge clk) begin
        pcEX2DM     <= pcRR2EX;
        instrEX2DM  <= instrRR2EX;
    end
    logic   [4:0]   aNewEX2DM;
    logic   [1:0]   tNewEX2DM;
    logic   [31:0]  vNewEX2DM;
    always@(posedge clk) begin
        aNewEX2DM   <= aNewEX;
        tNewEX2DM   <= tNewEX ? tNewEX - 1 : tNewEX;
        vNewEX2DM   <= vNewEX;
    end
    logic   [31:0]  vEX2DM;
    always@(posedge clk) begin
        vEX2DM  <= resAluEX;
    end
    
    // Data Memory (DM)
    // Data Memory (DM)
    
    always@(*) begin
        aNewDM  = aNewEX2DM;
        tNewDM  = tNewEX2DM;
        vNewDM  = vNewEX2DM;
    end
    
    // Data Memory to Register Write (DM2RW)
    // Data Memory to Register Write (DM2RW)
    
    /* Declare move to RR
    logic   [31:0]  pcDM2RW; */
    logic   [31:0]  instrDM2RW;
    always@(posedge clk) begin
        pcDM2RW     <= pcEX2DM;
        instrDM2RW  <= instrEX2DM;
    end
    logic   [4:0]   aNewDM2RW;
    logic   [1:0]   tNewDM2RW;
    logic   [31:0]  vNewDM2RW;
    always@(posedge clk) begin
        aNewDM2RW   <= aNewDM;
        tNewDM2RW   <= tNewDM ? tNewDM - 1 : tNewDM;
        vNewDM2RW   <= vNewDM;
    end
    logic   [31:0]  vDM2RW;
    always@(posedge clk) begin
        vDM2RW  <= vEX2DM;
    end
    
    // Register Write (RW)
    // Register Write (RW)
    
    /* Declare move to RR
    logic   [4:0]   aGrfRW;
    logic   [31:0]  vGrfRW;
    logic           wEnGrfRW; */
    always@(*) begin
        if(`ADD_RW) begin
            aGrfRW      = instrDM2RW[15:11];
            vGrfRW      = vDM2RW;
            wEnGrfRW    = 1'b1;
        end
        else if(`LUI_RW) begin
            aGrfRW      = instrDM2RW[20:16];
            vGrfRW      = vDM2RW;
            wEnGrfRW    = 1'b1;
        end
        else begin
            aGrfRW      = instrDM2RW[20:16];
            vGrfRW      = vDM2RW;
            wEnGrfRW    = 1'b0;
        end
    end
    
    always@(*) begin
        aNewRW  = aNewDM2RW;
        tNewRW  = tNewDM2RW;
        vNewRW  = vNewDM2RW;
    end
endmodule
