`include "define.v"

module ID(
	input wire rst,
	
	// 从IF-ID读到的
	// pc_i: PC
	// inst: 指令
	input wire[`InstAddrBus] pc_i,
	input wire[31:0] inst,
	
	// 输出到RegistFile的
	// rs_addr: 寄存器1的地址
	// rt_addr: 寄存器2的地址
	output reg[`RegAddrBus] rs_addr,
	output reg[`RegAddrBus] rt_addr,

	// 从RegistFile读到的
	// rs_data: 寄存器1的值
	// rt_data: 寄存器2的值
	input wire[`DataBus] rs_data,
	input wire[`DataBus] rt_data,

	// 输出到ID-EX的
	// alu_op: ALU运算类型
	// src_data1: 寄存器1的值
	// src_data2: 寄存器2的值
	// imm32_o: 处理后的32位立即数（16->32或26->32）
	// write_reg_addr: 写寄存器的地址
	output reg[4:0] alu_op,
	output reg[`DataBus] src_data1,
	output reg[`DataBus] src_data2,
	output reg[`RegAddrBus] write_reg_addr,
	output reg[`CtrlBus] control_signal,
	output reg[31:0] mem_write_data
);
	//解析
	wire[5:0] funct = inst[5:0];
	wire[4:0] shamt = inst[10:6];
	wire[5:0] opcode = inst[31:26];
	wire[4:0] rs = inst[25:21];
	wire[4:0] rt = inst[20:16];
	wire[4:0] rd = inst[15:11];
	wire[15:0] imm_16 = inst[15:0];
	wire[25:0] imm_26 = inst[25:0];


	// /*control_signal*/
	// reg wirte_reg_sel;			//0
	// reg second_src_sel;			//1
	// reg write_back_scr_sel;		//2
	// reg write_back_en;			//3
	// reg mem_read_en;				//4
	// reg mem_write_en;			//5
	// reg[1:0] next_pc_src_sel;	//6 7

	//输出到寄存器的
	always @(inst)
	begin
		if(rst == 1'b1)
		begin
			rs_addr <= 5'b0;
			rt_addr <= 5'b0;
		end
		else
		begin
			rs_addr <= rs;
			rt_addr <= rt;
		end
	end

	//ALU运算类型选择
	always @(inst)
	begin
		if (rst == 1'b1)
			alu_op <= 5'b0;
		else
		case(opcode)
			`SPECIAL:
			begin
				case(funct)
					/*位移运算*/
					`f_SLL:		alu_op <= `alu_SLL;
					`f_SRL:		alu_op <= `alu_SRL;
					`f_SRA:		alu_op <= `alu_SRA;
					`f_SLLV:	alu_op <= `alu_SLL;
					`f_SRLV:	alu_op <= `alu_SRL;
					`f_SRAV:	alu_op <= `alu_SRA;
					/*算术运算*/
					`f_ADD:		alu_op <= `alu_ADD;
					`f_ADDU:	alu_op <= `alu_ADDU;
					`f_SUB:		alu_op <= `alu_SUB;
					`f_SUBU:	alu_op <= `alu_SUBU;
					//f_SLT f_SLTU
					`f_MULT:	alu_op <= `alu_MULT;
					`f_MULTU:	alu_op <= `alu_MULTU;
					`f_DIV:		alu_op <= `alu_DIV;
					`f_DIVU:	alu_op <= `alu_DIVU;
					/*逻辑运算*/
					`f_AND:		alu_op <= `alu_AND;
					`f_OR:		alu_op <= `alu_OR;
					`f_XOR:		alu_op <= `alu_XOR;
					`f_NOR:		alu_op <= `alu_NOR;
					default:	alu_op <= 5'd0;
				endcase
			end //end SPECIAL
			/*跳转指令*/

			/*算逻运算*/
			`op_ADDI:	alu_op <= `alu_ADD;
			`op_ADDIU:	alu_op <= `alu_ADDU;
			//op_SLTI op_SLTIU
			`op_ANDI:	alu_op <= `alu_AND;
			`op_ORI:	alu_op <= `alu_OR;
			`op_XORI:	alu_op <= `alu_XOR;
			//op_LUI

			/*L-S指令*/

			default:	alu_op <= 5'd0;
		endcase 
	end	//end ALU运算类型选择
	
	/*control_signal 控制信号
	--------------------------------------------------------------------
	| 位 |     名称                 功能
	-------------------------------------------------------------------
	| 0 |  write_reg_addr       写入寄存器选择          0:rt     1:rd
	| 1 |  second_scr           ALU第二个操作数来源     0:Imm    1:Reg
	| 2	|  write_back_scr       写回的数据来源          0:Mem    1:Reg
	| 3 |  write_back_en        寄存器写回使能          0:不写回  1:写回
	--------------------------------------------------------------------
	| 4 |  mem_read_en          存储器读使能            0:禁止读  1:允许读
	| 5 |  mem_write_en         存储器写使能            0:禁止写  1:允许写
	| 6 |  next_pc_src          下一条指令来源         00:PC+4   01:J Reg
	| 7 |                                             10:J Imm  11:Bench
	--------------------------------------------------------------------*/
	//控制信号设置
	always @(inst)
	begin
		case(opcode)
			`SPECIAL:	control_signal <= `ctrl_Rtype;
			`op_ADDI:	control_signal <= `ctrl_Itype;
			`op_ADDIU:	control_signal <= `ctrl_Itype;
			//op_SLTI op_SLTIU
			`op_ANDI:	control_signal <= `ctrl_Itype;
			`op_ORI:	control_signal <= `ctrl_Itype;
			`op_XORI:	control_signal <= `ctrl_Itype;

		endcase 
	end

	always @(*)
	begin
		//默认下一条指令PC+4
		control_signal[7:6] <= 2'b00;
		//写入寄存器选择
		if(control_signal[0] == 1'b0)
			write_reg_addr <= rt;
		else
			write_reg_addr <= rd;
		//写入存储器的数据
		mem_write_data <= rt_data;
		//两个操作数选择
		if(opcode == `SPECIAL && (funct == `f_SRL || funct == `f_SRA || funct == `f_SLL))
			src_data1 <= {27'b0, shamt};
		else
			src_data1 <= rs_data;
		if(control_signal[1] == 1'b0)
			src_data2 <= {16'b0, imm_16};
		else
			src_data2 <= rt_data;

	end

endmodule