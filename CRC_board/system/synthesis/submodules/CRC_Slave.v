module CRC_Slave#(
	parameter	DATA_WIDTH = 32,
	parameter	POLYNOMIAL = 3'h3,
	parameter	CRC_WIDTH = 3,
	parameter 	REFLECTED_INPUT = 0,	//Thu tu bit trong tung byte du lieu co the bi dao nguoc 
	parameter 	REFLECTED_OUTPUT = 0,	//Thu tu bit cua ket qua sau khi duoc tinh toan se duoc dao lai
	parameter 	XOR_OUTPUT = 32'h0
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
 	wire		[DATA_WIDTH - 1 : 0]	data_in_reg;
	reg			[DATA_WIDTH - 1 : 0]	data_in_reg_handled;
	wire		[DATA_WIDTH - 1 : 0]	data_out_reg;
	wire		[CRC_WIDTH - 1 : 0]		data_out_raw;	
	wire		[DATA_WIDTH - 1 : 0]	data_out_temp;	
	reg									control;
	reg			[DATA_WIDTH - 1 : 0]	data_out_temp_1;	
	reg									done;
	wire								read_data_valid;
	//Asynchronous Reset

	always @(posedge clk, negedge reset_n) begin
		if(~reset_n) begin
			read_data <= 32'd0;
			data_in_reg_handled <= 32'd0;
		end else begin
			if(cs & write) begin
				case (addr)
					2'd0: data_in_reg_handled <= {{data_in_reg[DATA_WIDTH - 1 : DATA_WIDTH - CRC_WIDTH]}, {data_in_reg[DATA_WIDTH - CRC_WIDTH - 1 : 0]}};
					2'd1: control <= write_data[0];
				endcase
			end
			
			if(done)
					data_out_temp_1 <= {{(DATA_WIDTH - CRC_WIDTH){1'b0}},(data_out_raw ^ XOR_OUTPUT[CRC_WIDTH - 1 : 0])} ;
			
			if(cs & read) begin
				case (addr)
					2'd0: read_data <= 32'd15;
					2'd1: read_data <= data_out_temp_1;
					2'd2: read_data[0] <= done;
					//{{(DATA_WIDTH - CRC_WIDTH){1'b0}},{data_out_raw}};
				endcase
			end
		end
	end
	
	
	//REFLECTED_INTPUT
	genvar i;
	generate if(REFLECTED_INPUT == 1) begin	
		for(i = 0; i < (DATA_WIDTH/8); i = i + 1) 
		begin: input_reflection
			assign	data_in_reg[i*8 + 0] = write_data[i*8 + 7];
			assign	data_in_reg[i*8 + 1] = write_data[i*8 + 6];
			assign	data_in_reg[i*8 + 2] = write_data[i*8 + 5];
			assign	data_in_reg[i*8 + 3] = write_data[i*8 + 4];
			assign	data_in_reg[i*8 + 4] = write_data[i*8 + 3];
			assign	data_in_reg[i*8 + 5] = write_data[i*8 + 2];
			assign	data_in_reg[i*8 + 6] = write_data[i*8 + 1];
			assign	data_in_reg[i*8 + 7] = write_data[i*8 + 0];
		end
	end
	else	assign	data_in_reg = write_data;
	endgenerate
	
	
	
	//REFLECTED_OUTPUT
	genvar j;
	generate if((REFLECTED_OUTPUT == 1)) begin	
		for(j = 0; j < CRC_WIDTH; j = j + 1) 
		begin: output_reflection
			assign	data_out_raw[j] = data_out_temp[CRC_WIDTH - 1 - j];
		end
	end
	else	assign	data_out_raw = data_out_temp[CRC_WIDTH - 1 : 0];
	endgenerate
	
	always @(posedge clk) begin
		if(~reset_n | ~control)
			done <= 1'b0;
		else if(read_data_valid) 
			done <= 1'b1;
		else
			done <= done;
	end
	
	
	CRC m0(
	.clk(clk),
	.control(control),
	.reset_n(reset_n),
	.data_in(data_in_reg_handled),
	.enable(write),
	.result(data_out_temp),
	.done(read_data_valid)
	);
	defparam m0.CRC_WIDTH = CRC_WIDTH;
	defparam m0.POLYNOMIAL = POLYNOMIAL; 
	
	
endmodule