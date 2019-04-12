`include "define.v"

module ID(
	input wire rst,
	
	// ?IF-ID???
	// pc_i: PC
	// inst: ??
	input wire[`InstAddrBus] pc_i,
	input wire[31:0] inst,
	
	// ???RegistFile?
	// rs_addr: ???1???
	// rt_addr: ???2???
	output reg[`RegAddrBus] rs_addr,
	output reg[`RegAddrBus] rt_addr,

	// ?RegistFile???
	// rs_data: ???1??
	// rt_data: ???2??
	input wire[`DataBus] rs_data,
	input wire[`DataBus] rt_data,

	// ???ID-EX?
	// alu_op: ALU????
	// src_data1: ???1??
	// src_data2: ???2??
	// imm32_o: ????32?????16->32?26->32?
	// write_reg_addr: ???????
	output reg[4:0] alu_op,
	output reg[`DataBus] src_data1,
	output reg[`DataBus] src_data2,
	output reg[`RegAddrBus] write_reg_addr,
	output reg[`CtrlBus] control_signal,
	output reg[31:0] mem_write_data
);
	//??
	wire[5:0] funct;
	assign funct = inst[5:0];
	wire[4:0] shamt;
	assign shamt = inst[10:6];
	wire[5:0] opcode;
	assign opcode = inst[31:26];
	wire[4:0] rs;
	assign rs = inst[25:21];
	wire[4:0] rt;
	assign rt = inst[20:16];
	wire[4:0] rd;
	assign rd = inst[15:11];
	wire[15:0] imm_16;
	assign imm_16 = inst[15:0];
	wire[25:0] imm_26;
	assign imm_26 = inst[25:0];


	// /*control_signal*/
	// reg wirte_reg_sel;			//0
	// reg second_src_sel;			//1
	// reg write_back_scr_sel;		//2
	// reg write_back_en;			//3
	// reg mem_read_en;				//4
	// reg mem_write_en;			//5
	// reg[1:0] next_pc_src_sel;	//6 7

	//???????
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

	//ALU??????
	always @(inst)
	begin
		if (rst == 1'b1)
			alu_op <= 5'b0;
		else
		case(opcode)
			`SPECIAL:
			begin
				case(funct)
					/*????*/
					`f_SLL:		alu_op <= `alu_SLL;
					`f_SRL:		alu_op <= `alu_SRL;
					`f_SRA:		alu_op <= `alu_SRA;
					`f_SLLV:	alu_op <= `alu_SLL;
					`f_SRLV:	alu_op <= `alu_SRL;
					`f_SRAV:	alu_op <= `alu_SRA;
					/*????*/
					`f_ADD:		alu_op <= `alu_ADD;
					`f_ADDU:	alu_op <= `alu_ADDU;
					`f_SUB:		alu_op <= `alu_SUB;
					`f_SUBU:	alu_op <= `alu_SUBU;
					//f_SLT f_SLTU
					`f_MULT:	alu_op <= `alu_MULT;
					`f_MULTU:	alu_op <= `alu_MULTU;
					`f_DIV:		alu_op <= `alu_DIV;
					`f_DIVU:	alu_op <= `alu_DIVU;
					/*????*/
					`f_AND:		alu_op <= `alu_AND;
					`f_OR:		alu_op <= `alu_OR;
					`f_XOR:		alu_op <= `alu_XOR;
					`f_NOR:		alu_op <= `alu_NOR;
					default:	alu_op <= 5'd0;
				endcase
			end //end SPECIAL
			/*????*/

			/*????*/
			`op_ADDI:	alu_op <= `alu_ADD;
			`op_ADDIU:	alu_op <= `alu_ADDU;
			//op_SLTI op_SLTIU
			`op_ANDI:	alu_op <= `alu_AND;
			`op_ORI:	alu_op <= `alu_OR;
			`op_XORI:	alu_op <= `alu_XOR;
			//op_LUI

			/*L-S??*/

			default:	alu_op <= 5'd0;
		endcase 
	end	//end ALU??????
	
	/*control_signal ????
	--------------------------------------------------------------------
	| ? |     ??                 ??
	-------------------------------------------------------------------
	| 0 |  write_reg_addr       ???????          0:rt     1:rd
	| 1 |  second_scr           ALU????????     0:Imm    1:Reg
	| 2	|  write_back_scr       ???????          0:Mem    1:Reg
	| 3 |  write_back_en        ???????          0:???  1:??
	--------------------------------------------------------------------
	| 4 |  mem_read_en          ??????            0:???  1:???
	| 5 |  mem_write_en         ??????            0:???  1:???
	| 6 |  next_pc_src          ???????         00:PC+4   01:J Reg
	| 7 |                                             10:J Imm  11:Bench
	--------------------------------------------------------------------*/
	//??????
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
		//???????PC+4
		control_signal[7:6] <= 2'b00;
		//???????
		if(control_signal[0] == 1'b0)
			write_reg_addr <= rt;
		else
			write_reg_addr <= rd;
		//????????
		mem_write_data <= rt_data;
		//???????
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