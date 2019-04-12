`include "define.v"

module Data_Mem(
	input wire rst,

	input wire[31:0] mem_addr,
	input wire mem_read_en,
	input wire mem_write_en,
	input wire[31:0] mem_write_data,

	output reg[31:0] mem_result
);
	

	//数据存储器
	reg[31:0] data_mem[0:`DataMemByteNum];

	initial $readmemh("C:\\Users\\ndmar\\Desktop\\VerilogSS\\data_mem_data",data_mem);

	always @(*)
	begin
		if(rst == 1'b1)
			mem_result <= 32'b0;
		else
		begin
			if(mem_read_en == 1'b1)
				mem_result <= data_mem[mem_addr[31:2]];
			if(mem_write_en == 1'b1)
				data_mem[{2'b00,mem_addr[31:2]}] <= mem_write_data;
		end
	end



endmodule