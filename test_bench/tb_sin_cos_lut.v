`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:18:14 03/25/2015
// Design Name:   sin_cos_lut
// Module Name:   C:/Users/murai/Documents/vik_bme_msc/logikai_tervezes/hazi_feladat/qam/tb_sin_cos_lut.v
// Project Name:  qam
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: sin_cos_lut
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_sin_cos_lut;

	// Inputs
	reg clk;
	reg rst;
	reg en;

	// Outputs
	wire [15:0] sampled_sine;
	wire [15:0] sampled_cosine;
	
	integer sin_out;
	integer cos_out;

	// Instantiate the Unit Under Test (UUT)
	sin_cos_lut uut (
		.clk(clk), 
		.rst(rst), 
		.en(en), 
		.sampled_sine(sampled_sine), 
		.sampled_cosine(sampled_cosine)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		en = 0;
		
		sin_out = $fopen("sin_output.txt");
		cos_out = $fopen("cos_output.txt");

		// Wait 100 ns for global reset to finish
		#100;
		rst = 0;
		en = 1;
        
		// Add stimulus here

	end
	
	always #5
	clk <= ~clk;
	
	always @(posedge clk)
	if(en)
	begin
		$fwrite(sin_out,"%b \n", sampled_sine);
		$fwrite(cos_out,"%b \n", sampled_cosine);
	end
	
	initial begin
		#20000 
			$fclose(sin_out);
			$fclose(cos_out);
	end

	
		
endmodule

