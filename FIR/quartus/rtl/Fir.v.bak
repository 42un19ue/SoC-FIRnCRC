module Fir#(
	parameter	DATA_WIDTH = 32
)(
	input						clk,
	input						reset_n,
	
	input						control,
	input	[DATA_WIDTH - 1: 0] b,
	input	[DATA_WIDTH - 1: 0] x,
	
	output reg	[DATA_WIDTH - 1: 0]	data_out
);
	reg		[DATA_WIDTH - 1 : 0] 	b_array [8 : 0];
	reg		[DATA_WIDTH - 1 : 0] 	x_array [8 : 0];
	reg		[DATA_WIDTH - 1 : 0] 	h 		[8 : 0];
	reg		[DATA_WIDTH - 1 : 0]	s;
	integer i;
	
	initial begin
		for (i = 0; i < 8; i = i + 1) begin
                b_array[i] <= 32'd0;
				x_array[i] <= 32'd0;
				h[i] <= 32'd0;
        end
	
	end
	
	always @(posedge clk) begin
		if ((control == 0)) begin
                for (i = 0; i < 8; i = i + 1) begin
                    b_array[i] <= b_array[i + 1];
                end
                b_array[8] <= b;
		end
		
	end
	
	always @(posedge clk or negedge reset_n) begin
        if (~reset_n) begin
            // Reset logic here, if needed
        end else if (control == 1) begin
            // Shift x_array
            for (i = 8; i > 0; i = i - 1) begin
                x_array[i] <= x_array[i - 1];
            end
            x_array[0] <= x;
        end
    end
    
    always @* begin
        // Compute FIR stages
        for (i = 0; i < 9; i = i + 1) begin
            h[i] = x_array[i] * b_array[i];
        end
        // Output data
        s = h[0] + h[1] + h[2] + h[3] + h[4] + h[5] + h[6] + h[7] + h[8];
    end
	
	// Assign the output
    always @(posedge clk) begin
        data_out <= s;
    end
	
endmodule