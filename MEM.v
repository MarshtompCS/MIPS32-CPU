`include "define.v"

module MEM(
	input wire rst,

	//从EX输入的
	input wire[31:0] alu_result,
	input wire[4:0] write_reg_addr_i,
	input wire[`CtrlBus] control_signal_i,
	input wire[31:0] mem_write_data_i,

	//访存得到的
	input wire[31:0] mem_result,

	//输出到mem的
	output reg[31:0] mem_addr,//alu_result作为访存地址
	output reg[31:0] mem_write_data_o,
	output reg mem_read_en,
	output reg mem_write_en,
	
	//输出到MEM-WB的
	output reg[31:0] result,
	output reg[4:0] write_reg_addr_o,
	output reg[`CtrlBus] control_signal_o
	
	//MEM forwarding / bypass(bp)
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

	//访存
	always @(*)
	begin
		if(rst == 1'b1)
		begin
			mem_addr <= 32'b0;
			mem_read_en <= 1'b0;
			mem_write_en <= 1'b0;
			mem_write_data_o <= 32'b0;
		end
		else
		begin
			mem_addr <= alu_result;
			mem_read_en <= control_signal_i[4];
			mem_write_en <= control_signal_i[5];
			mem_write_data_o <= mem_write_data_i;
		end
	end

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

	always @(*)
	begin
		if(rst == 1'b1)
		begin
			result <= 32'b0;
			write_reg_addr_o <= 5'b0;
			control_signal_o <= `ctrl_Rtype;
		end
		else
		begin
			if(mem_read_en == 1'b0)
				result <= alu_result;
			else
				result <= mem_result;
			write_reg_addr_o <= write_reg_addr_i;
			control_signal_o <= control_signal_i;
		end
	end
	

endmodule