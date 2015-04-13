`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:38:54 03/21/2015 
// Design Name: 
// Module Name:    main_cntr 
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
module main_cntr
	#(parameter freq_prescale = 0)
	(
    input clk,
    input rst,
    output en_clk
    );

reg [15:0] cntr_reg; 

//Create the main counter
always @ (posedge clk)
begin
	if(rst) cntr_reg <= 0;
	else cntr_reg <= cntr_reg + 1; 
end

assign en_clk = cntr_reg[freq_prescale];

endmodule