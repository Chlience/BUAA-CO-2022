`define PCInitial   (32'h00003000)
`define A1          25:21
`define A2          20:16
`define A3          15:11
`define IMM16       15:0
`define IMM26       25:0

`define OPTION1     31:26
`define OPTION2     5:0
`define SPECIAL     (6'b000000)

`define ADD         (6'b100000)    // special
`define ADD_F      ((instrF[`OPTION1]    == `SPECIAL) && (instrF[`OPTION2]    == `ADD))     
`define ADD_D      ((instrF2D[`OPTION1] == `SPECIAL) && (instrF2D[`OPTION2] == `ADD))
`define ADD_E      ((instrD2E[`OPTION1] == `SPECIAL) && (instrD2E[`OPTION2] == `ADD))
`define ADD_M      ((instrE2M[`OPTION1] == `SPECIAL) && (instrE2M[`OPTION2] == `ADD))
`define ADD_W      ((instrM2W[`OPTION1] == `SPECIAL) && (instrM2W[`OPTION2] == `ADD))

`define SUB         (6'b100010)    // special
`define SUB_F      ((instrF[`OPTION1]    == `SPECIAL) && (instrF[`OPTION2]    == `SUB))     
`define SUB_D      ((instrF2D[`OPTION1] == `SPECIAL) && (instrF2D[`OPTION2] == `SUB))
`define SUB_E      ((instrD2E[`OPTION1] == `SPECIAL) && (instrD2E[`OPTION2] == `SUB))
`define SUB_M      ((instrE2M[`OPTION1] == `SPECIAL) && (instrE2M[`OPTION2] == `SUB))
`define SUB_W      ((instrM2W[`OPTION1] == `SPECIAL) && (instrM2W[`OPTION2] == `SUB))

`define LW          (6'b100011)
`define LW_F       (instrF[`OPTION1]    == `LW)
`define LW_D       (instrF2D[`OPTION1] == `LW)
`define LW_E       (instrD2E[`OPTION1] == `LW)
`define LW_M       (instrE2M[`OPTION1] == `LW)
`define LW_W       (instrM2W[`OPTION1] == `LW)

`define SW          (6'b101011)
`define SW_F       (instrF[`OPTION1]    == `SW)
`define SW_D       (instrF2D[`OPTION1] == `SW)
`define SW_E       (instrD2E[`OPTION1] == `SW)
`define SW_M       (instrE2M[`OPTION1] == `SW)
`define SW_W       (instrM2W[`OPTION1] == `SW)

`define ORI         (6'b001101)
`define ORI_F      (instrF[`OPTION1]    == `ORI)
`define ORI_D      (instrF2D[`OPTION1] == `ORI)
`define ORI_E      (instrD2E[`OPTION1] == `ORI)
`define ORI_M      (instrE2M[`OPTION1] == `ORI)
`define ORI_W      (instrM2W[`OPTION1] == `ORI)

`define BEQ         (6'b000100)
`define BEQ_F      (instrF[`OPTION1]    == `BEQ)
`define BEQ_D      (instrF2D[`OPTION1] == `BEQ)
`define BEQ_E      (instrD2E[`OPTION1] == `BEQ)
`define BEQ_M      (instrE2M[`OPTION1] == `BEQ)
`define BEQ_W      (instrM2W[`OPTION1] == `BEQ)

`define JAL         (6'b000011)
`define JAL_F      (instrF[`OPTION1]    == `JAL)
`define JAL_D      (instrF2D[`OPTION1] == `JAL)
`define JAL_E      (instrD2E[`OPTION1] == `JAL)
`define JAL_M      (instrE2M[`OPTION1] == `JAL)
`define JAL_W      (instrM2W[`OPTION1] == `JAL)

`define JR         (6'b001000)    // special
`define JR_F      ((instrF[`OPTION1]    == `SPECIAL) && (instrF[`OPTION2]    == `JR))     
`define JR_D      ((instrF2D[`OPTION1] == `SPECIAL) && (instrF2D[`OPTION2] == `JR))
`define JR_E      ((instrD2E[`OPTION1] == `SPECIAL) && (instrD2E[`OPTION2] == `JR))
`define JR_M      ((instrE2M[`OPTION1] == `SPECIAL) && (instrE2M[`OPTION2] == `JR))
`define JR_W      ((instrM2W[`OPTION1] == `SPECIAL) && (instrM2W[`OPTION2] == `JR))

`define LUI         (6'b001111)
`define LUI_F      (instrF[`OPTION1]    == `LUI)
`define LUI_D      (instrF2D[`OPTION1] == `LUI)
`define LUI_E      (instrD2E[`OPTION1] == `LUI)
`define LUI_M      (instrE2M[`OPTION1] == `LUI)
`define LUI_W      (instrM2W[`OPTION1] == `LUI)