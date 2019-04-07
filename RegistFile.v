`include "define.v"

//通用寄存器 General Purpose Registers
module GPR(
	input wire rst,
	input wire clk,

	input wire reg1_read_i,
	input wire reg2_read_i,
	input wire[`RegAddrBuss] reg1_addr_i,
	input wire[`RegAddrBuss] reg2_addr_i,

	input wire rd_write_i,
	input wire[`RegAddrBuss] rd_addr_i,
	input wire[`RegBuss] write_data_i,

	output reg[`RegBuss] reg1_data_o,
	output reg[`RegBuss] reg2_data_o
);
	//32个通用寄存器
	reg[`RegBuss] registers[31:0];

	//写端口
	always @(posedge clk)
	begin
		if((rst == 1'b0) && (rd_write_i == 1'b1) && (rd_addr_i != 5'b00000))
			registers[rd_addr_i] <= write_data_i;
	end

	//两个读端口
	/*
		reset有效：输出0;
		读目标是0号寄存器：输出0;
		读目标和写目标一样，且写使能和读使能有效：输出=写入;
	*/
	always @(*)
	begin
		if(rst == 1'b1)
			reg1_data_o <= 32'b0;
		else if (reg1_addr_i == 5'b0)
			reg1_data_o <= 32'b0;
		else if ((reg1_read_i == 1'b1) && (rd_write_i == 1'b1) && (rd_addr_i == reg1_addr_i))
			reg1_data_o <= write_data_i;
		else if(reg1_read_i == 1'b1)
			reg1_data_o <= registers[reg1_addr_i];
		else
			reg1_data_o <= 32'b0;
	end

	always @(*)
	begin
		if(rst == 1'b1)
			reg2_data_o <= 32'b0;
		else if (reg2_addr_i == 5'b0)
			reg2_data_o <= 32'b0;
		else if ((reg2_read_i == 1'b1) && (rd_write_i == 1'b1) && (rd_addr_i == reg2_addr_i))
			reg2_data_o <= write_data_i;
		else if(reg2_read_i == 1'b1)
			reg2_data_o <= registers[reg2_addr_i];
		else
			reg2_data_o <= 32'b0;
	end


endmodule 