`timescale 1ns / 1ps

module top_level(
    input  clk,
	 input  rst,
	 
	 output [15:0] mixed_signal,
	 
	 // test signals
	 output [15:0] sampled_sine_test,
	 output [15:0] sampled_cosine_test,
	 output [1:0] parallel

);


// Enable signal generating
wire en_clk;

main_cntr 
#(.freq_prescale(0))
main_cntr_(
	.clk(clk),
	.rst(rst),
	.en_clk(en_clk)
);

// Serial data generation
wire adat_be_S;
wire data_change;
wire data_ready;

Adat_Gen Adat (
	.clock(clk),
	.reset(rst),
	.adat_ki(adat_be_S),
	.data_change(data_change),
	.enable_cntr(en_clk)
);

// Serial to parallel converter
wire [1:0] elojel_sin_cos;

S2P sor2par(
	.clock(clk),
	.reset(rst),
	.adat_be_S(adat_be_S),
	.elojel_sin_cos(elojel_sin_cos),
	.data_change(data_change)
);
assign parallel=elojel_sin_cos;

// Sine and Cosine LUT in block ROM
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
