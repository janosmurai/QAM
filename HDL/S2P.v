`timescale 1ns / 1ps


module S2P(
    input clock,
    input reset,
    input adat_be_S,
	 input data_change,
	
	 output  [1:0] elojel_sin_cos

	 
);

/***********************************************************/
/*Beérkezõ bitek számolása*/
/***********************************************************/
reg  data_change_cntr=1;

always @(posedge clock)
begin
	if(reset)
	begin
		data_change_cntr<=1;
	end
	
	else if(data_change)
				begin
					data_change_cntr <= data_change_cntr + 1;
				end		
end
/***********************************************************/

/****************************************************************/
/*A beérkezõ bitekkel feltölteni egy két bites shift regisztert*/
/****************************************************************/
reg [1:0] shift_reg;
always @ (posedge clock)

begin
if(reset) 
	begin 
		shift_reg<=0; 
	end
else
	if(data_change)
		begin
			shift_reg<={shift_reg[0],adat_be_S};
		end
end
/***********************************************************/


/***********************************************************/
/*Ha bejött két bit a shift regiszeterbe ki átrakjuk õket*/
/*egy párhuzamos kimeneti pufferbe*/
/***********************************************************/
reg [1:0] parallel_reg;

always @(posedge clock)
begin
	if(reset)
	begin
		parallel_reg <= 0;
	end
	
	else if( !data_change_cntr && data_change)
			begin
				parallel_reg <= shift_reg;
			end
end
/***********************************************************/



/***********************************************************/
/*Kimeneti szimbólum*/
/***********************************************************/
assign  elojel_sin_cos = parallel_reg;
/***********************************************************/

endmodule
