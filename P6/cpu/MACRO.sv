`define PCInitial   (32'h00003000)
`define A1          25:21
`define A2          20:16
`define A3          15:11
`define IMM16       15:0
`define IMM26		25:0

`define OPTION1     31:26
`define OPTION2     5:0
`define SPECIAL     (6'b000000)

`define ADD			(6'b100000)    // special
`define ADD_F		((instrF[`OPTION1]   == `SPECIAL) && (instrF[`OPTION2]   == `ADD))     
`define ADD_D		((instrF2D[`OPTION1] == `SPECIAL) && (instrF2D[`OPTION2] == `ADD))
`define ADD_E		((instrD2E[`OPTION1] == `SPECIAL) && (instrD2E[`OPTION2] == `ADD))
`define ADD_M		((instrE2M[`OPTION1] == `SPECIAL) && (instrE2M[`OPTION2] == `ADD))
`define ADD_W		((instrM2W[`OPTION1] == `SPECIAL) && (instrM2W[`OPTION2] == `ADD))

`define SUB			(6'b100010)    // special
`define SUB_F		((instrF[`OPTION1]   == `SPECIAL) && (instrF[`OPTION2]   == `SUB))     
`define SUB_D		((instrF2D[`OPTION1] == `SPECIAL) && (instrF2D[`OPTION2] == `SUB))
`define SUB_E		((instrD2E[`OPTION1] == `SPECIAL) && (instrD2E[`OPTION2] == `SUB))
`define SUB_M		((instrE2M[`OPTION1] == `SPECIAL) && (instrE2M[`OPTION2] == `SUB))
`define SUB_W		((instrM2W[`OPTION1] == `SPECIAL) && (instrM2W[`OPTION2] == `SUB))

`define AND		 	(6'b100100)
`define AND_F		((instrF[`OPTION1]   == `SPECIAL) && (instrF[`OPTION2]   == `AND))     
`define AND_D		((instrF2D[`OPTION1] == `SPECIAL) && (instrF2D[`OPTION2] == `AND))
`define AND_E		((instrD2E[`OPTION1] == `SPECIAL) && (instrD2E[`OPTION2] == `AND))
`define AND_M		((instrE2M[`OPTION1] == `SPECIAL) && (instrE2M[`OPTION2] == `AND))
`define AND_W		((instrM2W[`OPTION1] == `SPECIAL) && (instrM2W[`OPTION2] == `AND))

`define OR		 	(6'b100101)
`define OR_F		((instrF[`OPTION1]   == `SPECIAL) && (instrF[`OPTION2]   == `OR))     
`define OR_D		((instrF2D[`OPTION1] == `SPECIAL) && (instrF2D[`OPTION2] == `OR))
`define OR_E		((instrD2E[`OPTION1] == `SPECIAL) && (instrD2E[`OPTION2] == `OR))
`define OR_M		((instrE2M[`OPTION1] == `SPECIAL) && (instrE2M[`OPTION2] == `OR))
`define OR_W		((instrM2W[`OPTION1] == `SPECIAL) && (instrM2W[`OPTION2] == `OR))

`define SLT		 	(6'b101010)
`define SLT_F		((instrF[`OPTION1]   == `SPECIAL) && (instrF[`OPTION2]   == `SLT))     
`define SLT_D		((instrF2D[`OPTION1] == `SPECIAL) && (instrF2D[`OPTION2] == `SLT))
`define SLT_E		((instrD2E[`OPTION1] == `SPECIAL) && (instrD2E[`OPTION2] == `SLT))
`define SLT_M		((instrE2M[`OPTION1] == `SPECIAL) && (instrE2M[`OPTION2] == `SLT))
`define SLT_W		((instrM2W[`OPTION1] == `SPECIAL) && (instrM2W[`OPTION2] == `SLT))

`define SLTI		(6'b001010)
`define SLTI_F		(instrF[`OPTION1]   == `SLTI)
`define SLTI_D		(instrF2D[`OPTION1] == `SLTI)
`define SLTI_E		(instrD2E[`OPTION1] == `SLTI)
`define SLTI_M		(instrE2M[`OPTION1] == `SLTI)
`define SLTI_W		(instrM2W[`OPTION1] == `SLTI)

`define ADDI		(6'b001000)
`define ADDI_F		(instrF[`OPTION1]   == `ADDI)
`define ADDI_D		(instrF2D[`OPTION1] == `ADDI)
`define ADDI_E		(instrD2E[`OPTION1] == `ADDI)
`define ADDI_M		(instrE2M[`OPTION1] == `ADDI)
`define ADDI_W		(instrM2W[`OPTION1] == `ADDI)

`define ANDI		(6'b001100)
`define ANDI_F		(instrF[`OPTION1]   == `ANDI)
`define ANDI_D		(instrF2D[`OPTION1] == `ANDI)
`define ANDI_E		(instrD2E[`OPTION1] == `ANDI)
`define ANDI_M		(instrE2M[`OPTION1] == `ANDI)
`define ANDI_W		(instrM2W[`OPTION1] == `ANDI)

`define ORI			(6'b001101)
`define ORI_F		(instrF[`OPTION1]   == `ORI)
`define ORI_D		(instrF2D[`OPTION1] == `ORI)
`define ORI_E		(instrD2E[`OPTION1] == `ORI)
`define ORI_M		(instrE2M[`OPTION1] == `ORI)
`define ORI_W		(instrM2W[`OPTION1] == `ORI)

`define BEQ			(6'b000100)
`define BEQ_F		(instrF[`OPTION1]   == `BEQ)
`define BEQ_D		(instrF2D[`OPTION1] == `BEQ)
`define BEQ_E		(instrD2E[`OPTION1] == `BEQ)
`define BEQ_M		(instrE2M[`OPTION1] == `BEQ)
`define BEQ_W		(instrM2W[`OPTION1] == `BEQ)

`define BNE			(6'b000101)
`define BNE_F		(instrF[`OPTION1]   == `BNE)
`define BNE_D		(instrF2D[`OPTION1] == `BNE)
`define BNE_E		(instrD2E[`OPTION1] == `BNE)
`define BNE_M		(instrE2M[`OPTION1] == `BNE)
`define BNE_W		(instrM2W[`OPTION1] == `BNE)

`define JAL			(6'b000011)
`define JAL_F		(instrF[`OPTION1]   == `JAL)
`define JAL_D		(instrF2D[`OPTION1] == `JAL)
`define JAL_E		(instrD2E[`OPTION1] == `JAL)
`define JAL_M		(instrE2M[`OPTION1] == `JAL)
`define JAL_W		(instrM2W[`OPTION1] == `JAL)

`define JR			(6'b001000)    // special
`define JR_F		((instrF[`OPTION1]   == `SPECIAL) && (instrF[`OPTION2]   == `JR))     
`define JR_D		((instrF2D[`OPTION1] == `SPECIAL) && (instrF2D[`OPTION2] == `JR))
`define JR_E		((instrD2E[`OPTION1] == `SPECIAL) && (instrD2E[`OPTION2] == `JR))
`define JR_M		((instrE2M[`OPTION1] == `SPECIAL) && (instrE2M[`OPTION2] == `JR))
`define JR_W		((instrM2W[`OPTION1] == `SPECIAL) && (instrM2W[`OPTION2] == `JR))

`define LUI			(6'b001111)
`define LUI_F		(instrF[`OPTION1]   == `LUI)
`define LUI_D		(instrF2D[`OPTION1] == `LUI)
`define LUI_E		(instrD2E[`OPTION1] == `LUI)
`define LUI_M		(instrE2M[`OPTION1] == `LUI)
`define LUI_W		(instrM2W[`OPTION1] == `LUI)

// lb, lh, lw, sb, sh, sw

`define LB			(6'b100000)
`define LB_F		(instrF[`OPTION1]   == `LB)
`define LB_D		(instrF2D[`OPTION1] == `LB)
`define LB_E		(instrD2E[`OPTION1] == `LB)
`define LB_M		(instrE2M[`OPTION1] == `LB)
`define LB_W		(instrM2W[`OPTION1] == `LB)

`define LH			(6'b100001)
`define LH_F		(instrF[`OPTION1]   == `LH)
`define LH_D		(instrF2D[`OPTION1] == `LH)
`define LH_E		(instrD2E[`OPTION1] == `LH)
`define LH_M		(instrE2M[`OPTION1] == `LH)
`define LH_W		(instrM2W[`OPTION1] == `LH)

`define LW			(6'b100011)
`define LW_F		(instrF[`OPTION1]   == `LW)
`define LW_D		(instrF2D[`OPTION1] == `LW)
`define LW_E		(instrD2E[`OPTION1] == `LW)
`define LW_M		(instrE2M[`OPTION1] == `LW)
`define LW_W		(instrM2W[`OPTION1] == `LW)

`define SB			(6'b101000)
`define SB_F		(instrF[`OPTION1]   == `SB)
`define SB_D		(instrF2D[`OPTION1] == `SB)
`define SB_E		(instrD2E[`OPTION1] == `SB)
`define SB_M		(instrE2M[`OPTION1] == `SB)
`define SB_W		(instrM2W[`OPTION1] == `SB)

`define SH			(6'b101001)
`define SH_F		(instrF[`OPTION1]   == `SH)
`define SH_D		(instrF2D[`OPTION1] == `SH)
`define SH_E		(instrD2E[`OPTION1] == `SH)
`define SH_M		(instrE2M[`OPTION1] == `SH)
`define SH_W		(instrM2W[`OPTION1] == `SH)
                    
`define SW			(6'b101011)
`define SW_F        (instrF[`OPTION1]   == `SW)
`define SW_D        (instrF2D[`OPTION1] == `SW)
`define SW_E        (instrD2E[`OPTION1] == `SW)
`define SW_M        (instrE2M[`OPTION1] == `SW)
`define SW_W        (instrM2W[`OPTION1] == `SW)