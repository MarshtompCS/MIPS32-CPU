//test_bench.v
module test_bench;

	reg clk;
	reg rst;

	initial
	begin
		clk = 1'b0;
		forever #10 clk = ~clk;
	end

	initial
	begin
		rst = 1'b1;
		#200 rst = 1'b0;
		#120 $stop;
	end

	cpu  u_cpu (
		.clk                     ( clk   ),
		.rst                     ( rst   )
	);
	

endmodule