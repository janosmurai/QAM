`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:09:43 04/25/2015
// Design Name:   S2P
// Module Name:   C:/Users/VeszelyDr/QAM_1/S_P_tb.v
// Project Name:  QAM_1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: S2P
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module S_P_tb;

	// Inputs
	reg clock;
	reg reset;
	reg adat_be_S;
	reg data_change;

	// Outputs
	wire [1:0] elojel_sin_cos;

	// Instantiate the Unit Under Test (UUT)
	S2P uut (
		.clock(clock), 
		.reset(reset), 
		.adat_be_S(adat_be_S), 
		.data_change(data_change), 
		.elojel_sin_cos(elojel_sin_cos)
	);

	initial begin
		// Initialize Inputs
		clock = 0;
		reset = 0;
		adat_be_S = 0;
		data_change = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

