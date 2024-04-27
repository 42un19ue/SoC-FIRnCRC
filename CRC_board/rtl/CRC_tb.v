`timescale 1ns/1ns
module CRC_tb#(
	parameter	DATA_WIDTH = 32,
	parameter	CRC_WIDTH = 3,
	parameter	POLYNOMIAL = 3'h3,
	parameter	COUNTER_WIDTH = $clog2(DATA_WIDTH),
	parameter	LSB_DATA_WIDTH = DATA_WIDTH - CRC_WIDTH
)();
reg 							iClk = 1'b0, iReset_n = 1'b1, iWrite = 1'b1, iCs = 1'b1, iRead = 1'b1;
reg	[1:0]						iControl = 2'b00;
reg		[DATA_WIDTH - 1 : 0] 	iData;
wire	[DATA_WIDTH - 1 : 0]		oCRC_result;
wire							done, busy;

	always #10 iClk = ~iClk;
	
	initial begin
		iData =  32'h89CADE; //			
		#20
			iControl = 2'b01;
		#1000 $stop;
	end
	
 	CRC_Slave DUT(
	.clk(iClk),
	.addr(iControl),
	.reset_n(iReset_n),
	.write(iWrite),
	.cs(iCs),
	.read(iRead),
	.write_data(iData),
	.read_data(oCRC_result),
	.read_data_valid(done),
	.wait_req(busy)
	); 
	
/* 	CRC m0(
	.clk(iClk),
	.control(iControl),
	.reset_n(iReset_n),
	.data_in(iData),
	.enable(1'b1),
	.result(oCRC_result),
	.done(done),
	.busy(busy)
	); */
	
endmodule