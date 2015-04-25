`timescale 1ns / 1ps

module codec_if(
   input  clk,
   input  rst,
   
   output adc_mclk,
   output adc_bclk,
   output adc_lrclk,
   input  adc_din,
   output [1:0]  adc_valid,
   output [23:0] adc_data,

   input   [1:0] dac_din_valid,
   output  [1:0] dac_din_ack,
   input  [47:0] dac_din,
   output dac_mclk,
   output dac_bclk,
   output dac_lrclk,
   output dac_dout
);

// CODEC órajel generátor számláló
//   MCLK: clk/4
//   LRCK: MCLK/256
//   BCLK: LRCK*64
//   Mind az ADC, mind a DAC ugyanazokról az órajelekrõl mûködik
reg [9:0] clk_div = 0;
always @ (posedge clk)
if (rst)
   clk_div <= 0;
else
   clk_div <= clk_div + 1;

assign adc_mclk = clk_div[1];
assign dac_mclk = clk_div[1];

assign adc_bclk = clk_div[3];
assign dac_bclk = clk_div[3];

assign adc_lrclk = clk_div[9];
assign dac_lrclk = clk_div[9];

// ADC/DAC bitszámláló
//  az idõzítõ számláló megfelelõ bitjei
wire [4:0] adc_bcnt;
assign adc_bcnt = clk_div[8:4];

wire [4:0] dac_bcnt;
assign dac_bcnt = clk_div[8:4];


// BCLK lefutó és felfutó él detektálás
wire bclk_rise;
assign bclk_rise = (clk_div[3:0]==4'b0111);
wire bclk_fall;
assign bclk_fall = (clk_div[3:0]==4'b1111);

// ADC bemeneti shift regiszter
reg [23:0] adc_shr;
always @ (posedge clk)
if (bclk_rise==1)
   adc_shr <= {adc_shr[22:0], adc_din};


// Bemeneti adat érvényes
//   egy órajeles impulzus mindkét csatornára (L/R)   
reg adc_valid_l = 0;
reg adc_valid_r = 0;
always @ (posedge clk)
if (rst)
begin
   adc_valid_l <= 0;
   adc_valid_r <= 0;
end
else
begin
   if (bclk_rise==1 & adc_bcnt==31 & clk_div[9]==1)
      adc_valid_l <= 1;
   else
      adc_valid_l <= 0;

   if (bclk_rise==1 & adc_bcnt==31 & clk_div[9]==0)
      adc_valid_r <= 1;
   else
      adc_valid_r <= 0;
end

assign adc_valid = {adc_valid_l, adc_valid_r};
assign adc_data  = adc_shr;


wire dins_valid;
assign dins_valid = (dac_din_valid==2'b11);

// DAC kimeneti shift regiszter
//    alsó 24 bit az érvényes adat, felette 0 legyen a kimenet
//    - megfelelõ idõpontban töltjük, és kiadjuk az ack jelet (ha a bemenet valid, egyébként 0-t adunk ki)
//    - egyébként BCLK-ra ütemezve shiftel
reg [31:0] dac_shr;
always @ (posedge clk)
if (bclk_fall==1)
   if (dac_bcnt==31)
      if (~dins_valid)
         dac_shr <= 0;
      else if (clk_div[9]==0)
         dac_shr <= {8'b0, dac_din[23:0]};
      else
         dac_shr <= {8'b0, dac_din[47:24]};
   else
      dac_shr <= {dac_shr[30:0], 1'b0};
      
assign dac_din_ack[0] = (dins_valid & bclk_fall==1 & dac_bcnt==31 & clk_div[9]==0);
assign dac_din_ack[1] = (dins_valid & bclk_fall==1 & dac_bcnt==31 & clk_div[9]==1);

assign dac_dout = dac_shr[31];

endmodule
