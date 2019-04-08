//defined by @Marshtomp

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


//指令存储器ROM相关的宏定义
`define InstAddrBus		31:0    //ROM地址总线宽度
`define InstBus			31:0    //ROM数据总线宽度
`define InstMemNum		131071  //ROM的实际大小128KB
`define InstMemNumLog2	17      //ROM实际使用的地址线宽度


//通用寄存器Regfile相关的宏定义
`define RegAddrBus		4:0		//Regfile地址线宽度
`define RegBus			31:0	//Regfile数据线宽度
`define NOPRegAddr		5'b00000
