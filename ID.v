`include "define.v"

module ID(
	input wire rst,
	input wire clk,
	
	// 从IF-ID读到的
	// pc_i: PC
	// inst: 指令
	input wire[`InstAddrBus] pc_i,
	input wire[`InstBus] inst_i,
	
	// 输出到RegistFile的
	// reg1_addr_o: 寄存器1的地址
	// reg2_addr_o: 寄存器2的地址
	output reg[`RegAddrBus] reg1_addr_o,
	output reg[`RegAddrBus] reg2_addr_o,

	// 从RegistFile读到的
	// reg1_data_i: 寄存器1的值
	// reg2_data_i: 寄存器2的值
	input wire[`DataBus] reg1_data_i,
	input wire[`DataBus] reg2_data_i,

	// 输出到ID-EX的
	// opcde_o: 操作码
	// funct_o: 功能码
	// shamt_o: 位移数
	// reg1_data_o: 寄存器1的值
	// reg2_data_o: 寄存器2的值
	// imm32_o: 处理后的32位立即数（16->32或26->32）
	// write_en: 写寄存器使能型号
	// write_reg_addr: 写寄存器的地址
	output reg[5:0] opcode_o,
	output reg[5:0] funct_o,
	output reg[4:0] shamft_o,
	output reg[`DataBus] reg1_data_o,
	output reg[`DataBus] reg2_data_o,
	output reg write_en,
	output reg[`RegAddrBus] write_reg_addr
);


	//解析
	wire[5:0] funct = inst_i[5:0];
	wire[4:0] shamt = inst[10:6];
	wire[5:0] opcode = inst[31:26];
	wire[4:0] rs = inst[25:21];
	wire[4:0] rt = inst[20:16];
	wire[4:0] rd = inst[15:11];
	wire[15:0] imm_16 = inst_i[15:0];
	wire[25:0] imm_26 = inst_i[25:0];
	
	//指令有效=1
	reg inst_valid;


	//从寄存器读数据
	always @(*)
	begin
		if(rst == 1'b1)
		begin
			reg1_addr_o <= 5'b0;
			reg2_addr_o <= 5'b0;
		end
		else
		begin
			reg1_addr_o <= rs;
			reg2_addr_o <= rt;
		end
	end

	//译码到下一阶段
	always @(*)
	begin
		if(rst == 1'b1)
		begin
			opcde_o <= 6'b0;
			funct_o <= 6'b0;
			shamft_o <= 5'b0;
			reg1_data_o <= `ZeroWord;
			reg2_data_o <= `ZeroWord;
			write_en <= 1'b0;
			write_reg_addr <= 5'b0;
		end
		else
		begin
			/****单bit控制信号****/
			// 选择写寄存器哪一个
			if(opcode == 6'b0)
				write_reg_addr <= rd;
			else
				write_reg_addr <= rt;
			// 选择ALU第二个操作数来源
			if(opcde == 6'b0 && opcde != )

		end	

	end	

	
	//第一阶段：指令译码
	always @(*)
	begin
		if(rst == 1'b1)
		begin
			aluop_o <= `EXE_NOP_OP;
			aluoptype_o <= `EXE_RES_NOP;
			rd_addr_o <= `NOPRegAddr;
			rd_write_o <= 1'b0;
			insta_valid <= 1'b0; //指令无效
			reg1_en <= 1'b0;
			reg2_en <= 1'b0;
			reg1_addr_o <= `NOPRegAddr;
			reg2_addr_o <= `NOPRegAddr;
			imm <= 32'b0;
		end
		else
		begin
			aluop_o <= `EXE_NOP_OP;
			aluoptype_o <= `EXE_RES_NOP;
			rd_write_o <= 1'b0; //不写
			rd_addr_o <= write_reg
			inst_valid <= 1'b1; //指令有效
			
			/*非阻塞中，相同对象的顺序赋值*/
			reg1_en <= 1'b0;
			reg2_en <= 1'b0;
			/*      */
			reg1_addr_o <= read_reg1;
			reg2_addr_o <= read_reg2;
			imm <= 32'b0;

			case (opcode)
				`EXE_ORI:
				begin
					rd_write_o <= 1'b1;
					aluop_o <= `EXE_OR_OP;
					aluoptype_o <= `EXE_RES_LOGIC;
					reg1_en <= 1'b1;
					reg2_en <= 1'b0;
					imm <= {16'b0, imm_16};
					rd_write_o <= write_reg;
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
		else if(reg1_en == 1'b1)
			reg1_data_o <= reg1_data_i; 
		else if(reg1_en == 1'b0)
			reg1_data_o <= imm;
		else:
			reg1_data_o <= 32'b0;
	end
	always @(*)
	begin
		if(rst == 1'b0)
			reg2_data_o <= 32'b0;
		else if(reg2_en == 1'b1)
			reg2_data_o <= reg2_data_i; 
		else if(reg2_en == 1'b0)
			reg2_data_o <= imm;
		else:
			reg2_data_o <= 32'b0;
	end

endmodule