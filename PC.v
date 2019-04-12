`include "define.v"

//Program Counter
//Instruction Fectch
//IF = PC + Inst_ROM

module PC(
	input wire rst,
	input wire clk,
	output reg[`InstAddrBus] pc
);


	always @(posedge clk)
	begin
		if(rst == 1'b1)
			pc <= 32'b0;		
		else
			pc <= pc + 4;

	end

endmodule