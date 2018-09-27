`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/28 19:43:50
// Design Name: 
// Module Name: defines
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


//*****************************宏定义***********************************

`define RstEnable       1'b0           //复位信号有效
`define RstDisable       1'b1           //无效
`define ZeroWord        32'h00000000   //32位0
`define WriteEnable     1'b1           //写使能
`define WriteDisable    1'b0           //写禁止
`define ReadEnable      1'b1           //读使能
`define ReadDisable     1'b0           //禁止读
`define AluOpBus        7:0            //译码输出宽度
`define AluSelBus       2:0            //译码输出alusel_o宽度
`define InstValid       1'b0          //指令有效
`define InstInvalid     1'b1           //指令无效
`define True_v          1'b1           //逻辑真
`define False_v         1'b0           //逻辑假
`define ChipEnable      1'b1           //芯片使能
`define ChipDisable     1'b0           //芯片禁止
`define Branch          1'b1
`define NotBranch       1'b0

`define DataAddrBus 31:0
`define DataBus     31:0
`define DataMemNum  131071
`define DataMemNumLog2 17
`define ByteWidth   7:0

`define EXE_ORI    6'b001101
`define EXE_NOP    6'b000000
`define EXE_AND    6'b100100
`define EXE_OR     6'b100101
`define EXE_XOR    6'b100110
`define EXE_NOR    6'b100111
`define EXE_ANDI   6'b001100
`define EXE_XORI   6'b001110
`define EXE_LUI    6'b001111

`define EXE_SLL      6'b000000
`define EXE_SLLV     6'b000100
`define EXE_SRL      6'b000010
`define EXE_SRLV     6'b000110
`define EXE_SRA      6'b000011
`define EXE_SRAV     6'b000111
`define EXE_SYNC     6'b001111
`define EXE_PREF     6'b110011

`define EXE_MOVZ 6'b001010
`define EXE_MOVN 6'b001011
`define EXE_MFHI 6'b010000
`define EXE_MTHI 6'b010001
`define EXE_MFLO 6'b010010
`define EXE_MTLO 6'B010011
`define EXE_BREAK 6'B001101

`define EXE_SLT 6'B101010
`define EXE_SLTU 6'B101011
`define EXE_SLTI 6'B001010
`define EXE_SLTIU 6'B001011
`define EXE_ADD 6'B100000
`define EXE_ADDU 6'B100001
`define EXE_SUB 6'B100010
`define EXE_SUBU 6'b100011
`define EXE_ADDI 6'B001000
`define EXE_ADDIU 6'b001001
`define EXE_CLZ 6'B100000
`define EXE_CLO 6'B100001
`define EXE_MULT 6'B011000
`define EXE_MULTU 6'b011001
`define EXE_MUL 6'B000010



`define EXE_MOVZ_OP 8'h01
`define EXE_MOVN_OP 8'h02
`define EXE_MFHI_OP 8'h03
`define EXE_MTHI_OP 8'h04
`define EXE_MFLO_OP 8'h05
`define EXE_MTLO_OP 8'h06
`define EXE_OR_OP    8'h07
`define EXE_NOP_OP   8'h08
`define EXE_AND_OP   8'h09
`define EXE_XOR_OP   8'h0a
`define EXE_NOR_OP   8'h0b
`define EXE_ANDI_OP  8'h0c
`define EXE_XORI_OP  8'h0d
`define EXE_LUI_OP   8'h0e
`define EXE_SLL_OP   8'h0f
`define EXE_SLLV_OP  8'h10
`define EXE_SRL_OP   8'h11
`define EXE_SRLV_OP  8'h12
`define EXE_SRA_OP   8'h13
`define EXE_SRAV_OP  8'h14
`define EXE_SYNC_OP  8'h15
`define EXE_PREF_OP  8'h16

`define EXE_SLT_OP 8'h17
`define EXE_SLTU_OP 8'h18
`define EXE_SLTI_OP 8'h19
`define EXE_SLTIU_OP 8'h1a
`define EXE_ADD_OP 8'h1b
`define EXE_ADDU_OP 8'h1c
`define EXE_SUB_OP 8'h1d
`define EXE_SUBU_OP 8'h1e
`define EXE_ADDI_OP 8'h1f
`define EXE_ADDIU_OP 8'h20
`define EXE_CLZ_OP 8'h21
`define EXE_CLO_OP 8'h22
`define EXE_MULT_OP 8'h23
`define EXE_MULTU_OP 8'h24
`define EXE_MUL_OP 8'h25

`define EXE_RES_LOAD_STORE 3'b111
`define EXE_RES_JUMP_BRANCH 3'B110
`define EXE_RES_MUL 3'B101
`define EXE_RES_ARITHMETIC 3'b100
`define EXE_RES_MOVE     3'b011
`define EXE_RES_SHIFT    3'b010
`define EXE_RES_LOGIC    3'b001
`define EXE_RES_NOP      3'b000

`define EXE_SPECIAL_INST 6'b000000
`define EXE_SPECIAL2_INST 6'b011100
`define EXE_REGIMM_INST 6'b000001


`define Stop 1'b1
`define NotStop 1'b0

`define EXE_MADD 6'b000000
`define EXE_MADDU 6'b000001
`define EXE_MSUB 6'B000100
`define EXE_MSUBU 6'b000101

