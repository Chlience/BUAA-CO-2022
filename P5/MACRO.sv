`define PCInitial   (32'h00003000)
`define A1          25:21
`define A2          20:16
`define A3          15:11
`define IMM16       15:0

`define OPTION1     31:26
`define OPTION2     5:0
`define SPECIAL     (6'b000000)

`define ADD         (6'b100000)    // special
`define ADD_IF      ((instrIF[`OPTION1]    == `SPECIAL) && (instrIF[`OPTION2]    == `ADD))     
`define ADD_RR      ((instrIF2RR[`OPTION1] == `SPECIAL) && (instrIF2RR[`OPTION2] == `ADD))
`define ADD_EX      ((instrRR2EX[`OPTION1] == `SPECIAL) && (instrRR2EX[`OPTION2] == `ADD))
`define ADD_DM      ((instrEX2DM[`OPTION1] == `SPECIAL) && (instrEX2DM[`OPTION2] == `ADD))
`define ADD_RW      ((instrDM2RW[`OPTION1] == `SPECIAL) && (instrDM2RW[`OPTION2] == `ADD))

`define SUB         (6'b100010)    // special
`define SUB_IF      ((instrIF[`OPTION1]    == `SPECIAL) && (instrIF[`OPTION2]    == `SUB))     
`define SUB_RR      ((instrIF2RR[`OPTION1] == `SPECIAL) && (instrIF2RR[`OPTION2] == `SUB))
`define SUB_EX      ((instrRR2EX[`OPTION1] == `SPECIAL) && (instrRR2EX[`OPTION2] == `SUB))
`define SUB_DM      ((instrEX2DM[`OPTION1] == `SPECIAL) && (instrEX2DM[`OPTION2] == `SUB))
`define SUB_RW      ((instrDM2RW[`OPTION1] == `SPECIAL) && (instrDM2RW[`OPTION2] == `SUB))

`define LW          (6'b100011)
`define LW_IF       (instrIF[`OPTION1]    == `LW)
`define LW_RR       (instrIF2RR[`OPTION1] == `LW)
`define LW_EX       (instrRR2EX[`OPTION1] == `LW)
`define LW_DM       (instrEX2DM[`OPTION1] == `LW)
`define LW_RW       (instrDM2RW[`OPTION1] == `LW)

`define SW          (6'b101011)
`define SW_IF       (instrIF[`OPTION1]    == `SW)
`define SW_RR       (instrIF2RR[`OPTION1] == `SW)
`define SW_EX       (instrRR2EX[`OPTION1] == `SW)
`define SW_DM       (instrEX2DM[`OPTION1] == `SW)
`define SW_RW       (instrDM2RW[`OPTION1] == `SW)

`define LUI         (6'b001111)
`define LUI_IF      (instrIF[`OPTION1]    == `LUI)
`define LUI_RR      (instrIF2RR[`OPTION1] == `LUI)
`define LUI_EX      (instrRR2EX[`OPTION1] == `LUI)
`define LUI_DM      (instrEX2DM[`OPTION1] == `LUI)
`define LUI_RW      (instrDM2RW[`OPTION1] == `LUI)

`define ORI         (6'b001101)
`define ORI_IF      (instrIF[`OPTION1]    == `ORI)
`define ORI_RR      (instrIF2RR[`OPTION1] == `ORI)
`define ORI_EX      (instrRR2EX[`OPTION1] == `ORI)
`define ORI_DM      (instrEX2DM[`OPTION1] == `ORI)
`define ORI_RW      (instrDM2RW[`OPTION1] == `ORI)
