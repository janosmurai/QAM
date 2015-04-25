`timescale 1ns / 1ps

module tb_Adat_gen;

	// Inputs
	reg clock;
	reg reset;
	reg enable_cntr;

	// Outputs
	wire adat_ki;
	wire data_change;

	// Instantiate the Unit Under Test (UUT)
	Adat_Gen uut (
		.clock(clock), 
		.reset(reset), 
		.enable_cntr(enable_cntr), 
		.adat_ki(adat_ki), 
		.data_change(data_change)
	);

	initial begin
		// Initialize Inputs
		clock = 0;
		reset = 1;
		enable_cntr = 0;

		// Wait 100 ns for global reset to finish
		#100;
      reset=0;
		end
		// Add stimulus here
		always #5
		clock <= ~clock;
		
		always #10 enable_cntr<=~enable_cntr;

      
endmodule

