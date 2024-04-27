module Fir_slave 
#(
	parameter	DATA_WIDTH = 32
)(
	//input	
	input								clk,
	input								reset_n,
	input								write,
	input								read,
	input								cs,
	input		[DATA_WIDTH - 1 : 0]	write_data,
	input		[1:0]					addr,
	
	//output
	output	reg	[DATA_WIDTH - 1 : 0]	read_data 
);
	reg									control;
	reg		[DATA_WIDTH - 1: 0] 		b;
	reg		[DATA_WIDTH - 1: 0] 		x;
	wire		[DATA_WIDTH - 1 : 0]		data_out;
	
	always @(posedge clk, negedge reset_n) begin
		if(~reset_n) begin
			read_data <= 32'd0;
		end else begin
			if(cs & write) begin
				case (addr)
					2'd0: b <= write_data;
					2'd1: x <= write_data;
					2'd2: control <= write_data[0];
				endcase
			end
			
			if(cs & read) begin
				case (addr)
					2'd0: read_data <= 32'd15;
					2'd1: read_data <= data_out;
				endcase
			end
		end
	end
	
Fir f(
	.clk(clk),
	.reset_n(reset_n),
	.control(control),
	.b(b),
	.x(x),
	.data_out(data_out)
);

endmodule