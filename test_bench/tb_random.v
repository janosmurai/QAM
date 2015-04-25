`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:53:31 03/10/2015
// Design Name:   Random_Gen
// Module Name:   C:/Users/VeszelyDr/QAM_1/tb_random.v
// Project Name:  QAM_1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Random_Gen
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_random;

	// Inputs
	reg clock;
	reg rst;

	// Outputs
	wire rnd;

	// Instantiate the Unit Under Test (UUT)
	Random_Gen uut (
		.clock(clock), 
		.reset(rst), 
		.rnd(rnd)
	);

	initial begin
		// Initialize Inputs
		clock = 0;
		rst = 1;

		// Wait 100 ns for global reset to finish
		#100;
        rst = 0;
		// Add stimulus here
		

	end
      always #5 clock= ~clock;
endmodule

