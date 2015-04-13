`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:04:26 09/23/2013 
// Design Name: 
// Module Name:    top_level 
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
module top_level(
    input clk,
    input rst,
	 
	 //test signals
	 input elojel_sin,
	 input elojel_cos,
	 
    output [15:0] mixed_signal,
	 output [15:0] sampled_sine_test,
	 output [15:0] sampled_cosine_test
);

//System Freqency
wire en_clk;

main_cntr 
#(.freq_prescale(0))
main_cntr_(

	.clk(clk),
	.rst(rst),
	.en_clk(en_clk)
);




/*
Random_Gen Random (
	.clock(clk),
	.reset(rst),
	.rnd(adat_be)
);
*/
wire adat_be_S;
wire data_change;
Adat_Gen Adat (
	.clock(clk),
	.reset(rst),
	.adat_ki(adat_be_S),
	.data_change(data_change),
	.enable_cntr(en_clk)
);

wire [1:0] elojel_sin_cos;

S2P sor2par(
	.clock(clk),
	.reset(rst),
	.adat_be_S(adat_be_S),
	.elojel_sin_cos(elojel_sin_cos),
	.data_change(data_change)
);

/*
wire modulated_signal;
wire filtered_modulated_signal;

digit_BPS_filter filter(
	.clock(clk),
	.reset(rst),
	.sgl_in(modulated_signal),
	.sgl_out(filtered_modulated_signal)
);
*/

// Sine and Cosine LUT in block RAM
wire [15:0] sampled_sine;
wire [15:0] sampled_cosine;

sin_cos_lut sin_cos_lut_(
	.clk(clk),
	.rst(rst),
	.en(en_clk),
	.sampled_sine(sampled_sine),
	.sampled_cosine(sampled_cosine)
);

//Mixing the signals
wire [15:0] mixed_signal;
wire [15:0] sampled_sine_out;
wire [15:0] sampled_cosine_out;
mixer mixer_(
	.clk(clk),
	.rst(rst),
	.data_in(elojel_sin_cos),
	.sine_in(sampled_sine),
	.cosine_in(sampled_cosine),
	.signal_out(mixed_signal),
	.sampled_sine_out(sampled_sine_out),
	.sampled_cosine_out(sampled_cosine_out)
);

assign sampled_sine_test = sampled_sine_out;
assign sampled_cosine_test = sampled_cosine_out;

endmodule
