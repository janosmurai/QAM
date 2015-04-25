`timescale 1ns / 1ps

module Adat_Gen(
    input clock,
    input reset,
	 input enable_cntr,
    output adat_ki,
	 output data_change
    );

/***********************************************************/	 
/*Detecting the rising edge of enable counter*/
/***********************************************************/
reg old_enable_cntr;
reg enable_cntr_rise;

always @ (posedge clock)
begin
if(reset)old_enable_cntr<=0;
old_enable_cntr<=enable_cntr;
end

always @(posedge clock)
begin
	if(reset) enable_cntr_rise <= 0;
	else enable_cntr_rise <= (~old_enable_cntr && enable_cntr);
end
/***********************************************************/


/***********************************************************/
/*Generating test data*/
/***********************************************************/
reg [9:0] cntr; 
reg [27:0] shift_reg;

always @ (posedge clock)
begin
if(reset)begin
			cntr<=0;
			shift_reg<=28'b0110_1100_1100_0001_0101_0101_0101;
			// sin         0 1 _1 0 _1 0 _0 0 _0 0 _0 0 _0 0 
			// cos          1 0_ 1 0_ 1 0_ 0 1_ 1 1_ 1 1_ 1 1
			end
else if (cntr == 510) cntr <= 0;
else if(enable_cntr_rise)
		begin
			if(cntr==509)
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
/***********************************************************/


/***********************************************************/
/*Connecting output data and the timing signal*/
/* to the module outputs*/
/***********************************************************/
assign adat_ki=shift_reg[27];
assign data_change =(cntr==510) ? 1:0;
/***********************************************************/

endmodule
