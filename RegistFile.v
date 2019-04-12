`include "define.v"

//通用寄存器 General Purpose Registers
module GPR(
	input wire rst,

	//从MEM-WB输入的
	input wire[31:0] write_data,
	input wire[4:0] write_reg_addr, 
	input wire reg_write_en,

	//从ID段输入的
	input wire[4:0] rs_addr,
	input wire[4:0] rt_addr,

	//输出到ID的
	output reg[`RegBus] rs_data,
	output reg[`RegBus] rt_data
);
	//32个通用寄存器
	reg[`RegBus] registers[31:0];

	integer i;
	initial
	begin
	for(i=0; i<32; i=i+1)
		registers[i] = 32'b0;
	end
	
	
	always @(*)
	begin
		//写端口
		if(rst == 1'b0 && reg_write_en == 1'b1 && write_reg_addr != 5'b00000)
			registers[write_reg_addr] <= write_data;
		//读端口
		if(rst == 1'b1)
		begin
			rs_data <= 32'b0;
			rt_data <= 32'b0;
		end
		else
		begin
			rs_data <= registers[rs_addr];
			rt_data <= registers[rt_addr];
		end
	end

	//两个读端口
	/*
		reset有效：输出0;
		读目标是0号寄存器：输出0;

		解决间隔两条的非Load指令RAW相关：
		读目标和写目标一样，且写使能和读使能有效：输出=写入;
	*/



endmodule 