`include "define.v"

module MEM_WB(
	input wire rst,
	input wire clk,

	input wire['RegBus]	write_data_i,
	input wire[`RegAddrBus] rd_addr_i,
	input wire rd_write_i,

	output reg['RegBus] write_data_o,
	output reg[`RegAddrBus] rd_addr_o,
	output reg rd_write_o 
);

	always @(*)
	begin
		if(rst == 1'b1)
		begin
			write_data_o <= 32'b0;
			rd_addr_o <= 5'b0;
			rd_write_o <= 1'b0;
		end
		else
		begin
			write_data_o <= write_data_i;
			rd_addr_o <= rd_addr_i;
			rd_write_o <= rd_write_i;
		end
	end
	

endmodule