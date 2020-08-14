//*******************************************************************************
// Project      : 
// Module       : timer_multf.v
// Description  : multi-function timer
// Designer     :
// Version      : 
//********************************************************************************

module timer_multf(
input   wire            icb_wr,
input   wire [7:0]      icb_wadr,
input   wire [31:0]     icb_wdat,
output  wire            icb_wack,

input   wire            icb_rd,
input   wire [7:0]      icb_radr,
output  reg  [31:0]     icb_rdat,
output  wire            icb_rack,

output  wire            timer_int,

input   wire            clk,
input   wire            rst
);

//****************************************************************
//
// include
//
//****************************************************************
`include "riscv_reg_addr.v"


//****************************************************************
//
// Internal defination
//
//****************************************************************
wire [255:0] icb_wbus;
wire [255:0] icb_rbus;
wire         timer_con_wr;
wire         timer_cnt_wr;
wire         timer_val_wr;

wire [31:0]  timer_con;
reg  [31:0]  timer_cnt;
reg  [31:0]  timer_prd;

wire         timer_clk;
reg          timer_pend;

reg          timer_en;
reg          timer_ie;
reg          timer_pnd_clr;


//****************************************************************
//
// reg file dec
//
//****************************************************************
icb_dec #(.aw(8)) icb_dec(
    .icb_wr         (icb_wr             ),
    .icb_wadr       (icb_wadr           ),
    .icb_rd         (icb_rd             ),
    .icb_radr       (icb_radr           ),

    .icb_wbus       (icb_wbus           ),
    .icb_rbus       (icb_rbus           ) 
);

assign icb_wack = icb_wr;
assign icb_rack = icb_rd;

assign timer_con_wr = icb_wbus[`rv_cfg_timer_con];
assign timer_cnt_wr = icb_wbus[`rv_cfg_timer_cnt];
assign timer_val_wr = icb_wbus[`rv_cfg_timer_value];

always @(*)
begin
    case(1'b1)   // synopsys parallel_case
        icb_rbus[`rv_cfg_timer_con]    : icb_rdat = timer_con;
        icb_rbus[`rv_cfg_timer_cnt]    : icb_rdat = timer_cnt;
        icb_rbus[`rv_cfg_timer_value]  : icb_rdat = timer_prd;
        default:                         icb_rdat = 32'd0;
    endcase
end


//****************************************************************
//
// reg config
//
//****************************************************************
wire timer_en_in = timer_con_wr ? icb_wdat[0] : timer_en;
wire timer_ie_in = timer_con_wr ? icb_wdat[1] : timer_ie;
wire timer_pnd_clr_in = timer_con_wr ? icb_wdat[8] : 1'b0;
wire [31:0] timer_prd_in = timer_val_wr ? icb_wdat[31:0] : timer_prd;

assign timer_con = {23'd0, 1'd0, 6'd0, timer_ie, timer_en};


//****************************************************************
//
// clock gating
//
//****************************************************************
wire  clk_en = timer_en | timer_con_wr | timer_cnt_wr | timer_val_wr;
CLKLANQHDV4 clock_gate(.Q(timer_clk), .CK(clk), .E(clk_en), .TE(1'b0));


//****************************************************************
//
// timer
//
//****************************************************************
wire timer_end = timer_en & (timer_cnt == timer_prd);
wire [31:0] timer_cnt_in = timer_cnt_wr ? icb_wdat[31:0] :
                           timer_end ? 32'd0 :
                           timer_en ? timer_cnt + 32'd1 : timer_cnt;

wire timer_pend_in = timer_end | timer_pend & !timer_pnd_clr;
assign timer_int = timer_pend & timer_ie;



//****************************************************************
//
// always
//
//****************************************************************
always @(posedge timer_clk or negedge rst)
if(rst == 1'd0)
begin
    timer_en            <= #1 1'd0;
    timer_ie            <= #1 1'd0;
    timer_pnd_clr       <= #1 1'd0;
    timer_prd           <= #1 32'd0;
    timer_cnt           <= #1 32'd0;
    timer_pend          <= #1 1'd0;
end
else
begin
    timer_en            <= #1 timer_en_in;
    timer_ie            <= #1 timer_ie_in;
    timer_pnd_clr       <= #1 timer_pnd_clr_in;
    timer_prd           <= #1 timer_prd_in;
    timer_cnt           <= #1 timer_cnt_in;
    timer_pend          <= #1 timer_pend_in;
end



//********************************************************************************
//
// END of Module
//
//********************************************************************************
endmodule
