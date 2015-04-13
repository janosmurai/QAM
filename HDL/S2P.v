`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:26:42 03/23/2015 
// Design Name: 
// Module Name:    S2P 
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
module S2P(
    input clock,
    input reset,
    input adat_be_S,
	 input data_change,
    output  [1:0]elojel_sin_cos,
	 output  [1:0 ]parallel_reg,
	 output data_change_cntr
);

reg  data_change_cntr;
always @(posedge clock)
begin
if(reset) begin  data_change_cntr<=0; end
else if(data_change)
			begin
			data_change_cntr<=data_change_cntr+1;
			end
end

reg [1:0] parallel_reg;
always @ (posedge clock)
begin
if(reset) begin  parallel_reg<=0; end
else
	if(data_change)
		begin
			if(data_change_cntr==0)parallel_reg[0]<=adat_be_S;
			else parallel_reg[1]<= adat_be_S;
		end
end

assign  elojel_sin_cos = (data_change_cntr==1)? parallel_reg:elojel_sin_cos;

endmodule
