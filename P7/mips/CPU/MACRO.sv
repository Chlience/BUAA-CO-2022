`define PCInitial   (32'h00003000)
`define A1          25:21
`define A2          20:16
`define A3          15:11
`define IMM16       15:0
`define IMM26		25:0

`define OPTION1     31:26
`define OPTION2     5:0
`define SPECIAL     (6'b000000)

`define NOP 		(instrF == 32'b0)
`define NOP_D		(instrF2D == 32'b0)
`define NOP_E		(instrD2E == 32'b0)
`define NOP_M		(instrE2M == 32'b0)
`define NOP_W		(instrM2W == 32'b0)

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

`define SLT         (6'b101010)
`define SLT_F		((instrF[`OPTION1]   == `SPECIAL) && (instrF[`OPTION2]   == `SLT))     
`define SLT_D		((instrF2D[`OPTION1] == `SPECIAL) && (instrF2D[`OPTION2] == `SLT))
`define SLT_E		((instrD2E[`OPTION1] == `SPECIAL) && (instrD2E[`OPTION2] == `SLT))
`define SLT_M		((instrE2M[`OPTION1] == `SPECIAL) && (instrE2M[`OPTION2] == `SLT))
`define SLT_W		((instrM2W[`OPTION1] == `SPECIAL) && (instrM2W[`OPTION2] == `SLT))

`define SLTU        (6'b101011)
`define SLTU_F		((instrF[`OPTION1]   == `SPECIAL) && (instrF[`OPTION2]   == `SLTU))     
`define SLTU_D		((instrF2D[`OPTION1] == `SPECIAL) && (instrF2D[`OPTION2] == `SLTU))
`define SLTU_E		((instrD2E[`OPTION1] == `SPECIAL) && (instrD2E[`OPTION2] == `SLTU))
`define SLTU_M		((instrE2M[`OPTION1] == `SPECIAL) && (instrE2M[`OPTION2] == `SLTU))
`define SLTU_W		((instrM2W[`OPTION1] == `SPECIAL) && (instrM2W[`OPTION2] == `SLTU))

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

`define MULT		(6'b011000)    // special
`define MULT_F		((instrF[`OPTION1]   == `SPECIAL) && (instrF[`OPTION2]   == `MULT))     
`define MULT_D		((instrF2D[`OPTION1] == `SPECIAL) && (instrF2D[`OPTION2] == `MULT))
`define MULT_E		((instrD2E[`OPTION1] == `SPECIAL) && (instrD2E[`OPTION2] == `MULT))
`define MULT_M		((instrE2M[`OPTION1] == `SPECIAL) && (instrE2M[`OPTION2] == `MULT))
`define MULT_W		((instrM2W[`OPTION1] == `SPECIAL) && (instrM2W[`OPTION2] == `MULT))

`define MULTU		(6'b011001)    // special
`define MULTU_F		((instrF[`OPTION1]   == `SPECIAL) && (instrF[`OPTION2]   == `MULTU))     
`define MULTU_D		((instrF2D[`OPTION1] == `SPECIAL) && (instrF2D[`OPTION2] == `MULTU))
`define MULTU_E		((instrD2E[`OPTION1] == `SPECIAL) && (instrD2E[`OPTION2] == `MULTU))
`define MULTU_M		((instrE2M[`OPTION1] == `SPECIAL) && (instrE2M[`OPTION2] == `MULTU))
`define MULTU_W		((instrM2W[`OPTION1] == `SPECIAL) && (instrM2W[`OPTION2] == `MULTU))

`define DIV		    (6'b011010)    // special
`define DIV_F		((instrF[`OPTION1]   == `SPECIAL) && (instrF[`OPTION2]   == `DIV))     
`define DIV_D		((instrF2D[`OPTION1] == `SPECIAL) && (instrF2D[`OPTION2] == `DIV))
`define DIV_E		((instrD2E[`OPTION1] == `SPECIAL) && (instrD2E[`OPTION2] == `DIV))
`define DIV_M		((instrE2M[`OPTION1] == `SPECIAL) && (instrE2M[`OPTION2] == `DIV))
`define DIV_W		((instrM2W[`OPTION1] == `SPECIAL) && (instrM2W[`OPTION2] == `DIV))

`define DIVU		(6'b011011)    // special
`define DIVU_F		((instrF[`OPTION1]   == `SPECIAL) && (instrF[`OPTION2]   == `DIVU))     
`define DIVU_D		((instrF2D[`OPTION1] == `SPECIAL) && (instrF2D[`OPTION2] == `DIVU))
`define DIVU_E		((instrD2E[`OPTION1] == `SPECIAL) && (instrD2E[`OPTION2] == `DIVU))
`define DIVU_M		((instrE2M[`OPTION1] == `SPECIAL) && (instrE2M[`OPTION2] == `DIVU))
`define DIVU_W		((instrM2W[`OPTION1] == `SPECIAL) && (instrM2W[`OPTION2] == `DIVU))

`define MFHI		(6'b010000)    // special
`define MFHI_F		((instrF[`OPTION1]   == `SPECIAL) && (instrF[`OPTION2]   == `MFHI))     
`define MFHI_D		((instrF2D[`OPTION1] == `SPECIAL) && (instrF2D[`OPTION2] == `MFHI))
`define MFHI_E		((instrD2E[`OPTION1] == `SPECIAL) && (instrD2E[`OPTION2] == `MFHI))
`define MFHI_M		((instrE2M[`OPTION1] == `SPECIAL) && (instrE2M[`OPTION2] == `MFHI))
`define MFHI_W		((instrM2W[`OPTION1] == `SPECIAL) && (instrM2W[`OPTION2] == `MFHI))

`define MFLO		(6'b010010)    // special
`define MFLO_F		((instrF[`OPTION1]   == `SPECIAL) && (instrF[`OPTION2]   == `MFLO))     
`define MFLO_D		((instrF2D[`OPTION1] == `SPECIAL) && (instrF2D[`OPTION2] == `MFLO))
`define MFLO_E		((instrD2E[`OPTION1] == `SPECIAL) && (instrD2E[`OPTION2] == `MFLO))
`define MFLO_M		((instrE2M[`OPTION1] == `SPECIAL) && (instrE2M[`OPTION2] == `MFLO))
`define MFLO_W		((instrM2W[`OPTION1] == `SPECIAL) && (instrM2W[`OPTION2] == `MFLO))

`define MTHI		(6'b010001)    // special
`define MTHI_F		((instrF[`OPTION1]   == `SPECIAL) && (instrF[`OPTION2]   == `MTHI))     
`define MTHI_D		((instrF2D[`OPTION1] == `SPECIAL) && (instrF2D[`OPTION2] == `MTHI))
`define MTHI_E		((instrD2E[`OPTION1] == `SPECIAL) && (instrD2E[`OPTION2] == `MTHI))
`define MTHI_M		((instrE2M[`OPTION1] == `SPECIAL) && (instrE2M[`OPTION2] == `MTHI))
`define MTHI_W		((instrM2W[`OPTION1] == `SPECIAL) && (instrM2W[`OPTION2] == `MTHI))

`define MTLO		(6'b010011)    // special
`define MTLO_F		((instrF[`OPTION1]   == `SPECIAL) && (instrF[`OPTION2]   == `MTLO))     
`define MTLO_D		((instrF2D[`OPTION1] == `SPECIAL) && (instrF2D[`OPTION2] == `MTLO))
`define MTLO_E		((instrD2E[`OPTION1] == `SPECIAL) && (instrD2E[`OPTION2] == `MTLO))
`define MTLO_M		((instrE2M[`OPTION1] == `SPECIAL) && (instrE2M[`OPTION2] == `MTLO))
`define MTLO_W		((instrM2W[`OPTION1] == `SPECIAL) && (instrM2W[`OPTION2] == `MTLO))

`define COP0        (6'b010000)
`define COP0FUNCT   25:21

`define MFC0        (5'b00000)
`define MFC0_F		((instrF[`OPTION1]   == `COP0) && (instrF[`COP0FUNCT]   == `MFC0))     
`define MFC0_D		((instrF2D[`OPTION1] == `COP0) && (instrF2D[`COP0FUNCT] == `MFC0))
`define MFC0_E		((instrD2E[`OPTION1] == `COP0) && (instrD2E[`COP0FUNCT] == `MFC0))
`define MFC0_M		((instrE2M[`OPTION1] == `COP0) && (instrE2M[`COP0FUNCT] == `MFC0))
`define MFC0_W		((instrM2W[`OPTION1] == `COP0) && (instrM2W[`COP0FUNCT] == `MFC0))

`define MTC0        (5'b00100)
`define MTC0_F		((instrF[`OPTION1]   == `COP0) && (instrF[`COP0FUNCT]   == `MTC0))     
`define MTC0_D		((instrF2D[`OPTION1] == `COP0) && (instrF2D[`COP0FUNCT] == `MTC0))
`define MTC0_E		((instrD2E[`OPTION1] == `COP0) && (instrD2E[`COP0FUNCT] == `MTC0))
`define MTC0_M		((instrE2M[`OPTION1] == `COP0) && (instrE2M[`COP0FUNCT] == `MTC0))
`define MTC0_W		((instrM2W[`OPTION1] == `COP0) && (instrM2W[`COP0FUNCT] == `MTC0))

`define ERET		(6'b011000)
`define ERET_F		((instrF[`OPTION1]   == `COP0) && (instrF[`OPTION2]   == `ERET))     
`define ERET_D		((instrF2D[`OPTION1] == `COP0) && (instrF2D[`OPTION2] == `ERET))
`define ERET_E		((instrD2E[`OPTION1] == `COP0) && (instrD2E[`OPTION2] == `ERET))
`define ERET_M		((instrE2M[`OPTION1] == `COP0) && (instrE2M[`OPTION2] == `ERET))
`define ERET_W		((instrM2W[`OPTION1] == `COP0) && (instrM2W[`OPTION2] == `ERET))

`define SYSCALL		(6'b001100)
`define SYSCALL_F	((instrF[`OPTION1]   == `SPECIAL) && (instrF[`OPTION2]   == `SYSCALL))     
`define SYSCALL_D	((instrF2D[`OPTION1] == `SPECIAL) && (instrF2D[`OPTION2] == `SYSCALL))
`define SYSCALL_E	((instrD2E[`OPTION1] == `SPECIAL) && (instrD2E[`OPTION2] == `SYSCALL))
`define SYSCALL_M	((instrE2M[`OPTION1] == `SPECIAL) && (instrE2M[`OPTION2] == `SYSCALL))
`define SYSCALL_W	((instrM2W[`OPTION1] == `SPECIAL) && (instrM2W[`OPTION2] == `SYSCALL))

`define AdEL        (5'd4)
`define AdES		(5'd5)
`define Syscall		(5'd8)
`define RI			(5'd10)
`define OV			(5'd12)
`define DEF_D       (`NOP_D || `ADD_D || `SUB_D || `AND_D || `OR_D || `SLT_D || `SLTU_D || `ADDI_D || `ANDI_D || `ORI_D || `BEQ_D || `BNE_D || `JAL_D || `JR_D || `LUI_D || `LB_D || `LH_D || `LW_D || `SB_D || `SH_D || `SW_D || `MULT_D || `MULTU_D || `DIV_D || `DIVU_D || `MFHI_D || `MFLO_D || `MTHI_D || `MTLO_D || `MFC0_D || `MTC0_D || `ERET_D || `SYSCALL_D)