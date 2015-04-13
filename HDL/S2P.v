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
reg old_data_change_cntr;
reg [1:0] parallel_reg_new;
reg [1:0] parallel_reg_old;
always @(posedge clock)
begin
if(reset) begin  data_change_cntr<=0; end
else if(data_change)
			begin
			data_change_cntr<=data_change_cntr+1;
			old_data_change_cntr <= data_change_cntr;
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

always @(posedge clock)
begin
	if(reset)
	begin
		parallel_reg_new <= 0;
	end
	else if((old_data_change_cntr==1) && (data_change_cntr == 0))
	begin
		parallel_reg_new <= parallel_reg;
	end
end

assign  elojel_sin_cos = parallel_reg_new;

endmodule
