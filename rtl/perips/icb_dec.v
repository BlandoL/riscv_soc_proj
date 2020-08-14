//*******************************************************************************
// Project     : 
// Module      : icb_dec.v
// Description : internal chip addr decoder
// Designer    :
// Version     : 
//*******************************************************************************

module icb_dec 
#(parameter aw = 8) 
(
input                           icb_wr,
input [aw-1:0]                  icb_wadr, 

input                           icb_rd,
input [aw-1:0]                  icb_radr, 

output reg [(1<<aw)-1:0]        icb_wbus, 
output reg [(1<<aw)-1:0]        icb_rbus
);


//****************************************************************
//
// Internal Defination
//
//****************************************************************
reg [(1<<aw)-1:0] wcnt;
reg [(1<<aw)-1:0] rcnt;


//****************************************************************
//
// icb_dec
//
//****************************************************************
// write
always @(icb_wr or icb_wadr)
begin
	for(wcnt=0;wcnt<(1<<aw);wcnt=wcnt+1)
	begin
		icb_wbus[wcnt] = icb_wr & (icb_wadr[aw-1:0] == wcnt[aw-1:0]);
	end
end


// read
always @(icb_rd or icb_radr)
begin
	for(rcnt=0;rcnt<(1<<aw);rcnt=rcnt+1)
	begin
		icb_rbus[rcnt] = icb_rd & (icb_radr[aw-1:0] == rcnt[aw-1:0]);
	end
end


//********************************************************************************
//
// END of Module
//
//********************************************************************************
endmodule
