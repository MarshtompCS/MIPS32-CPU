`include "define.v"

module MEM_WB(
	input wire rst,
	input wire clk,

	input wire[31:0] result_i,
	input wire[4:0] write_reg_addr_i,
	input wire[`CtrlBus] control_signal,
	
	//输出到Reg的
	output reg[31:0] result_o,
	output reg[4:0] write_reg_addr_o,
	output reg reg_write_en
);



	always @(posedge clk)
	begin
		if(rst == 1'b1)
		begin
			result_o <= 32'b0;
			write_reg_addr_o <= 5'b0;
			reg_write_en <= 1'b0;
		end
		else
		begin
			result_o <= result_i;
			write_reg_addr_o <= write_reg_addr_i;
			reg_write_en <= control_signal[3];
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
	
	

endmodule