`include "define.v"

//Program Counter
//Instruction Fectch
//IF = PC + Inst_ROM

module PC(
	input wire rst,
	input wire clk,
	output reg[`InstAddrBus] pc,
	output reg ce
);

	always @(posedge clk)
	begin
		if(rst == 1'b1)
			ce <= 1'b0;
		else
			ce <= 1'b1;
	end

	always @(posedge clk)
	begin
		if(ce == 1'b1)
			pc <= pc + 4;
		else
			pc <= 32'b0;
	end

endmodule