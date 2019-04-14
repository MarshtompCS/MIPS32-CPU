`include "define.v"

module ID_EX(
	input wire clk,
	input wire rst,

	input wire[4:0] alu_op_i,
	input wire[31:0] src_data1_i,
	input wire[4:0] src1_reg_addr,
	input wire[31:0] src_data2_i,
	input wire[4:0] src2_reg_addr,
	input wire[4:0] write_reg_addr_i,
	input wire[`CtrlBus] control_signal_i,
	input wire[31:0] mem_write_data_i,

	output reg[4:0] alu_op_o,
	output reg[`DataBus] src_data1_o,
	output reg[`DataBus] src_data2_o,
	output reg[`RegAddrBus] write_reg_addr_o,
	output reg[`CtrlBus] control_signal_o,
	output reg[31:0] mem_write_data_o,

	//load : rt <- mem[(rs + imm16)]
	//load : rt <- mem[alu_result]
	//load : rt <- mem_result
	//load : write_reg_addr <- mem_result

	//store: mem[(rs + imm16)] <- rt
	//store: mem[alu_result] <- rt
	//store: mem_result <- rt
	//store: mem_result <- mem_write_data

	//forwarding / bypass
	input wire[31:0] bpalu_result,
	input wire[4:0] bpalu_write_reg_addr,
	input wire bpalu_write_reg_en,
	input wire[31:0] bpmem_result,
	input wire[4:0] bpmem_write_reg_addr,
	input wire bpmem_write_reg_en

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

			write_reg_addr_o <= write_reg_addr_i;
			control_signal_o <= control_signal_i;
			mem_write_data_o <= mem_write_data_i;

			//forwarding / bypass
			if(bpalu_write_reg_en == 1'b1)
			begin
				if(bpalu_write_reg_addr == src1_reg_addr)
					src_data1_o <= bpalu_result;
				else
					src_data1_o <= src_data1_i;
				if(bpalu_write_reg_addr == src2_reg_addr)
					src_data2_o <= bpalu_result;
				else
					src_data2_o <= src_data2_i;
			end
			else if(bpmem_write_reg_en == 1'b1)
			begin
				if(bpmem_write_reg_addr == src1_reg_addr)
					src_data1_o <= bpmem_result;
				else
					src_data1_o <= src_data1_i;
				if(bpmem_write_reg_addr == src2_reg_addr)
					src_data2_o <= bpmem_result;
				else
					src_data2_o <= src_data2_i;
			end
			else
			begin
				src_data1_o <= src_data1_i;
				src_data2_o <= src_data2_i;
			end

		end
	end



endmodule