//*******************************************************************************
// Project      : 
// Module       : rand_16b.v
// Description  : 16bit rand number generator
// Designer     :
// Version      : 
//********************************************************************************

module rand_16b(
input   wire            icb_wr,
input   wire [7:0]      icb_wadr,
input   wire [31:0]     icb_wdat,
output  wire            icb_wack,

input   wire            icb_rd,
input   wire [7:0]      icb_radr,
output  reg  [31:0]     icb_rdat,
output  wire            icb_rack,

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

wire         rand_con0_wr;
wire         rand_seed_wr;

wire [31:0]  rand_con0;
wire [31:0]  rand_seed;

reg          rand_en;
reg          rand_load;
reg [15:0]   seed;

reg  [15:0]  rand_num;

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

assign rand_con0_wr = icb_wbus[`rv_cfg_rand_con0];
assign rand_seed_wr = icb_wbus[`rv_cfg_rand_seed];


always @(*)
begin
    case(1'b1)   // synopsys parallel_case
        icb_rbus[`rv_cfg_rand_con0]    : icb_rdat = rand_con0;
        icb_rbus[`rv_cfg_rand_seed]    : icb_rdat = rand_seed;
        default:                         icb_rdat = 32'd0;
    endcase
end


//****************************************************************
//
// reg config
//
//****************************************************************
wire rand_en_in     = rand_con0_wr ? icb_wdat[0] : rand_en;
wire rand_load_in   = rand_con0_wr ? icb_wdat[1] : 1'b0;

wire [15:0] seed_in = rand_seed_wr ? icb_wdat[15:0] : seed;

assign rand_con0 = {30'd0, 1'd0, rand_en};
assign rand_seed = {16'd0, seed};


//****************************************************************
//
// clock gating
//
//****************************************************************
wire clk_en = rand_en | rand_con0_wr | rand_seed_wr;
CLKLANQHDV4 clock_gate(.Q(rand_clk), .CK(clk), .E(clk_en), .TE(1'b0));


//****************************************************************
//
// random lsfr
//
//****************************************************************
always@(posedge rand_clk or negedge rst)
if(rst == `RstEnable)
    rand_num <= 16'b0;
else if(rand_load)
    rand_num <= seed;
else 
begin
    rand_num[0] <=    rand_num[ 0] ^ rand_num[ 1] ^ rand_num[ 5] ^ rand_num[ 6] ^ rand_num[ 8]
                    ^ rand_num[10] ^ rand_num[13];
    rand_num[1] <=    rand_num[ 1] ^ rand_num[ 2] ^ rand_num[ 6] ^ rand_num[ 7] ^ rand_num[ 9]
                    ^ rand_num[11] ^ rand_num[14];
    rand_num[2] <=    rand_num[ 2] ^ rand_num[ 3] ^ rand_num[ 7] ^ rand_num[ 8] ^ rand_num[10]
                    ^ rand_num[12] ^ rand_num[15];
    rand_num[3] <=    rand_num[ 0] ^ rand_num[ 2] ^ rand_num[ 4] ^ rand_num[ 5] ^ rand_num[ 6]
                    ^ rand_num[ 7] ^ rand_num[10] ^ rand_num[12] ^ rand_num[14] ^ rand_num[15];
    rand_num[4] <=    rand_num[ 0] ^ rand_num[ 1] ^ rand_num[ 2] ^ rand_num[ 9] ^ rand_num[10]
                    ^ rand_num[12] ^ rand_num[14];
    rand_num[5] <=    rand_num[ 1] ^ rand_num[ 2] ^ rand_num[ 3] ^ rand_num[10] ^ rand_num[11]
                    ^ rand_num[13] ^ rand_num[15];
    rand_num[6] <=    rand_num[ 0] ^ rand_num[ 4] ^ rand_num[ 5] ^ rand_num[ 6] ^ rand_num[ 7]
                    ^ rand_num[ 8] ^ rand_num[ 9] ^ rand_num[10] ^ rand_num[13] ^ rand_num[15];
    rand_num[7] <=    rand_num[ 0] ^ rand_num[ 1] ^ rand_num[ 2] ^ rand_num[ 3] ^ rand_num[12]
                    ^ rand_num[13] ^ rand_num[15];
    rand_num[8] <=    rand_num[ 0] ^ rand_num[ 1] ^ rand_num[ 4] ^ rand_num[ 5] ^ rand_num[ 6]
                    ^ rand_num[ 7] ^ rand_num[ 8] ^ rand_num[ 9] ^ rand_num[10] ^ rand_num[11]
                    ^ rand_num[12] ^ rand_num[15];
    rand_num[9] <=    rand_num[ 0] ^ rand_num[ 1] ^ rand_num[ 3] ^ rand_num[14] ^ rand_num[15];
    rand_num[10]<=    rand_num[ 0] ^ rand_num[ 1] ^ rand_num[ 3] ^ rand_num[ 4] ^ rand_num[ 5]
                    ^ rand_num[ 6] ^ rand_num[ 7] ^ rand_num[ 8] ^ rand_num[ 9] ^ rand_num[10]
                    ^ rand_num[11] ^ rand_num[12] ^ rand_num[13] ^ rand_num[14];
    rand_num[11]<=    rand_num[ 1] ^ rand_num[ 2] ^ rand_num[ 4] ^ rand_num[ 5] ^ rand_num[ 6]
                    ^ rand_num[ 7] ^ rand_num[ 8] ^ rand_num[ 9] ^ rand_num[10] ^ rand_num[11]
                    ^ rand_num[12] ^ rand_num[13] ^ rand_num[14] ^ rand_num[15];
    rand_num[12]<=    rand_num[ 0];
    rand_num[13]<=    rand_num[ 1];
    rand_num[14]<=    rand_num[ 2];
    rand_num[15]<=    rand_num[ 3];
end


//****************************************************************
//
// always
//
//****************************************************************
always @(posedge rand_clk or negedge rst)
if(rst == 1'd0)
begin
    rand_en             <= #1 1'd0;
    rand_load           <= #1 1'd0;
    seed                <= #1 16'd0;
end
else
begin
    rand_en             <= #1 rand_en_in;
    rand_load           <= #1 rand_load_in;
    seed                <= #1 seed_in;
end


//********************************************************************************
//
// END of Module
//
//********************************************************************************
endmodule
