`include "define.v"

module ID(
	input wire rst,
	//从IF-ID读到的
	input wire[`InstAddrBus] pc_i,
	input wire[`InstBus] inst_i,
	
	//从RegistFile读到的
	input wire[`RegBus] reg1_data_i,
	input wire[`RegBus] reg2_data_i,

	//输出到RegistFile的
	output reg reg1_read_o,
	output reg reg2_read_o,
	output reg[`RegAddrBus] reg1_addr_o,
	output reg[`RegAddrBus] reg2_addr_o,

	//输出到ID-EX的
	output reg[`AluOpBus] aluop_o,
	output reg[`AluSelBus] alusel_o,
	output reg[`RegBus] reg1_data_o,
	output reg[`RegBus] reg2_data_o,
	output reg rd_write_o,
	output reg[`RegAddrBus] rd_addr_o
);

	//功能码
	wire[5:0] funct = inst[5:0];
	wire[4:0] shamt = inst[10:6];
	wire[4:0] unknow = inst[20:16];
	wire[5:0] opcode = inst[31:26];

	//寄存器
	wire[4:0] reg1_addr = inst[25:21];
	wire[4:0] reg2_addr = inst[20:16];
	wire[4:0] rd_addr = inst[15:11];

	//立即数
	wrie[15:0] imm_16 = inst_i[15:0];

	//保存立即数
	reg[`RegBus] imm;
	
	//指令有效=1
	reg inst_valid;
	
	//第一阶段：指令译码
	always @(*)
	begin
		if(rst == 1'b1)
		begin
			aluop_o <= `EXE_NOP_OP;
			alusel_o <= `EXE_RES_NOP;
			rd_addr_o <= `NOPRegAddr;
			rd_write_o <= 1'b0;
			insta_valid <= 1'b0; //指令无效
			reg1_read_o <= 1'b0;
			reg2_read_o <= 1'b0;
			reg1_addr_o <= `NOPRegAddr;
			reg2_addr_o <= `NOPRegAddr;
			imm <= 32'b0;
		end
		else
		begin
			aluop_o <= `EXE_NOP_OP;
			alusel_o <= `EXE_RES_NOP;
			rd_write_o <= 1'b0; //不写
			rd_addr_o <= rd_addr
			inst_valid <= 1'b1; //指令有效
			
			/*非阻塞中，相同对象的顺序赋值*/
			reg1_read_o <= 1'b0;
			reg2_read_o <= 1'b0;
			/*      */
			reg1_addr_o <= reg1_addr;
			reg2_addr_o <= reg2_addr;
			imm <= 32'b0;

			case (opcode)
				`EXE_ORI:
				begin
					rd_write_o <= 1'b1;
					aluop_o <= `EXE_OR_OP;
					alusel_o <= `EXE_RES_LOGIC;
					reg1_read_o <= 1'b1;
					reg2_read_o <= 1'b0;
					imm <= {16'b0, imm_16};
					rd_write_o <= rd_addr;
					//inst_valid <= 1'b1;
				end
				default:
				begin
				end
				
			endcase

		end
	end

	//第二阶段：取操作数
	always @(*)
	begin
		if(rst == 1'b0)
			reg1_data_o <= 32'b0;
		else if(reg1_read_o == 1'b1)
			reg1_data_o <= reg1_data_i; 
		else if(reg1_read_o == 1'b0)
			reg1_data_o <= imm;
		else:
			reg1_data_o <= 32'b0;
	end
	always @(*)
	begin
		if(rst == 1'b0)
			reg2_data_o <= 32'b0;
		else if(reg2_read_o == 1'b1)
			reg2_data_o <= reg2_data_i; 
		else if(reg2_read_o == 1'b0)
			reg2_data_o <= imm;
		else:
			reg2_data_o <= 32'b0;
	end

endmodule