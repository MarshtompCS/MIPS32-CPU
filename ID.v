`include "define.v"
module ID(
	input wire rst,
	input wire[`InstAddrBus] pc_i,
	input wire[31:0] inst,
	output reg[`RegAddrBus] rs_addr,
	output reg[`RegAddrBus] rt_addr,
	
	input wire[`DataBus] rs_data,
	input wire[`DataBus] rt_data,
	
	output reg[4:0] alu_op,
	output reg[`DataBus] src_data1,
	output reg[4:0] src1_reg_addr,
	output reg[`DataBus] src_data2,
	output reg[4:0] src2_reg_addr,

	output reg[`RegAddrBus] write_reg_addr,
	output reg[`CtrlBus] control_signal,
	output reg[31:0] mem_write_data


);
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

	//ALUè¿�ç®—ç±»åž‹é€‰æ‹©
	always @(inst)
	begin
		if (rst == 1'b1)
			alu_op <= 5'b0;
		else
		case(opcode)
			`SPECIAL:
			begin
				case(funct)
					/*ä½�ç§»è¿�ç®—*/
					`f_SLL:		alu_op <= `alu_SLL;
					`f_SRL:		alu_op <= `alu_SRL;
					`f_SRA:		alu_op <= `alu_SRA;
					`f_SLLV:	alu_op <= `alu_SLL;
					`f_SRLV:	alu_op <= `alu_SRL;
					`f_SRAV:	alu_op <= `alu_SRA;
					/*ç®—æœ¯è¿�ç®—*/
					`f_ADD:		alu_op <= `alu_ADD;
					`f_ADDU:	alu_op <= `alu_ADDU;
					`f_SUB:		alu_op <= `alu_SUB;
					`f_SUBU:	alu_op <= `alu_SUBU;
					//f_SLT f_SLTU
					`f_MULT:	alu_op <= `alu_MULT;
					`f_MULTU:	alu_op <= `alu_MULTU;
					`f_DIV:		alu_op <= `alu_DIV;
					`f_DIVU:	alu_op <= `alu_DIVU;
					/*é€»è¾‘è¿�ç®—*/
					`f_AND:		alu_op <= `alu_AND;
					`f_OR:		alu_op <= `alu_OR;
					`f_XOR:		alu_op <= `alu_XOR;
					`f_NOR:		alu_op <= `alu_NOR;
					default:	alu_op <= 5'd0;
				endcase
			end //end SPECIAL
			/*è·³è½¬æŒ‡ä»¤*/

			/*ç®—é€»è¿�ç®?*/
			`op_ADDI:	alu_op <= `alu_ADD;
			`op_ADDIU:	alu_op <= `alu_ADDU;
			//op_SLTI op_SLTIU
			`op_ANDI:	alu_op <= `alu_AND;
			`op_ORI:	alu_op <= `alu_OR;
			`op_XORI:	alu_op <= `alu_XOR;
			//op_LUI

			/*L-SæŒ‡ä»¤*/

			default:	alu_op <= 5'd0;
		endcase 
	end	//end ALUè¿�ç®—ç±»åž‹é€‰æ‹©
	
	/*control_signal æŽ§åˆ¶ä¿¡å�·
	--------------------------------------------------------------------
	| ä½? |     å��ç§°                 åŠŸèƒ½
	-------------------------------------------------------------------
	| 0 |  write_reg_addr       å†™å…¥å¯„å­˜å™¨é€‰æ‹©          0:rt     1:rd
	| 1 |  second_scr           ALUç¬?äºŒä¸ªæ“�ä½œæ•°æ�¥æº?     0:Imm    1:Reg
	| 2	|  write_back_scr       å†™å›žçš„æ•°æ�?æ�¥æº�          0:Mem    1:Reg
	| 3 |  write_back_en        å¯„å­˜å™¨å†™å›žä½¿èƒ?          0:ä¸�å†™å›?  1:å†™å›ž
	--------------------------------------------------------------------
	| 4 |  mem_read_en          å­˜å‚¨å™¨è?»ä½¿èƒ?            0:ç¦�æ?¢è??  1:å…�è?¸è??
	| 5 |  mem_write_en         å­˜å‚¨å™¨å†™ä½¿èƒ½            0:ç¦�æ?¢å†™  1:å…�è?¸å†™
	| 6 |  next_pc_src          ä¸‹ä¸€æ�¡æŒ‡ä»¤æ�¥æº?         00:PC+4   01:J Reg
	| 7 |                                             10:J Imm  11:Bench
	--------------------------------------------------------------------*/
	//æŽ§åˆ¶ä¿¡å�·è®¾ç½®
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
		control_signal[7:6] <= 2'b00;
		if(control_signal[0] == 1'b0)
			write_reg_addr <= rt;
		else
			write_reg_addr <= rd;
		mem_write_data <= rt_data;
		
		/*src1选择*/
		if(opcode == `SPECIAL && (funct == `f_SRL || funct == `f_SRA || funct == `f_SLL))
		begin
			src_data1 <= {27'b0, shamt};
			src1_reg_addr <= `NotRegSrc;
		end
		else
		begin
			src_data1 <= rs_data;
			src1_reg_addr <= rs_addr;
		end

		/*src2选择*/
		if(control_signal[1] == 1'b0)
		begin
			src_data2 <= {16'b0, imm_16};
			src2_reg_addr <= `NotRegSrc;
		end
		else
		begin
			src_data2 <= rt_data;
		end
	end

endmodule