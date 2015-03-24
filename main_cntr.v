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
module main_cntr(
    input clk,
    input rst,
	 input fpp,
	 input fmm,
    output en_clk
    );

reg [15:0] cntr_reg; 

//Create the main counter
always @ (posedge clk)
begin
	if(rst) cntr_reg <= 0;
	else cntr_reg <= cntr_reg + 1;
end

reg [3:0] freq_select;
//Set the correct frequncy
always @ (posedge clk)
begin
	if(rst) freq_select <= 15;
	else if(fpp && (freq_select < 15)) freq_select <= freq_select + 1;
	else if(fmm && (freq_select > 0)) freq_select <= freq_select - 1;
end

assign en_clk = cntr_reg[freq_select];

endmodule