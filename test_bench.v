//test_bench.v
//仿真模块
module test_bench;

	reg CLOCK;
	reg RST;
	wire[31:0] inst;

	initial
	begin
		CLOCK = 1'b0
		//10ns翻转一次，周期为20ns，f=50MHZ
		forever #10 CLOCK = ~CLOCK;
	end

	//初始化需要对所有模块置位
	//初始化仿真运行的时间
	initial
	begin
		rst = 1'b1;
		#200 rst = 1'b0;
		#1000 $stop;
	end

	inst_fetch inst_fetch0(
		.clk(CLOCK)
		.rst(RST)
		.inst_o(inst)
	);

endmodule