`include "define.v"

module Inst_Mem(
	input wire rst,
	input wire[`InstMemAddrBus] pc,
	output reg[31:0] inst
);
	reg[31:0] inst_mem [0:`InstMemByteNum-1];

	initial $readmemb("C:\\Users\\ndmar\\Desktop\\VerilogSS\\inst_mem_data",inst_mem);

	always @(*) 
	begin
		if(rst == 1'b1)
			inst <= 32'b0;
		else
			inst <= inst_mem[pc>>2];
			$display("%b",inst);
	end

endmodule