`include "define.v"

module ID_EX(
	input wire clk,
	input wire rst,

	input wire[4:0] alu_op_i,
	input wire[31:0] src_data1_i,
	input wire[31:0] src_data2_i,
	input wire[4:0] write_reg_addr_i,
	input wire[`CtrlBus] control_signal_i,
	input wire[4:0] mem_write_data_i,

	output reg[4:0] alu_op_o,
	output reg[`DataBus] src_data1_o,
	output reg[`DataBus] src_data2_o,
	output reg[`RegAddrBus] write_reg_addr_o,
	output reg[`CtrlBus] control_signal_o,
	output reg[4:0] mem_write_data_o
);
	always @(posedge clk)
	begin
		if(rst == 1'b1)
		begin
			alu_op_o <= 4'b0;
			src_data1_o <= 32'b0;
			src_data2_o <= 32'b0;
			write_reg_addr_o <= 5'b0;
			control_signal_o <= 8'b0;
			mem_write_data_o <= 32'b0;
		end
		else
		begin
			alu_op_o <= alu_op_i;
			src_data1_o <= src_data1_i;
			src_data2_o <= src_data2_i;
			write_reg_addr_o <= write_reg_addr_i;
			control_signal_o <= control_signal_i;
			mem_write_data_o <= mem_write_data_i;
		end
	end

endmodule