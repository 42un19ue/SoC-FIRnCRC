`timescale 1ns/1ns
module Fir_tb#(
	parameter	DATA_WIDTH = 32
)();
reg		iClk = 1'b0, iReset_n = 1'b1, iEnable = 1'b1, iControl = 0;
reg		[DATA_WIDTH - 1: 0] ib;
reg		[DATA_WIDTH - 1: 0] ix;
wire	[DATA_WIDTH - 1: 0]	oData;

	always	#10	iClk = ~iClk;

initial begin
		iControl = 0;
	#15 ib = 32'd1;
		
	#25 
		ib = 32'd2;
	#25 
		ib = 32'd3;
	
	#15 
		ib = 32'd4;
	
	#25 
		ib = 32'd5;
	
	#15 
		ib = 32'd6;
	
	#25 
		ib = 32'd7;
	
	#25 
		ib = 32'd8;
	#25 
		ib = 32'd9;
	
	#10
		iControl = 1'b1;
	
	#15
		ix = 32'd1;
	
	#25
		ix = 32'd2;
	
	#25
		ix = 32'd3;
		
	#25
		ix = 32'd4;
		
	#25
		ix = 32'd5;
		
	#25
		ix = 32'd6;
		
	#25
		ix = 32'd7;
		
	#25
		ix = 32'd8;
	
	#100 $stop;
	
end

Fir f(
	.clk(iClk),
	.reset_n(iReset_n),
	.enable(iEnable),
	.control(iControl),
	.b(ib),
	.x(ix),
	.data_out(oData)
);

endmodule