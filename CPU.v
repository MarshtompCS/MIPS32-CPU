`include "define.v"

module cpu(
	input wire clk,
	input wire rst
);

	//前缀为输出信号的功能部件
	
	wire[31:0] pc_pc;//PC:pc-->(Inst_Mem:pc,IF_ID:pc)

	wire[31:0] instmem_inst;//Inst_Mem:inst-->IF_ID:inst_i

	wire[31:0] ifid_pc;//IF_ID:pc_o-->ID:pc_i
	wire[31:0] ifid_inst;//IF_ID:inst_o-->ID:inst_i

	wire[4:0] id_rs_addr;//ID:rs_addr-->GPR:rs_addr
	wire[4:0] id_rt_addr;//ID:rt_addr-->GPR:rt_addr
	wire[4:0] id_alu_op;//ID:alu_op-->ID_EX:alu_op_i
	wire[31:0] id_src_data1;//ID:src_data1-->ID_EX:src_data1_i
	wire[31:0] id_src_data2;//ID:src_data2-->ID_EX:src_data2_i
	wire[5:0] id_write_reg_addr;//ID:write_reg_addr-->ID_EX:write_reg_addr_i
	wire[`CtrlBus] id_control_signal;//ID:control_signal-->ID_EX:control_signal_i
	wire[31:0] id_mem_write_data;//ID:mem_write_data-->ID_EX:mem_write_data_i

	wire[31:0] gpr_rs_data;//GPR:rs_data-->ID:rs_data
	wire[31:0] gpr_rt_data;//GPR:rt_data-->ID:rt_data

	wire[4:0] idex_alu_op;//ID_EX:alu_op_o-->ALU:alu_op
	wire[31:0] idex_src_data1;//ID_EX:src_data1-->ALU:src1
	wire[31:0] idex_src_data2;//ID_EX:src_data2-->ALU:src2
	wire[4:0] idex_write_reg_addr;//ID_EX:write_reg_addr_o-->ALU:write_reg_addr_i
	wire[`CtrlBus] idex_control_signal;//ID_EX:control_signal_o-->ALU:control_signal_i
	wire[31:0] idex_mem_write_data;//ID_EX:mem_write_data_o-->ALU:mem_write_data_i

	wire[31:0] alu_result;//ALU:result-->EX_MEM:result_i
	wire[4:0] alu_write_reg_addr;//ALU:write_reg_addr_o-->EX_MEM:write_reg_addr_i
	wire[31:0] alu_mem_write_data;//ALU:mem_write_data_o-->EX_MEM:mem_write_data_i
	wire[`CtrlBus] alu_control_signal;//ALU:control_signal_o-->EX_MEM:control_signal_i

	wire[31:0] exmem_result;//EX_MEM:result_o-->MEM:alu_result
	wire[4:0] exmem_write_reg_addr;//EX_MEM:write_reg_addr_o-->MEM:write_reg_addr_i
	wire[`CtrlBus] exmem_control_signal;//EX_MEM:control_signal_o-->MEM:control_signal_i
	wire[31:0] exmem_mem_write_data;//EX_MEM:mem_write_data_o-->MEM:mem_write_data_i

	wire[31:0] mem_mem_addr;//MEM:mem_addr-->Data_Mem:mem_addr
	wire[31:0] mem_mem_write_data;//MEM:mem_write_data_o-->Data_Mem:mem_write_data
	wire mem_mem_read_en;//MEM:mem_read_en-->Data_Mem:mem_read_en
	wire mem_mem_write_en;//MEM:mem_write_en-->Data_Mem:mem_write_en
	wire[31:0] mem_result;//MEM:result-->MEM_WB:
	wire[4:0] mem_write_reg_addr;//MEM:write_reg_addr_o-->MEM_WB:
	wire[`CtrlBus] mem_control_signal;//MEM:control_signal_o-->MEM_WB:control_signal

	wire[31:0] datamem_mem_result;//Data_Mem:mem_result-->MEM:mem_result

	wire[31:0] memwb_result;//MEM_WB:result_o-->GPR:write_data
	wire[4:0] memwb_write_reg_addr;//MEM_WB:write_reg_addr_o-->GPR:write_reg_addr
	wire memwb_write_reg_en;//MEM_WB:write_reg_en-->GPR:write_reg_en
	
	

PC  u_PC (
	.rst                     ( rst                    ),
	.clk                     ( clk                    ),
	.pc    ( pc_pc   )
);

IF_ID  u_IF_ID (
    .pc_i  ( pc_pc   ),
    .inst_i        ( instmem_inst         ),
    .rst                      ( rst                       ),
    .clk                      ( clk                       ),

    .pc_o   ( ifid_pc    ),
    .inst_o         ( ifid_pc          )
);

