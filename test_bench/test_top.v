`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:10:56 04/13/2015
// Design Name:   top_level
// Module Name:   C:/Users/murai/Documents/vik_bme_msc/logikai_tervezes/hazi_feladat/qam/test_top.v
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

module test_top;

	// Inputs
	reg clk;
	reg rst;
	reg elojel_sin;
	reg elojel_cos;
	
	reg [15:0]top_cntr;
	reg [29:0]test_samples = 30'b101100101101010101010101010101;

	// Outputs
	wire [15:0] mixed_signal;
	
	integer mixed_out;

	// Instantiate the Unit Under Test (UUT)
	top_level uut (
		.clk(clk), 
		.rst(rst), 
		.elojel_sin(elojel_sin), 
		.elojel_cos(elojel_cos), 
		.mixed_signal(mixed_signal)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		elojel_sin = 0;
		elojel_cos = 0;
		
		mixed_out = $fopen("mixed_out.txt");

		// Wait 100 ns for global reset to finish
		#100;
		rst = 0;
        
		// Add stimulus here

	end
	
	always #5
	clk <= ~clk;
	
	always @(posedge clk)
	if(rst) top_cntr <= 0;
	else top_cntr <= top_cntr + 1;
	
	always @(posedge clk)
	begin
	if(top_cntr[9:0] == 10'b1111111111)
	begin
		test_samples <= {0,test_samples[29:1]};
	end
		elojel_sin <= test_samples[0];
		elojel_cos <= test_samples[0];
	end
	
	always @(posedge clk)
	if(~rst) $fwrite(mixed_out,"%b \n", mixed_signal);
		
	initial begin
		#200000
			$fclose(mixed_out);
	end
	
endmodule

