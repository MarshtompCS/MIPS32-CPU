//defined by @Marshtomp

`define ZeroWord		32'b0	//32位0
`define DataBus			31:0	//数据总线
`define InstAddrBus		31:0    //地址总线
`define RegAddrBus		4:0		//Regfile地址线宽度
`define RegBus			31:0	//Regfile数据线宽度



//通用寄存器Regfile相关的宏定义
`define RegBus			31:0	//Regfile数据线宽度
`define NOPRegAddr		5'b00000

`define AluOpBus		7:0  //译码阶段的输出aluop_o的宽度
`define AluOpTypeBus	2:0  //译码阶段的输出alusel_o的宽度

//指令相关
`define EXE_ORI			6'b001101  //ori
`define EXE_NOP			6'b000000  //nop

//AluOp 运算的子类型：逻辑运算中的或运算
`define EXE_OR_OP		8'b00100101
`define EXE_NOP_OP		8'b00000000

//AluSel 运算的类型：逻辑运算等
`define EXE_RES_LOGIC	3'b001
`define EXE_RES_NOP		3'b000

// 指令存储器
// 1K*32bit的访存空间，4B = 1Word
// 32*1024 = 4096Byte = 1024Word
// log (InstMemWOrdNum  / 4) = 10
// InstMemAddrBus = 9:0
`define InstMemByteNum	4096
`define InstMemAddrBus	11:0	//12位宽，表示0-4095的地址

`define DataMemByteNum 4096

//  6-bit	5-bit	5-bit	5-bit	5-bit	6-bit
// opcode	  rs	  rt	  rd	shamt	funct
// [31:26]	[25:21]	[20:16]	[15:11]	[10:6]	[5:0]

//opcode解码
`define SPECIAL		6'b000000	//SPECIAL指令
`define SPECIAL2	6'b011100	//SPECIAL2指令
//有问题：`define op_NAL		6'b000001	//函数返回地址，GPR[31] <- PC + 8
/*跳转指令*/
`define op_J		6'b000010	//I:(这条指令) I+1: PC <- {PC[31:28],imm26,2'b0}
`define op_JAL		6'b000011
`define op_BEQ		6'b000100
`define op_BNE		6'b000101
`define op_BLEZ		6'b000110
`define op_BGTZ		6'b000111
/*算逻运算*/
`define op_ADDI		6'b001000
`define op_ADDIU	6'b001001
`define op_SLTI		6'b001010	//小于置1 rt <- (rs < sign_ext(imm))
`define op_SLTIU	6'b001011
`define op_ANDI		6'b001100
`define op_ORI		6'b001101
`define op_XORI		6'b001110
`define op_LUI		6'b001111	//rt <- {imm, 16'b0}
/*L-S指令*/
`define op_LB		6'b100000
`define op_LH		6'b100001
`define op_LWL		6'b100010
`define op_LW		6'b100011
`define op_LBU		6'b100100
`define	op_LHU		6'b100101
`define op_LWR		6'b100110
`define op_SB		6'b101000
`define op_SH		6'b101001
`define op_SWL		6'b101010
`define op_SW		6'b101011
`define op_SWR		6'b101110
`define op_LL		6'b110000
`define op_SC		6'b111000
//SPECIAL(opcode = 000000) funct解码
/*位移指令*/
`define f_SLL		6'b000000	//左移 rd <- (rt << shamt)
`define f_SRL		6'b000010	//逻辑右移 rd <- (rt >> shamt)
`define f_SRA		6'b000011	//算术右移 rd <- (rt >> shamt)
`define f_SLLV		6'b000100	//rd <- (rt << rs)
`define f_SRLV		6'b000110	//逻辑右移 rd <- (rt >> rs)
`define f_SRAV		6'b000111	//算术右移 rd <- (rt >> rs)
/*转移指令*/
`define f_JR		6'b001000	//pc <- rs
`define f_JALR		6'b001001	//pc <- rs
/*MOV指令*/
`define f_MOVZ		6'b001010	//if rt == 0 then rd <- rs
`define f_MOVN		6'b001011	//if rt != 0 then rd <- rs
//HI/LO寄存器mov
`define f_MFHI		6'b010000	//rd <- HI
`define f_MTHI		6'b010001	//HI <- rs
`define f_MFLO		6'b010010	//rd <- LO
`define f_MTLO		6'b010011	//LO <- rs
/*算术运算*/
`define f_ADD		6'b100000	//rd <- rs + rt
`define f_ADDU		6'b100001
`define f_SUB		6'b100010
`define f_SUBU		6'b100011
`define f_SLT		6'b101010	//小于置1 rd <- (rs < rt)
`define f_SLTU		6'b101011
`define f_MULT		6'b011000	//LO <- rs*rt[31:0], HI <- rs*rt[63:32]
`define f_MULTU		6'b011001
`define f_DIV		6'b011010	//LO <- rs / rt, HI <- rs % rt
`define f_DIVU		6'b011011
/*逻辑运算*/
`define f_AND		6'b100100
`define f_OR		6'b100101
`define f_XOR		6'b100110
`define f_NOR		6'b100111
//SPECIAL2(opcode = 011100) funct解码
//...
//...

//alu_OP定义
/*逻辑运算*/
`define alu_zero	5'd0
`define alu_AND		5'd1
`define alu_OR		5'd2
`define alu_XOR		5'd3
`define alu_NOR		5'd4
`define alu_SLL		5'd5
`define alu_SRL		5'd6
`define alu_SRA		5'd7
/*算术运算*/	
`define alu_ADD		5'd8
`define alu_ADDU	5'd9
`define alu_SUB		5'd10
`define alu_SUBU	5'd11
`define alu_MULT	5'd12
`define alu_MULTU	5'd13
`define alu_DIV		5'd14
`define alu_DIVU	5'd15



`define FromMem		1'b0
`define FromReg		1'b1

`define CtrlBus		7:0
`define ctrl_Rtype		8'b00001111
`define ctrl_Itype		8'b00001100

/*control_signal 控制信号
--------------------------------------------------------------------
| 位 |     名称                 功能
--------------------------------------------------------------------
| 0  |  write_reg_addr       写入寄存器选择          0:rt     1:rd
| 1  |  second_scr           ALU第二个操作数来源     0:Imm    1:Reg
| 2	 |  write_back_scr       写回的数据来源          0:Mem    1:Reg
| 3  |  write_back_en        寄存器写回使能          0:不写回  1:写回
--------------------------------------------------------------------
| 4  |  mem_read_en          存储器读使能            0:禁止读  1:允许读
| 5  |  mem_write_en         存储器写使能            0:禁止写  1:允许写
| 6  |  next_pc_src          下一条指令来源         00:PC+4   01:J Reg
| 7  |                                             10:J Imm  11:Bench
--------------------------------------------------------------------*/