ID  u_ID (
    .rst                              ( rst                               ),
    .pc_i          ( ifid_pc           ),
    .inst                  ( instmem_inst                   ),
    .rs_data           ( gpr_rs_data            ),
    .rt_data           ( gpr_rt_data            ),

    .rs_addr         ( id_rs_addr          ),
    .rt_addr         ( id_rt_addr          ),
    .alu_op                  ( id_alu_op                   ),
    .src_data1          ( id_src_data1           ),
    .src_data2          ( id_src_data2           ),
    .write_reg_addr  ( id_write_reg_addr   ),
    .control_signal     ( id_control_signal      ),
    .mem_write_data         ( id_mem_write_data          )
);

ID_EX  u_ID_EX (
    .clk                                ( clk                                 ),
    .rst                                ( rst                                 ),
    .alu_op_i                 ( id_alu_op                 ),
    .src_data1_i             ( id_src_data1              ),
    .src_data2_i             ( id_src_data2              ),
    .write_reg_addr_i         ( id_write_reg_addr          ),
    .control_signal_i    ( id_control_signal     ),
    .mem_write_data_i         ( id_mem_write_data          ),

    .alu_op_o                  ( idex_alu_op                   ),
    .src_data1_o          ( idex_src_data1           ),
    .src_data2_o          ( idex_src_data2           ),
    .write_reg_addr_o  ( idex_write_reg_addr   ),
    .control_signal_o     ( idex_control_signal      ),
    .mem_write_data_o          ( idex_mem_write_data           )
);

ALU  u_ALU (
    .rst                              ( rst                               ),
    .alu_op                 ( idex_alu_op                  ),
    .src1                  ( idex_src_data1                   ),
    .src2                  ( idex_src_data2                   ),
    .write_reg_addr_i       ( idex_write_reg_addr        ),
    .control_signal_i  ( idex_control_signal   ),
    .mem_write_data_i      ( idex_mem_write_data       ),

    .result                 ( alu_result                  ),
    .write_reg_addr_o        ( alu_write_reg_addr         ),
    .mem_write_data_o       ( alu_mem_write_data        ),
    .control_signal_o   ( alu_control_signal    )
);

EX_MEM  u_EX_MEM (
    .clk                              ( clk                               ),
    .rst                              ( rst                               ),
    .result_i              ( alu_result               ),
    .write_reg_addr_i       ( alu_write_reg_addr        ),
    .control_signal_i  ( alu_control_signal   ),
    .mem_write_data_i      ( alu_mem_write_data       ),

    .result_o               ( exmem_result                ),
    .write_reg_addr_o        ( exmem_write_reg_addr         ),
    .control_signal_o   ( exmem_control_signal    ),
    .mem_write_data_o       ( exmem_mem_write_data        )
);

MEM  u_MEM (
    .rst                              ( rst                               ),
    .alu_result            ( exmem_result             ),
    .write_reg_addr_i       ( exmem_write_reg_addr        ),
    .control_signal_i  ( exmem_control_signal   ),
    .mem_write_data_i      ( exmem_mem_write_data       ),
    .mem_result            ( mem_result             ),

    .mem_addr               ( mem_mem_addr                ),
    .mem_write_data_o       ( mem_mem_write_data        ),
    .mem_read_en                      ( mem_mem_read_en                       ),
    .mem_write_en                     ( mem_mem_write_en                      ),
    .result                 ( mem_result                  ),
    .write_reg_addr_o        ( mem_write_reg_addr         ),
    .control_signal_o   ( mem_control_signal    )
);

MEM_WB  u_MEM_WB (
    .rst                            ( rst                             ),
    .clk                            ( clk                             ),
    .result_i            ( mem_result             ),
    .write_reg_addr_i     ( mem_write_reg_addr      ),
    .control_signal  ( mem_control_signal   ),

    .result_o             ( memwb_result              ),
    .write_reg_addr_o      ( memwb_write_reg_addr       ),
    .reg_write_en                   ( memwb_write_reg_en                    )
);

GPR  u_GPR (
    .rst                       ( rst                        ),
    .write_data     ( memwb_result      ),
    .write_reg_addr  ( memwb_write_reg_addr   ),
    .reg_write_en              ( memwb_write_reg_en               ),
    .rs_addr         ( id_rs_addr          ),
    .rt_addr         ( id_rt_addr          ),

    .rs_data      ( gpr_rs_data       ),
    .rt_data      ( gpr_rt_data       )
);

Inst_Mem  u_Inst_Mem (
    .rst                       ( rst                        ),
    .pc  ( pc_pc   ),

    .inst            ( instmem_inst             )
);

Data_Mem  u_Data_Mem (
    .rst                        ( rst                         ),
    .mem_addr        ( mem_mem_addr         ),
    .mem_read_en                ( mem_mem_read_en                 ),
    .mem_write_en               ( mem_mem_write_en                ),
    .mem_write_data  ( mem_mem_write_data   ),

    .mem_result       ( datamem_mem_result        )
);

endmodule
