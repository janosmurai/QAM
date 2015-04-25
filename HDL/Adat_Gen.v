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
	 input enable_cntr,
    output adat_ki,
	 output data_change
    );
	 
reg [9:0] cntr; 
reg [27:0] shift_reg;
wire enable_cntr_rise;
reg old_enable_cntr;

always @ (posedge clock)
begin
if(reset)old_enable_cntr<=0;
old_enable_cntr<=enable_cntr;
end
assign enable_cntr_rise=!old_enable_cntr&&enable_cntr;

always @ (posedge clock)
begin
if(reset)begin
			cntr<=0;
			shift_reg<=28'b0110_1100_1100_0001_0101_0101_0101;
			// sin         0 1 _1 0 _1 0 _0 0 _0 0 _0 0 _0 0 
			// cos          1 0_ 1 0_ 1 0 _0 1 _1 1 _1 1 _1 1
			end
else if (cntr == 512) cntr <= 0;
else if(enable_cntr_rise)
		begin
			if(cntr==511)
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
assign data_change =(cntr==512) ? 1:0;


endmodule
