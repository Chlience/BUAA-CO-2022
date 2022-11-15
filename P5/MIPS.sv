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
    
    logic   [4:0]   a1Use, a2Use;
    logic   [1:0]   t1Use, t2Use;
    logic   [4:0]   aNewRR2EX, aNewEX2DM, aNewDM2RW;
    logic   [1:0]   tNewRR2EX, tNewEX2DM, tNewDM2RW;
    logic   [31:0]  vNewRR2EX, vNewEX2DM, vNewDM2RW;
    
    logic   Stall;
    logic   a1Stall, a2Stall;
    logic   a1StallRR2EX, a2StallRR2EX;
    logic   a1StallEX2DM, a2StallEX2DM;
    logic   a1StallDM2RW, a2StallDM2RW;
    
    always@(*) begin // Stall
        if(a1Use != 0) begin
            if(a1Use == aNewRR2EX) begin
                $display("%d", (t1Use < tNewRR2EX));
                a1StallRR2EX = (t1Use < tNewRR2EX);
                a1StallEX2DM = 1'd0;
                a1StallDM2RW = 1'd0;
            end
            else if(a1Use == aNewEX2DM) begin
                a1StallRR2EX = 1'd0;    
                a1StallEX2DM = (t1Use < tNewEX2DM);
                a1StallDM2RW = 1'd0;
            end
            else if(a1Use == aNewDM2RW) begin
                a1StallRR2EX = 1'd0;
                a1StallEX2DM = 1'd0;
                a1StallDM2RW = (t1Use < tNewDM2RW);
            end
            else begin
                a1StallRR2EX = 1'd0;
                a1StallEX2DM = 1'd0;
                a1StallDM2RW = 1'd0;
            end
        end
        else begin
            a1StallRR2EX = 1'd0;
            a1StallEX2DM = 1'd0;
            a1StallDM2RW = 1'd0;
        end
        if(a2Use != 0) begin
            if(a2Use == aNewRR2EX) begin
                a2StallRR2EX = (t2Use < tNewRR2EX);
                a2StallEX2DM = 1'd0;
                a2StallDM2RW = 1'd0;
            end
            else if(a2Use == aNewEX2DM) begin
                a2StallRR2EX = 1'd0;
                a2StallEX2DM = (t2Use < tNewEX2DM);
                a2StallDM2RW = 1'd0;
            end
            else if(a2Use == aNewDM2RW) begin
                a2StallRR2EX = 1'd0;
                a2StallEX2DM = 1'd0;
                a2StallDM2RW = (t2Use < tNewDM2RW);
            end
            else begin
                a2StallEX2DM = 1'd0;
                a2StallRR2EX = 1'd0;
                a2StallDM2RW = 1'd0;
            end
        end
        else begin
            a2StallEX2DM = 1'd0;
            a2StallRR2EX = 1'd0;
            a2StallDM2RW = 1'd0;
        end
        a1Stall = a1StallRR2EX | a1StallEX2DM | a1StallDM2RW;
        a2Stall = a2StallRR2EX | a2StallEX2DM | a2StallDM2RW;
        Stall   = a1Stall   | a2Stall;
    end
    
    // Instrution Fetch (IF)
    // Instrution Fetch (IF)
    
    logic   [31:0]  pcIF;
    logic   [31:0]  npcIF;
    logic   [31:0]  instrIF;
    logic   npcEnIF;
    assign  npcEnIF = ~ Stall;
    
    PC  PC_0(.clk(clk), .reset(reset), .pc(pcIF), .npc(npcIF), .npcEn(npcEnIF));
    IM  IM_0(.pc(pcIF), .instr(instrIF));
    NPC NPC_0(.pc(pcIF), .npc(npcIF));
    
    // Instruction Fetch to Register Read
    // Instruction Fetch to Register Read
    
    logic   [31:0]  pcIF2RR;
    logic   [31:0]  instrIF2RR;
    always@(posedge clk) begin // pc, instruction
        if(reset) begin
            pcIF2RR     <= 32'd0;
            instrIF2RR  <= 32'd0;
        end
        else if(~ Stall) begin
            pcIF2RR     <= pcIF;
            instrIF2RR  <= instrIF;
        end
    end
    
    // Register Read (RR)
    // Register Read (RR)
    
    always@(*) begin // aUse, tUse
        if(`ADD_RR || `SUB_RR) begin
            a1Use = instrIF2RR[`A1];
            a2Use = instrIF2RR[`A2];
            t1Use = 2'd1;
            t2Use = 2'd1;
        end
        else if(`LW_RR) begin
            a1Use = instrIF2RR[`A1];
            a2Use = 5'd0;
            t1Use = 2'd1;
            t2Use = 2'd0;
        end
        else if(`SW_RR) begin
            a1Use = instrIF2RR[`A1];
            a2Use = instrIF2RR[`A2];
            t1Use = 2'd1;
            t2Use = 2'd2;
        end
        else if(`ORI_RR) begin
            a1Use = instrIF2RR[`A1];
            a2Use = 5'd0;
            t1Use = 2'd1;
            t2Use = 2'd0;
        end
        else begin
            a1Use = 5'd0;
            a2Use = 5'd0;
            t1Use = 2'd0;
            t2Use = 2'd0;
        end
    end

    logic   [4:0]   a1GrfRR;
    logic   [4:0]   a2GrfRR;
    assign  a1GrfRR = instrIF2RR[`A1];
    assign  a2GrfRR = instrIF2RR[`A2];
    
    // RW declare move here
    logic   [4:0]   aGrfRW;
    logic   [31:0]  wDataGrfRW;
    logic           wEnGrfRW;
    logic   [31:0]  pcDM2RW;
    
    logic   [31:0]  v1GrfRR;
    logic   [31:0]  v2GrfRR;
    GRF GRF_0(.clk(clk), .reset(reset),
    .a1(a1GrfRR), .a2(a2GrfRR), .a3(aGrfRW),
    .wData(wDataGrfRW), .wEn(wEnGrfRW),
    .v1(v1GrfRR), .v2(v2GrfRR),
    .pc(pcDM2RW));
    
    logic   [4:0]   a1RR, a2RR;
    logic   [31:0]  v1RR, v2RR;
    assign  a1RR    = instrIF2RR[`A1];
    assign  a2RR    = instrIF2RR[`A2];
    always@(*) begin // trans: v1RR, v2RR
        if(a1RR != 0) begin
            if(a1RR == aNewRR2EX)
                v1RR = tNewRR2EX ? v1GrfRR : vNewRR2EX;
            else if(a1RR == aNewEX2DM)
                v1RR = tNewEX2DM ? v1GrfRR : vNewEX2DM;
            else if(a1RR == aNewDM2RW)
                v1RR = tNewDM2RW ? v1GrfRR : vNewDM2RW;
            else
                v1RR = v1GrfRR;
        end
        else v1RR = v1GrfRR;
        if(a2RR != 0) begin
            if(a2RR == aNewRR2EX)
                v2RR = tNewRR2EX ? v2GrfRR : vNewRR2EX;
            else if(a2RR == aNewEX2DM)
                v2RR = tNewEX2DM ? v2GrfRR : vNewEX2DM;
            else if(a2RR == aNewDM2RW)
                v2RR = tNewDM2RW ? v2GrfRR : vNewDM2RW;
            else
                v2RR = v2GrfRR;
        end
        else v2RR = v2GrfRR;
    end

    logic   [4:0]   aNewRR;
    logic   [1:0]   tNewRR;
    logic   [31:0]  vNewRR;
    always@(*) begin // aNew, tNew, vNew
        if(`ADD_RR || `SUB_RR) begin
            aNewRR  = instrIF2RR[`A3];
            tNewRR  = 2'd2;
            vNewRR  = 32'd0;
        end
        else if(`ORI_RR) begin
            aNewRR  = instrIF2RR[`A2];
            tNewRR  = 2'd2;
            vNewRR  = 32'd0;
        end
        else if(`LW_RR) begin
            aNewRR  = instrIF2RR[`A2];
            tNewRR  = 2'd3;
            vNewRR  = 32'd0;
        end
        else begin
            aNewRR  = 5'd0;
            tNewRR  = 2'd0;
            vNewRR  = 32'd0;
        end
    end
    
    // Register Read to Execute
    // Register Read to Execute
    
    logic   [31:0]  pcRR2EX;
    logic   [31:0]  instrRR2EX;
    always@(posedge clk) begin // pc, instruction
        if(reset || Stall) begin
            pcRR2EX     <= 32'd0;
            instrRR2EX  <= 32'd0;
        end
        else begin
            pcRR2EX     <= pcIF2RR;
            instrRR2EX  <= instrIF2RR;
        end
    end
    always@(posedge clk) begin // aNew, tNew, vNew
        if(reset || Stall) begin
            aNewRR2EX   <= 5'd0;
            tNewRR2EX   <= 2'd0;
            vNewRR2EX   <= 32'd0;
        end
        else begin
            aNewRR2EX   <= aNewRR;
            tNewRR2EX   <= tNewRR ? tNewRR - 1 : tNewRR;
            vNewRR2EX   <= vNewRR;
        end
    end
    logic   [31:0]  v1RR2EX;
    logic   [31:0]  v2RR2EX;
    always@(posedge clk) begin // other register
        if(reset || Stall) begin
            v1RR2EX <= 32'd0;
            v2RR2EX <= 32'd0;
        end
        else begin
            v1RR2EX <= v1RR;
            v2RR2EX <= v2RR;
        end
    end
    
    // Execute (EX)
    // Execute (EX)

    logic   [4:0]   a1EX, a2EX;
    logic   [31:0]  v1EX, v2EX;
    assign  a1EX    = instrRR2EX[`A1];
    assign  a2EX    = instrRR2EX[`A2];
    always@(*) begin // trans
        if(a1EX != 0) begin
            if(a1EX == aNewEX2DM)
                v1EX = tNewEX2DM ? v1RR2EX : vNewEX2DM;
            else if(a1EX == aNewDM2RW)
                v1EX = tNewDM2RW ? v1RR2EX : vNewDM2RW;
            else
                v1EX = v1RR2EX;
        end
        else v1EX = v1RR2EX;
        if(a2EX != 0) begin
            if(a2EX == aNewEX2DM)
                v2EX = tNewEX2DM ? v2RR2EX : vNewEX2DM;
            else if(a2EX == aNewDM2RW)
                v2EX = tNewDM2RW ? v2RR2EX : vNewDM2RW;
            else
                v2EX = v2RR2EX;
        end
        else v2EX = v2RR2EX;
    end
    
    logic   [31:0]  v1AluEX;
    logic   [31:0]  v2AluEX;
    logic   [15:0]  imm16AluEX;
    assign  v1AluEX     = v1EX;
    assign  v2AluEX     = v2EX;
    assign  imm16AluEX  = instrRR2EX[`IMM16];
    logic   [3:0]   optAluEX;
    always@(*) begin
        if(`ADD_EX)
            optAluEX    = 4'd0;
        else if(`SUB_EX)
            optAluEX    = 4'd1;
        else if(`ORI_EX)
            optAluEX    = 4'd3;
        else if(`LW_EX || `SW_EX)
            optAluEX    = 4'd4;
        else if(`LUI_EX)
            optAluEX    = 4'd15;
        else
            optAluEX    = 4'd0;
    end
    
    logic   [31:0]  resAluEX;
    ALU ALU_0(.v1(v1AluEX), .v2(v2AluEX), .imm16(imm16AluEX), .opt(optAluEX),
    .res(resAluEX)/*, .overf()*/);
    
    logic   [31:0]  vNewEX;
    assign  vNewEX  = (`ADD_EX || `SUB_EX || `ORI_EX) ? resAluEX : vNewRR2EX;
    
    // Execute to Data Memory (EX2DM)
    // Execute to Data Memory (EX2DM)
    
    logic   [31:0]  pcEX2DM;
    logic   [31:0]  instrEX2DM;
    always@(posedge clk) begin // pc, instrution
        if(reset) begin
            pcEX2DM     <= 32'd0;
            instrEX2DM  <= 32'd0;
        end
        else begin
            pcEX2DM     <= pcRR2EX;
            instrEX2DM  <= instrRR2EX;
        end
    end
    always@(posedge clk) begin // aNew, tNew, vNew
        if(reset) begin
            aNewEX2DM   <= 5'd0;
            tNewEX2DM   <= 2'd0;
            vNewEX2DM   <= 32'd0; 
        end
        else begin
            aNewEX2DM   <= aNewRR2EX;
            tNewEX2DM   <= tNewRR2EX ? tNewRR2EX - 1 : tNewRR2EX;
            vNewEX2DM   <= vNewEX;
        end
    end
    logic   [31:0]  v2EX2DM;
    logic   [31:0]  vEX2DM;
    always@(posedge clk) begin // other register
        if(reset) begin
            v2EX2DM <= 32'd0;
            vEX2DM  <= 32'd0;
        end
        else begin
            v2EX2DM <= v2EX;
            vEX2DM  <= resAluEX;
        end
    end
    
    // Data Memory (DM)
    // Data Memory (DM)

    logic   [4:0]   a2DM;
    logic   [31:0]  v2DM;
    assign  a2DM    = instrEX2DM[`A2];
    always@(*) begin // trans
        if(a2DM != 0) begin
            if(a2DM == aNewDM2RW)
                v2DM = tNewDM2RW ? v2EX2DM : vNewDM2RW;
            else
                v2DM = v2EX2DM;
        end
        else v2DM = v2EX2DM;
    end

    logic   [31:0]  aDMDM;
    logic   [31:0]  wDataDMDM;
    assign  aDMDM       = vEX2DM;
    assign  wDataDMDM   = v2DM;
    logic           wEnDMDM;
    always@(*) begin
        if(`SW_DM)
            wEnDMDM = 1'b1;
        else
            wEnDMDM = 1'b0;
    end
    logic   [31:0]  vDMDM;
    DM DM_0(.clk(clk), .reset(reset),
    .a(aDMDM[13:2]), .wData(wDataDMDM), .wEn(wEnDMDM),
    .v(vDMDM), .pc(pcEX2DM)
    );

    logic   [31:0]  vDM;
    assign  vDM = (`LW_DM) ? vDMDM : vEX2DM;
    
    logic   [31:0]  vNewDM;
    assign  vNewDM = (`LW_DM) ? vDMDM : vNewEX2DM;
    
    // Data Memory to Register Write (DM2RW)
    // Data Memory to Register Write (DM2RW)
    
    /* Declare move to RR
    logic   [31:0]  pcDM2RW; */
    logic   [31:0]  instrDM2RW;
    always@(posedge clk) begin // pc, instruction
        if(reset) begin
            pcDM2RW     <= 32'd0;
            instrDM2RW  <= 32'd0;
        end
        else begin
            pcDM2RW     <= pcEX2DM;
            instrDM2RW  <= instrEX2DM;
        end
    end
    always@(posedge clk) begin // aNew, tNew, vNew
        if(reset) begin
            aNewDM2RW   <= 5'd0;
            tNewDM2RW   <= 2'd0;
            vNewDM2RW   <= 32'd0;
        end
        else begin
            aNewDM2RW   <= aNewEX2DM;
            tNewDM2RW   <= tNewEX2DM ? tNewEX2DM - 1 : tNewEX2DM;
            vNewDM2RW   <= vNewDM;
        end
    end
    logic   [31:0]  vDM2RW;
    always@(posedge clk) begin // other register
        if(reset)
            vDM2RW  <= 32'd0;
        else
            vDM2RW  <= vDM;
    end
    
    // Register Write (RW)
    // Register Write (RW)
    
    /* Declare move to RR
    logic   [4:0]   aGrfRW;
    logic   [31:0]  wDataGrfRW;
    logic           wEnGrfRW; */
    always@(*) begin
        if(`ADD_RW || `SUB_RW) begin
            aGrfRW      = instrDM2RW[`A3];
            wDataGrfRW  = vDM2RW;
            wEnGrfRW    = 1'b1;
        end
        else if(`ORI_RW || `LW_RW || `LUI_RW ) begin
            aGrfRW      = instrDM2RW[`A2];
            wDataGrfRW  = vDM2RW;
            wEnGrfRW    = 1'b1;
        end
        else begin
            aGrfRW      = 5'd0;
            wDataGrfRW  = 32'd0;
            wEnGrfRW    = 1'b0;
        end
    end
endmodule
