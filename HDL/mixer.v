`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:47:17 03/24/2015 
// Design Name: 
// Module Name:    mixer 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module mixer(
	 input clk,
	 input rst,
    input [1:0] data_in,
    input [15:0] sine_in,
    input [15:0] cosine_in,
    output [15:0] signal_out
    );

reg [15:0] reg_tmp_sin;
reg [15:0] reg_tmp_cos;

	 
//Mix the signal
// Multiply the sine with:
//			1 if data_in 1
//			-1 if data_in 0

always @(posedge clk)
begin
	if(rst)
	begin
		reg_tmp_sin <= 0;
		reg_tmp_cos <= 0;
	end	
	else 
		begin 
			if (1 == data_in[0])  reg_tmp_cos <= cosine_in;
			if (0 == data_in[0]) reg_tmp_cos <= ~cosine_in + 1;
			if (1 == data_in[1]) reg_tmp_sin <= sine_in;
			if (0 == data_in[1]) reg_tmp_sin <= ~sine_in + 1;
		end
end
	
assign signal_out = reg_tmp_cos + reg_tmp_sin;		//15 bit is enough, becouse sine and cosine can't be 1 at the same time.

endmodule
