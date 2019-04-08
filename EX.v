`include "define.v"

module EX(
	input wire rst,
	input wire clk,

	input wire[`AluOpBus] aluop_i,
	input wire[`AluOpTypeBus] aluoptype_i,
	input wire[`RegBus] reg1_data_i,
	input wire[`RegBus] reg2_data_i,
	input wire[`RegBus] rd_addr_i,
	input wire rd_write_i,

	output reg[`RegAddrBus] rd_addr_o,
	output reg rd_write_o,
	output reg[`RegBus] write_data_o,
);

	//逻辑运算结果
	reg[`RegBus] optype_logic;


	//根据操作吗opcode执行操作
	//包括算术运算、逻辑运算、Load-Store
	//最后再根据运算类型选择输出的结果
	always @(*)
	begin
		if(rst == 1'b1)
		begin
			rd_addr_o <= 5'b0;
			rd_write_o <= 1'b0;
			optype_logic <= 32'b0;
		end
		else
		begin
			case(aluop_i)
				`EXE_OR_OP:
				begin
					optype_logic <= reg1_data_i | reg2_data_i;
				end
				default:
				begin
					optype_logic <= 32'b0;
				end
			endcase
		end
	end


	//根据运算类型选择输出结果
	always @(*)
	begin
		rd_addr_o <= rd_addr_i;
		rd_write_o <= rd_write_i;
		case(aluoptype_i)
			`EXE_RES_LOGIC:
			begin
				write_data_o <= optype_logic;
			end
			default: 
			begin
				write_data_o <= 32'b0;
			end
		endcase
	end
	
endmodule