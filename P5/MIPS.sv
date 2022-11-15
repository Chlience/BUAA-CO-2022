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
    
    always@(*) begin // Stall
        if(a1UseRR != 0) begin
            if(a1UseRR == aNewEX) begin
                a1StallEX = (t1UseRR < tNewEX);
                a1StallDM = 1'd0;
                a1StallRW = 1'd0;
            end if(a1UseRR == aNewDM) begin
                a1StallEX = 1'd0;    
                a1StallDM = (t1UseRR < tNewDM);
                a1StallRW = 1'd0;
            end if(a1UseRR == aNewRW) begin
                a1StallDM = 1'd0;
                a1StallEX = 1'd0;
                a1StallRW = (t1UseRR < tNewRW);
            end
            else begin
                a1StallDM = 1'd0;
                a1StallEX = 1'd0;
                a1StallRW = 1'd0;
            end
        end
        else begin
            a1StallDM = 1'd0;
            a1StallEX = 1'd0;
            a1StallRW = 1'd0;
        end
        if(a2UseRR != 0) begin
            if(a2UseRR == aNewEX) begin
                a2StallEX = (t2UseRR < tNewEX);
                a2StallDM = 1'd0;
                a2StallRW = 1'd0;
            end if(a2UseRR == aNewDM) begin
                a2StallEX = 1'd0;
                a2StallDM = (t2UseRR < tNewDM);
                a2StallRW = 1'd0;
            end if(a2UseRR == aNewRW) begin
                a2StallEX = 1'd0;
                a2StallDM = 1'd0;
                a2StallRW = (t2UseRR < tNewRW);
            end
            else begin
                a2StallDM = 1'd0;
                a2StallEX = 1'd0;
                a2StallRW = 1'd0;
            end
        end
        else begin
            a2StallDM = 1'd0;
            a2StallEX = 1'd0;
            a2StallRW = 1'd0;
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
    assign  npcEnIF = ~ Stall;
    
    PC  PC_0(.clk(clk), .reset(reset), .pc(pcIF), .npc(npcIF), .npcEn(npcEnIF));
    IM  IM_0(.pc(pcIF), .instr(instrIF));
    NPC NPC_0(.pc(pcIF), .npc(npcIF));
    
    // Instruction Fetch TO Register Read
    // Instruction Fetch TO Register Read
    
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
    
    always@(*) begin
        if(`ADD_RR || `SUB_RR) begin
            a1UseRR = instrIF2RR[`A1];
            a2UseRR = instrIF2RR[`A2];
            t1UseRR = 2'd1;
            t2UseRR = 2'd1;
        end
        else if(`LW_RR) begin
            a1UseRR = instrIF2RR[`A1];
            a2UseRR = 5'd0;
            t1UseRR = 2'd1;
            t2UseRR = 2'd0;
        end
        else if(`SW_RR) begin
            a1UseRR = instrIF2RR[`A1];
            a2UseRR = instrIF2RR[`A2];
            t1UseRR = 2'd1;
            t2UseRR = 2'd2;
        end
        else if(`ORI_RR) begin
            a1UseRR = instrIF2RR[`A1];
            a2UseRR = 5'd0;
            t1UseRR = 2'd1;
            t2UseRR = 2'd0;
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
    always@(*) begin // trans
        if(a1RR != 0) begin
            if(a1RR == aNewEX) begin
                if(tNewEX == 0)
                    v1RR = vNewEX;
                else
                    v1RR = v1GrfRR;
            end
            else if(a1RR == aNewDM) begin
                if(tNewDM == 0)
                    v1RR = vNewDM;
                else
                    v1RR = v1GrfRR;
            end
            else if(a1RR == aNewRW) begin
                if(tNewRW == 0)
                    v1RR = vNewRW;
                else
                    v1RR = v1GrfRR;
            end
            else v1RR = v1GrfRR;
        end
        else v1RR = v1GrfRR;
        if(a2RR != 0) begin
            if(a2RR == aNewEX) begin
                if(tNewEX == 0)
                    v2RR = vNewEX;
                else
                    v2RR = v2GrfRR;
            end
            else if(a2RR == aNewDM) begin
                if(tNewDM == 0)
                    v2RR = vNewDM;
                else
                    v2RR = v2GrfRR;
            end
            else if(a2RR == aNewRW) begin
                if(tNewRW == 0)
                    v2RR = vNewRW;
                else
                    v2RR = v2GrfRR;
            end
            else v2RR    = v2GrfRR;
        end
        else v2RR = v2GrfRR;
    end

    always@(*) begin
        if(`ADD_RR || `SUB_RR) begin
            aNewRR  = instrIF2RR[`A3];
            tNewRR  = 2'd1;
            vNewRR  = 32'd0;
        end
        else if(`ORI_RR) begin
            aNewRR  = instrIF2RR[`A2];
            tNewRR  = 2'd1;
            vNewRR  = 32'd0;
        end
        else if(`LW_RR) begin
            aNewRR  = instrIF2RR[`A2];
            tNewRR  = 2'd2;
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
    logic   [4:0]   aNewRR2EX;
    logic   [1:0]   tNewRR2EX;
    logic   [31:0]  vNewRR2EX;
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
            if(a1EX == aNewDM) begin
                if(tNewDM == 0)
                    v1EX = vNewDM;
                else
                    v1EX = v1RR2EX;
            end
            else if(a1EX == aNewRW) begin
                if(tNewRW == 0)
                    v1EX = vNewRW;
                else
                    v1EX = v1RR2EX;
            end
            else v1EX = v1RR2EX;
        end
        else v1EX = v1RR2EX;
        if(a2EX != 0) begin
            if(a2EX == aNewDM) begin
                if(tNewDM == 0)
                    v2EX = vNewDM;
                else
                    v2EX = v2RR2EX;
            end
            else if(a2EX == aNewRW) begin
                if(tNewRW == 0)
                    v2EX = vNewRW;
                else
                    v2EX = v2RR2EX;
            end
            else v2EX = v2RR2EX;
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
        if(`ADD_EX) begin
            optAluEX    = 4'd0;
        end
        else if(`SUB_EX) begin
            optAluEX    = 4'd1;
        end
        else if(`ORI_EX) begin
            optAluEX    = 4'd3;
        end
        else if(`LW_EX || `SW_EX) begin
            optAluEX    = 4'd4;
        end
        else if(`LUI_EX) begin
            optAluEX    = 4'd15;
        end
        else begin
            optAluEX    = 4'd0;
        end
    end
    
    logic   [31:0]  resAluEX;
    ALU ALU_0(.v1(v1AluEX), .v2(v2AluEX), .imm16(imm16AluEX), .opt(optAluEX),
    .res(resAluEX)/*, .overf()*/);
    
    always@(*) begin
        aNewEX = aNewRR2EX;
        tNewEX = tNewRR2EX;
        if(`ADD_EX || `SUB_EX || `ORI_EX)
            vNewEX  = resAluEX;
        else
            vNewEX  = vNewRR2EX;
    end
    
    // Execute to Data Memory (EX2DM)
    
    logic   [31:0]  pcEX2DM;
    logic   [31:0]  instrEX2DM;
    always@(posedge clk) begin // pc, instrution
        if(reset || Stall) begin
            pcEX2DM     <= 32'd0;
            instrEX2DM  <= 32'd0;
        end
        else begin
            pcEX2DM     <= pcRR2EX;
            instrEX2DM  <= instrRR2EX;
        end
    end
    logic   [4:0]   aNewEX2DM;
    logic   [1:0]   tNewEX2DM;
    logic   [31:0]  vNewEX2DM;
    always@(posedge clk) begin // aNew, tNew, vNew
        if(reset || Stall) begin
            aNewEX2DM   <= 5'd0;
            tNewEX2DM   <= 2'd0;
            vNewEX2DM   <= 32'd0; 
        end
        else begin
            aNewEX2DM   <= aNewEX;
            tNewEX2DM   <= tNewEX ? tNewEX - 1 : tNewEX;
            vNewEX2DM   <= vNewEX;
        end
    end
    logic   [31:0]  v2EX2DM;
    logic   [31:0]  vEX2DM;
    always@(posedge clk) begin // other register
        if(reset || Stall) begin
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
            if(a2DM == aNewRW) begin
                if(tNewRW == 0)
                    v2DM = vNewRW;
                else
                    v2DM = v2EX2DM;
            end
            else v2DM = v2EX2DM;
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
    always@(*) begin
        if(`LW_DM)
            vDM = vDMDM;
        else
            vDM = vEX2DM;
    end

    always@(*) begin
        aNewDM  = aNewEX2DM;
        tNewDM  = tNewEX2DM;
        if(`LW_DM)
            vNewDM  = vDMDM;
        else
            vNewDM  = vNewEX2DM;
    end
    
    // Data Memory to Register Write (DM2RW)
    // Data Memory to Register Write (DM2RW)
    
    /* Declare move to RR
    logic   [31:0]  pcDM2RW; */
    logic   [31:0]  instrDM2RW;
    always@(posedge clk) begin // pc, instruction
        if(reset || Stall) begin
            pcDM2RW     <= 32'd0;
            instrDM2RW  <= 32'd0;
        end
        else begin
            pcDM2RW     <= pcEX2DM;
            instrDM2RW  <= instrEX2DM;
        end
    end
    logic   [4:0]   aNewDM2RW;
    logic   [1:0]   tNewDM2RW;
    logic   [31:0]  vNewDM2RW;
    always@(posedge clk) begin // aNew, tNew, vNew
        if(reset || Stall) begin
            aNewDM2RW   <= 5'd0;
            tNewDM2RW   <= 2'd0;
            vNewDM2RW   <= 32'd0;
        end
        else begin
            aNewDM2RW   <= aNewDM;
            tNewDM2RW   <= tNewDM ? tNewDM - 1 : tNewDM;
            vNewDM2RW   <= vNewDM;
        end
    end
    logic   [31:0]  vDM2RW;
    always@(posedge clk) begin // other register
        if(reset || Stall)
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
    
    always@(*) begin
        aNewRW  = aNewDM2RW;
        tNewRW  = tNewDM2RW;
        vNewRW  = vNewDM2RW;
    end
endmodule
