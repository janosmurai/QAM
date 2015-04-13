`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:57:19 04/13/2015
// Design Name:   top_level
// Module Name:   C:/Users/murai/Documents/vik_bme_msc/logikai_tervezes/hazi_feladat/qam/test_top_koli_jani.v
// Project Name:  qam
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top_level
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_top_koli_jani;

	// Inputs
	reg clk;
	reg rst;
	reg elojel_sin;
	reg elojel_cos;

	// Outputs
	wire [15:0] mixed_signal;
	wire [15:0] sampled_sine_test;
	wire [15:0] sampled_cosine_test;
	
	integer sin_out;
	integer cos_out;	

	// Instantiate the Unit Under Test (UUT)
	top_level uut (
		.clk(clk), 
		.rst(rst), 
		.elojel_sin(elojel_sin), 
		.elojel_cos(elojel_cos), 
		.mixed_signal(mixed_signal), 
		.sampled_sine_test(sampled_sine_test), 
		.sampled_cosine_test(sampled_cosine_test)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		elojel_sin = 0;
		elojel_cos = 0;
		
		sin_out = $fopen("sin_output.txt");
		cos_out = $fopen("cos_output.txt");

		// Wait 100 ns for global reset to finish
		#100;
		rst = 0;
        
		// Add stimulus here

	end
	
	always #5
	clk <= ~clk;
	
	always @(posedge clk)
	if(~rst) 
	begin
		$fwrite(sin_out,"%b \n", sampled_sine_test);
		$fwrite(cos_out,"%b \n", sampled_cosine_test);
	end
		
	initial begin
		#200000
			$fclose(sin_out);
			$fclose(cos_out);
	end
      
endmodule

