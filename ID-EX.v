`include "define.v"

module ID_EX(
	input wire clk,
	input wire rst,

	input wire[`AluOpBus] aluop_i,
	input wire[`AluOpTypeBus] aluoptype_i,
	input wire[`RegBus] reg1_data_i,
	input wire[`RegBus] reg2_data_i,
	input wire[`RegBus] rd_write_i,
	input wire[`RegAddrBus] rd_addr_i,
	
	output reg[`AluOpBus] aluop_o,
	output reg[`AluOpTypeBus] aluoptype_o,
	output reg[`RegBus] reg1_data_o,
	output reg[`RegBus] reg2_data_o,
	output reg[`RegBus] rd_write_o,
	output reg[`RegAddrBus] rd_addr_o	
);
	
	always @(posedge clk)
	begin
		if(rst == 1'b1)
		begin
			aluop_o <= `EXE_NOP_OP;
			aluoptype_o <= 'EXE_RES_NOP;
			reg1_data_o <= 32'b0;
			reg2_data_o <= 32'b0;
			rd_write_i <= 1'b0;
			rd_addr_o <= 5'b0;
		end
		else
		begin
			aluop_o <= aluop_i;
			aluoptype_o <= aluoptype_i;
			reg1_data_o <= reg1_data_i;
			reg2_data_o <= reg2_data_i;
			rd_write_i <= rd_write_i;
			rd_addr_o <= rd_addr_i;
		end
	end

endmodule