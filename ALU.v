`include "define.v"

module ALU(
	input wire rst,

	input wire[4:0] alu_op,
	input wire[31:0] src1,
	input wire[31:0] src2,
	input wire[4:0] write_reg_addr_i,
	input wire[`CtrlBus] control_signal_i,
	input wire[31:0] mem_write_data_i,

	output reg[31:0] result,
	output reg[4:0] write_reg_addr_o,
	output reg[31:0] mem_write_data_o,
	output reg[`CtrlBus] control_signal_o

	//ALU forwarding / bypass(bp)
	//自己当前的输出，转发到ID-EX
	/*也就是result、write_reg_addr_o、control_signal_o*/

/*
---------------------------------------------------------------------------------------
  |     |ID|     |ALU|      |MEM       | 敏感信号为*
PC|IF-ID|  |ID-EX|   |EX-MEM|          | 敏感信号为clk posedge
---------------------------------------------------------------------------------------
IF ID EX MEM WB
   IF ID EX  MEM WB  
      IF ID  EX  MEM WB
	     IF  ID  EX  MEM WB
---------------------------------------------------------------------------------------
非load数据相关：
ALU段计算出结果，把当前结果转发到ID，在ID下一个cycle输出给ALU的操作数
MEM段将当前结果转发到ID流水段，在ID选择下一个cycle输出给ALU的操作数
在RegistFile中检查要读取的寄存器是不是和写入的寄存器一样，如果一样则将写入数据直接输出
---------------------------------------------------------------------------------------
load数据相关：
在ID-EX段判断是否取到正确的操作数：
1.正确则正常执行
2.冲突则发出stall信号
stall信号由ID发出，PC接收后PC=PC不加4，
---------------------------------------------------------------------------------------
*/

);
	always @(*)
	begin
		if(rst == 1'b1)
		begin
			result <= 32'b0;
			write_reg_addr_o <= 5'b0;
			control_signal_o <= `ctrl_Rtype;
			mem_write_data_o <= 31'b0;
		end
		else 
		begin
			case(alu_op)
				`alu_AND:	result <= src1 & src2;//1
				`alu_OR:	result <= src1 | src2;//2
				`alu_XOR:	result <= src1 ^ src2;//3
				`alu_NOR:	result <= src1 ^~ src2;//4
				`alu_SLL:	result <= src2 << src1;//5
				`alu_SRL:	result <= src2 >> src1;//6
				`alu_SRA:	result <= $signed(src2) >>> src1;//7
				`alu_ADD:	result <= src1 + src2;//8
				`alu_ADDU:	result <= src1 + src2;//9
				`alu_SUB:	result <= src1 - src2;//10
				`alu_SUBU:	result <= src1 - src2;//11
				//MUL MULT DIV DIVU 12-15
			endcase
			write_reg_addr_o <= write_reg_addr_i;
			control_signal_o <= control_signal_i;
			mem_write_data_o <= mem_write_data_i;
		end
	end



endmodule