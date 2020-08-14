//*******************************************************************************
// Project     : 
// Module      : arb.v
// Description :  
// Designer    :
// Version     :  
//********************************************************************************
module arb #(
parameter dw = 16)
(
input [dw-1:0]req,
output reg [dw-1:0]grant
);

//****************************************
// Interial Wire Defination
//****************************************
integer cnt;
reg init; 


//****************************************
// Arbitray
//****************************************
always @(req)
begin
	init = 1'b1;
	for(cnt=0;cnt<dw;cnt=cnt+1)
	begin
		if(init & req[cnt])
		begin
			grant[cnt] = 1'b1;
			init = 1'b0;
		end
		else
		begin
			grant[cnt] = 1'b0;
		end	

	end	
end


//********************************************************************************
//
// End of Module
//
//********************************************************************************
endmodule
