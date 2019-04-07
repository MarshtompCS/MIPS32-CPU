`include "define.v"

//连接IF和ID
module IF_ID(
	input wire[`InstAddrBus] pc_i,
	input wire[`InstBus] inst_i,
	input wire rst,
	input wire clk,
	output reg[`InstAddrBus] pc_o,
	output reg[`InstBus] inst_o
);

	always @(posedge clk)
	begin
		if(rst == 1'b1)
		begin
			pc_o <= 32'b0;
			inst_o <= 32'b0;
		end
		else
		begin
			pc_o <= pc_i;
			inst_o <= inst_i;
		end
	end
	
endmodule