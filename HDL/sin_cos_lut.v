`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:34:43 03/24/2015 
// Design Name: 
// Module Name:    sin_lut_block_ram 
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
module sin_cos_lut(
    input clk,
    input rst,
	 input en,
    output [15:0] sampled_sine,
	 output [15:0] sampled_cosine
    );

reg [15:0] memory [255:0];
reg [15:0] dout_reg_sin;
reg [15:0] dout_reg_cos;
reg [7:0] addr_sin;
reg [7:0] addr_cos = 255;
reg [1:0] part = 0;
reg dir = 0;

initial
	$readmemb("sampled_sinus.txt",memory);

//Itt meg lesz valami idozitesi problemo
always @(posedge clk)
begin
	if (rst) addr_sin <= 0;
	else if (dir == 0 && en)
	begin
		if (addr_sin == 254) 
		begin 
			dir <= 1;
			part <= part + 1;
		end
		addr_sin <= addr_sin + 1;
		addr_cos <= addr_cos - 1;
	end
	else if (dir == 1 && en)
	begin
		if (addr_sin == 1)
		begin
			dir <= 0;
			part <= part + 1;
		end
		addr_sin <= addr_sin - 1;
		addr_cos <= addr_cos + 1;
	end
end

always @(posedge clk)
begin
	if (rst) dout_reg_sin <= 0;
	else
		if (en && ((part == 0) || (part == 1))) dout_reg_sin <= memory[addr_sin];
		else if (en && ((part == 2) || (part == 3))) dout_reg_sin <= ~memory[addr_sin] + 1;
end

always @(posedge clk)
begin
	if(rst) dout_reg_cos <= 0;
	else
		if(en && ((part == 0) || (part == 3))) dout_reg_cos <= memory[addr_cos];
		else if (en && ((part == 1) || (part == 2))) dout_reg_cos <= ~memory[addr_cos] + 1;
end

assign sampled_sine = dout_reg_sin;
assign sampled_cosine = dout_reg_cos;

endmodule
