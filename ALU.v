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