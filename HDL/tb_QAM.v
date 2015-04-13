`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:25:30 03/10/2015
// Design Name:   random
// Module Name:   C:/Users/VeszelyDr/QAM_1/tb_QAM.v
// Project Name:  QAM_1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: random
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_QAM;

	// Inputs
	reg clk;
	reg rst;
	// Outputs
	

wire adat_be_S;
wire data_change;
wire [27:0] shift_reg;
Adat_Gen Adat  (
	.clock(clk),
	.reset(rst),
	.adat_ki(adat_be_S),
	.data_change(data_change),
	.shift_reg(shift_reg)
);

wire [1:0]elojel_sin_cos;
wire [1:0]parallel_reg;
wire data_change_cntr;
S2P sor2par(
	.clock(clk),
	.reset(rst),
	.adat_be_S(adat_be_S),
	.data_change,
	.elojel_sin_cos(elojel_sin_cos),
	.parallel_reg(parallel_reg),
	.data_change_cntr(data_change_cntr)
);
	initial begin
		// Initialize Inputs
		clk = 0;
		rst=1;
		// Wait 100 ns for global reset to finish
		#100;
        rst=0;
		// Add stimulus here
	
	end
      always #5 clk= ~clk;
endmodule

