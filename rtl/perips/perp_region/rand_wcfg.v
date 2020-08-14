//*******************************************************************************
// Project      : 
// Module       : rand_wcfg.v
// Description  : random , num_bits = 3 ~ 32
// Designer     :
// Version      : 
//********************************************************************************

module rand_wcfg #( parameter num_bits = 32)
(
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
wire [255:0]            icb_wbus;
wire [255:0]            icb_rbus;

wire                    rand_con0_wr;
wire                    rand_seed_wr;

wire [31:0]             rand_con0;
wire [31:0]             rand_seed;

reg                     rand_en;
reg                     rand_load;
reg  [31:0]             seed;

reg [num_bits-1:0]      r_lfsr;
reg                     r_xnor;


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

wire [31:0] seed_in = rand_seed_wr ? icb_wdat[31:0] : seed;

assign rand_con0 = {30'd0, 1'd0, rand_en};
assign rand_seed = seed[31:0];


//****************************************************************
//
// clock gating
//
//****************************************************************
wire clk_en = rand_en | rand_con0_wr | rand_seed_wr;
CLKLANQHDV4 clock_gate(.Q(rand_clk), .CK(clk), .E(clk_en), .TE(1'b0));


//****************************************************************
//
// random function
// note: r_lfsr isn't read by system bus
//
//****************************************************************
wire [num_bits-1:0] r_lfsr_in = rand_en ? (rand_load ? seed[num_bits-1:0] :
                                {r_lfsr[num_bits-2:0], r_xnor}): r_lfsr;

always @(*)  
begin  
    case(num_bits)  
        3: begin  
            r_xnor = r_lfsr[2] ^~ r_lfsr[1];  
        end  
        4: begin  
            r_xnor = r_lfsr[3] ^~ r_lfsr[2];  
        end  
        5: begin  
            r_xnor = r_lfsr[4] ^~ r_lfsr[2];  
        end  
        6: begin  
            r_xnor = r_lfsr[5] ^~ r_lfsr[4];  
        end  
        7: begin  
            r_xnor = r_lfsr[6] ^~ r_lfsr[5];  
        end  
        8: begin  
            r_xnor = r_lfsr[7] ^~ r_lfsr[5] ^~ r_lfsr[4] ^~ r_lfsr[3];  
        end  
        9: begin  
            r_xnor = r_lfsr[8] ^~ r_lfsr[4];  
        end  
        10: begin  
            r_xnor = r_lfsr[9] ^~ r_lfsr[6];  
        end  
        11: begin  
            r_xnor = r_lfsr[10] ^~ r_lfsr[8];  
        end  
        12: begin  
            r_xnor = r_lfsr[11] ^~ r_lfsr[5] ^~ r_lfsr[3] ^~ r_lfsr[0];  
        end  
        13: begin  
            r_xnor = r_lfsr[12] ^~ r_lfsr[3] ^~ r_lfsr[2] ^~ r_lfsr[0];  
        end  
        14: begin  
            r_xnor = r_lfsr[13] ^~ r_lfsr[4] ^~ r_lfsr[2] ^~ r_lfsr[0];  
        end  
        15: begin  
            r_xnor = r_lfsr[14] ^~ r_lfsr[13];  
        end  
        16: begin  
            r_xnor = r_lfsr[15] ^~ r_lfsr[14] ^~ r_lfsr[12] ^~ r_lfsr[3];  
        end  
        17: begin  
            r_xnor = r_lfsr[16] ^~ r_lfsr[13];  
        end  
        18: begin  
            r_xnor = r_lfsr[17] ^~ r_lfsr[10];  
        end  
        19: begin  
            r_xnor = r_lfsr[18] ^~ r_lfsr[5] ^~ r_lfsr[1] ^~ r_lfsr[0];  
        end  
        20: begin  
            r_xnor = r_lfsr[19] ^~ r_lfsr[16];  
        end  
        21: begin  
            r_xnor = r_lfsr[20] ^~ r_lfsr[18];  
        end  
        22: begin  
            r_xnor = r_lfsr[21] ^~ r_lfsr[20];  
        end  
        23: begin  
            r_xnor = r_lfsr[22] ^~ r_lfsr[17];  
        end  
        24: begin  
            r_xnor = r_lfsr[23] ^~ r_lfsr[22] ^~ r_lfsr[21] ^~ r_lfsr[16];  
        end  
        25: begin  
            r_xnor = r_lfsr[24] ^~ r_lfsr[21];  
        end  
        26: begin  
            r_xnor = r_lfsr[25] ^~ r_lfsr[5] ^~ r_lfsr[1] ^~ r_lfsr[0];  
        end  
        27: begin  
            r_xnor = r_lfsr[26] ^~ r_lfsr[4] ^~ r_lfsr[1] ^~ r_lfsr[0];  
        end  
        28: begin  
            r_xnor = r_lfsr[27] ^~ r_lfsr[24];  
        end  
        29: begin  
            r_xnor = r_lfsr[28] ^~ r_lfsr[26];  
        end  
        30: begin  
            r_xnor = r_lfsr[29] ^~ r_lfsr[5] ^~ r_lfsr[3] ^~ r_lfsr[0];  
        end  
        31: begin  
            r_xnor = r_lfsr[30] ^~ r_lfsr[27];  
        end  
        32: begin  
            r_xnor = r_lfsr[31] ^~ r_lfsr[21] ^~ r_lfsr[1] ^~ r_lfsr[0];  
        end  
    endcase // case (num_bits)  
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
    seed                <= #1 32'd0;
    r_lfsr              <= #1 'd0;
end
else
begin
    rand_en             <= #1 rand_en_in;
    rand_load           <= #1 rand_load_in;
    seed                <= #1 seed_in;
    r_lfsr              <= #1 r_lfsr_in;
end



//********************************************************************************
//
// END of Module
//
//********************************************************************************
endmodule

