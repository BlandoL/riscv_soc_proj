//*******************************************************************************
// Project      : 
// Module       : sync.v
// Description  :
// Designer     :
// Version      : 
//********************************************************************************
module sync #(parameter sw = 1)
(
input   [sw-1:0]        din,
input                   clk,
output  [sw-1:0]        dout
);

reg [sw-1:0] t0;
reg [sw-1:0] t1;
assign dout = t1;

always @(negedge clk)
begin
    t0 <= #1 din;
end

always @(posedge clk)
begin
    t1 <= #1 t0;
end


//********************************************************************************
//
// END of Module
//
//********************************************************************************
endmodule
