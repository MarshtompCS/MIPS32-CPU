`include "define.v"

module Inst_ROM(
	input wire clk,
	input wire ce,
	input reg[`InstAddrBus] pc,
	output reg[`InstBus] inst
);
	//字节寻址
	//指令存储器
	reg[`InstBus] inst_rom [`InstMemNum-1:0];

	//TODO 初始化inst_rom
	initial $readmemh("inst_rom_data",inst_rom);

	wire[`InstAddrBus] temp;

	always @(posedge clk)
	begin
		if(ce == 1'b1) begin
			temp = pc>>2;
			//(pc>>2)[`InstMemNumLog2-1:0]
			inst <= inst_rom[temp[`InstMemNumLog2-1:0]]
		end
		else begin
			inst <= 32'b0
		end
	end

endmodule