`define EXE_MADD_OP 8'h28
`define EXE_MADDU_OP 8'h29
`define EXE_MSUB_OP 8'h2a
`define EXE_MSUBU_OP 8'h2b

`define InstAddrBus         31:0      //ROM地址总线宽度
`define InstBus             31:0      //ROM数据总线宽度
`define InstMemNum          131071    //ROM大小
`define InstMemNumLog2     17        //ROM实际使用地址线宽度


`define RegAddrBus         4:0
`define RegBus             31:0
`define RegWidth           32
`define DoubleRegWidth     64
`define DoubleRegBus       63:0
`define RegNum             32
`define RegNumLog2         5
`define NOPRegAddr         5'b00000

`define DivFree      2'b00
`define DivByZero    2'b01
`define DivOn        2'b10
`define DivEnd       2'b11
`define DivResultReady  1'b1
`define DivResultNotReady  1'b0
`define DivStart    1'b1
`define DivStop     1'b0

`define EXE_DIV 6'B011010
`define EXE_DIVU 6'B011011
`define EXE_DIV_OP 8'h26
`define EXE_DIVU_OP 8'h27

`define EXE_J       6'B000010
`define EXE_JAL     6'B000011
`define EXE_JALR    6'B001001
`define EXE_JR      6'B001000
`define EXE_BEQ     6'B000100
`define EXE_BGEZ    5'B00001
`define EXE_BGEZAL  5'B10001
`define EXE_BGTZ    6'B000111
`define EXE_BLEZ    6'B000110
`define EXE_BLTZ    5'B00000
`define EXE_BLTZAL  5'B10000
`define EXE_BNE     6'B000101

`define EXE_J_OP       8'h2c
`define EXE_JAL_OP     8'h2d
`define EXE_JALR_OP    8'h2e
`define EXE_JR_OP      8'h2f
`define EXE_BEQ_OP     8'h30
`define EXE_BGEZ_OP    8'h31
`define EXE_BGEZAL_OP  8'h32
`define EXE_BGTZ_OP    8'h33
`define EXE_BLEZ_OP    8'h34
`define EXE_BLTZ_OP    8'h35
`define EXE_BLTZAL_OP  8'h36
`define EXE_BNE_OP     8'h37
`define InDelaySlot 1'b1
`define NotInDelaySlot  1'b0


`define EXE_LB      6'B100000
`define EXE_LBU     6'b100100
`define EXE_LH      6'B100001
`define EXE_LHU     6'B100101
`define EXE_LW      6'B100011
`define EXE_LWL     6'B100010
`define EXE_LWR     6'B100110
`define EXE_SB      6'B101000
`define EXE_SH      6'B101001
`define EXE_SW      6'B101011
`define EXE_SWL     6'B101010
`define EXE_SWR     6'B101110

`define EXE_LB_OP      8'h38
`define EXE_LBU_OP     8'h39
`define EXE_LH_OP      8'h3a
`define EXE_LHU_OP     8'h3b
`define EXE_LW_OP      8'h3c
`define EXE_LWL_OP     8'h3d
`define EXE_LWR_OP     8'h3e
`define EXE_SB_OP      8'h3f
`define EXE_SH_OP      8'h40
`define EXE_SW_OP      8'h41
`define EXE_SWL_OP     8'h42
`define EXE_SWR_OP     8'h43



`define EXE_LL      6'b110000
`define EXE_SC      6'b111000

`define EXE_LL_OP   8'h44
`define EXE_SC_OP   8'h45


`define CP0_REG_COUNT  5'B01001
`define CP0_REG_COMPARE 5'B01011
`define CP0_REG_STATUS 5'B01100
`define CP0_REG_CAUSE 5'B01101
`define CP0_REG_EPC 5'B01110
`define CP0_REG_PRID 5'B01111
`define CP0_REG_CONFIG 5'B10000

`define InterruptAssert 1'B1
`define InterruptNotAssert 1'B0

`define EXE_MFC0_OP 8'h46
`define EXE_MTC0_OP 8'h47



`define EXE_SYSCALL 6'B001100

`define EXE_TEQ 6'B110100
`define EXE_TEQI 5'B01100
`define EXE_TGE 6'B110000
`define EXE_TGEI 5'B01000
`define EXE_TGEU 6'B110001
`define EXE_TGEIU 5'B01001
`define EXE_TLT 6'B110010
`define EXE_TLTI 5'B01010
`define EXE_TLTIU 5'B01011
`define EXE_TLTU 6'B110011
`define EXE_TNE 6'B110110
`define EXE_TNEI 5'B01110
`define EXE_ERET 32'B01000010000000000000000000011000

`define EXE_TGEU_OP 8'h48
`define EXE_TEQ_OP 8'h49
`define EXE_TEQI_OP 8'h4a
`define EXE_TGE_OP 8'h4b
`define EXE_TGEI_OP 8'h4c
`define EXE_TGEIU_OP 8'h4d
`define EXE_TLT_OP 8'h4e
`define EXE_TLTI_OP 8'h4f
`define EXE_TLTIU_OP 8'h50
`define EXE_TLTU_OP 8'h51
`define EXE_TNE_OP 8'h52
`define EXE_TNEI_OP 8'h53
`define EXE_SYSCALL_OP 8'h54
`define EXE_ERET_OP 8'h55

`define InDelaySlot 1'b1
`define NotInDelaySlot 1'b0
`define TrapAssert 1'b1
`define TrapNotAssert 1'b0




