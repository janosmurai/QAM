`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:15:20 03/23/2015 
// Design Name: 
// Module Name:    Adat_Gen 
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
module Adat_Gen(
    input clock,
    input reset,
    output adat_ki,
	 output data_change,
	 
	 output [7:0]shift_reg
    );
reg [3:0] cntr; /*ird at szimulacio utan 19:0 ra*/
reg [27:0] shift_reg;


always @ (posedge clock)
begin
if(reset)begin
			cntr<=0;
			shift_reg<=28'b0110_1100_1100_0001_0101_0101_0101;
			
			end
else
	begin
	if(cntr==7)
		begin
		cntr<=cntr+1;
		shift_reg<={shift_reg[26:0],shift_reg[27]};
		end
	else 
		begin
		cntr<=cntr+1;
		end
	end

end

assign adat_ki=shift_reg[27];
assign data_change =(cntr==8) ? 1:0;

endmodule
