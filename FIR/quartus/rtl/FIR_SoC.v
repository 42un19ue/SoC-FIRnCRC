module FIR_SoC(
	input	CLOCK_50,
	input	[0:0] KEY
);
	system u_sys (
		.clk_clk(CLOCK_50),
		.reset_reset_n(KEY[0])
	);


endmodule