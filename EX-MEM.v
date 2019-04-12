`include "define.v"

module EX_MEM(
	input wire clk,
	input wire rst,

	input wire[31:0] result_i,
	input wire[4:0] write_reg_addr_i,
	input wire[`CtrlBus] control_signal_i,
	input wire[31:0] mem_write_data_i,


	output reg[31:0] result_o,
	output reg[4:0] write_reg_addr_o,
	output reg[`CtrlBus] control_signal_o,
	output reg[31:0] mem_write_data_o
);

	always @(posedge clk)
	begin
		if(rst == 1'b1)
		begin
			result_o <= 32'b0;
			write_reg_addr_o <= 5'b0;
			control_signal_o <= `ctrl_Rtype;
			mem_write_data_o <= 32'b0;
		
		end
		else
		begin
			result_o <= result_i;
			write_reg_addr_o <= write_reg_addr_i;
			control_signal_o <= control_signal_i;
			mem_write_data_o <= mem_write_data_i;
		end
	end
	
endmodule