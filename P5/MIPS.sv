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
    
    logic   STACK;
    
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
    
    // instruction fetch to register read
    logic   [31:0]  pcIF2RR;
    logic   [31:0]  instrIF2RR;
    
    always@(posedge clk) begin
        pcIF2RR     <= pcIF;
        instrIF2RR  <= instrIF;
    end
    
    // Register Read (RR)
    // Register Read (RR)
    
    logic   [1:0]   Tuse[`ATNUM - 1:0];
    logic   [4:0]   Ause[`ATNUM - 1:0];
    always@(*) begin
        if(`ADD_RR) begin
            Tuse[0] = 2'd1;
            Tuse[1] = 2'd1;
            Ause[0] = instrIF2RR[25:21];
            Ause[1] = instrIF2RR[20:16];
        end
        else begin
            Tuse[0] = 2'd0;
            Tuse[1] = 2'd0;
            Ause[0] = 5'd0;
            Ause[1] = 5'd0;
        end
    end
    /*
    ADD STALL and TRANS
    */
    
    logic   [4:0]   a1GrfRR;
    logic   [4:0]   a2GrfRR;
    logic   [31:0]  v1GrfRR;
    logic   [31:0]  v2GrfRR;
    
    assign  a1GrfRR = instrIF2RR[25:21];
    assign  a2GrfRR = instrIF2RR[20:16];
    
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
    
    logic   [1:0]   TnewRR;
    logic   [4:0]   AnewRR;
    logic   [31:0]  VnewRR;
    always@(*) begin
        if(`ADD_RR) begin
            TnewRR = 2'd2;
            AnewRR = instrIF2RR[15:11];
            VnewRR = 32'd0;
        end
        else begin
            TnewRR = 2'd0;
            AnewRR = 5'd0;
            VnewRR = 32'd0;
        end
    end
    
    // register read to execute
    logic   [31:0]  pcRR2EX;
    logic   [31:0]  instrRR2EX;
    always@(posedge clk) begin
        pcRR2EX     <= pcIF2RR;
        instrRR2EX  <= instrIF2RR;
    end
    logic   [1:0]   TnewRR2EX;
    logic   [4:0]   AnewRR2EX;
    logic   [31:0]  VnewRR2EX;
    always@(posedge clk) begin
        TnewRR2EX <= TnewRR ? TnewRR - 1 : 0;
        AnewRR2EX <= AnewRR;
        VnewRR2EX <= VnewRR;
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
    
    logic   [1:0]   TnewEX;
    logic   [4:0]   AnewEX;
    logic   [31:0]  VnewEX;
    always@(*) begin
        TnewEX = TnewRR2EX;
        AnewEX = AnewRR2EX;
        if(`ADD_EX)
            VnewEX = resAluEX;
        else
            VnewEX = VnewRR2EX;
    end
    
    // Execute to Data Memory (EX2DM)
    
    logic   [31:0]  pcEX2DM;
    logic   [31:0]  instrEX2DM;
    always@(posedge clk) begin
        pcEX2DM     <= pcRR2EX;
        instrEX2DM  <= instrRR2EX;
    end
    logic   [1:0]   TnewEX2DM;
    logic   [4:0]   AnewEX2DM;
    logic   [31:0]  VnewEX2DM;
    always@(posedge clk) begin
        TnewEX2DM <= TnewEX ? TnewEX - 1 : 0;
        AnewEX2DM <= AnewEX;
        VnewEX2DM <= VnewEX;
    end
    
    logic   [31:0]  vEX2DM;
    always@(posedge clk) begin
        vEX2DM  <= resAluEX;
    end
    
    // Data Memory (DM)
    // Data Memory (DM)
    
    logic   [1:0]   TnewDM;
    logic   [4:0]   AnewDM;
    logic   [31:0]  VnewDM;
    always@(*) begin
        TnewDM = TnewEX2DM;
        AnewDM = AnewEX2DM;
        VnewDM = VnewEX2DM;
    end
    
    // Data Memory to Register Write (DM2RW)
    /* Declare move to RR
    logic   [31:0]  pcDM2RW; */
    logic   [31:0]  instrDM2RW;
    always@(posedge clk) begin
        pcDM2RW     <= pcEX2DM;
        instrDM2RW  <= instrEX2DM;
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
endmodule
