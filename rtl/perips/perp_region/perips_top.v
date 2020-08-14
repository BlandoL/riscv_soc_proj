//*******************************************************************************
// Project      : 
// Module       : perips_top.v
// Description  : peripheral regions
// Designer     :
// Version      : 
//********************************************************************************

module perips_top(
input   wire            icb_wr,
input   wire [19:0]     icb_wadr,
input   wire [31:0]     icb_wdat,
output  wire            icb_wack,

input   wire            icb_rd,
input   wire [19:0]     icb_radr,
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
wire [1023:0]   icb_wbus_dev;
wire [1023:0]   icb_rbus_dev;

wire [31:0]     icb_rdat_tmr0;
wire            icb_wack_tmr0;
wire            icb_rack_tmr0;

wire [31:0]     icb_rdat_tmr1;
wire            icb_wack_tmr1;
wire            icb_rack_tmr1;

wire [31:0]     icb_rdat_tmr2;
wire            icb_wack_tmr2;
wire            icb_rack_tmr2;

wire [31:0]     icb_rdat_tmr3;
wire            icb_wack_tmr3;
wire            icb_rack_tmr3;

wire [31:0]     icb_rdat_rand0;
wire            icb_wack_rand0;
wire            icb_rack_rand0;

wire [31:0]     icb_rdat_rand1;
wire            icb_wack_rand1;
wire            icb_rack_rand1;

wire [31:0]     icb_rdat_rand2;
wire            icb_wack_rand2;
wire            icb_rack_rand2;

wire [31:0]     icb_rdat_rand3;
wire            icb_wack_rand3;
wire            icb_rack_rand3;

wire            timer0_int;
wire            timer1_int;
wire            timer2_int;
wire            timer3_int;


//****************************************************************
//
// assignment
//
//****************************************************************
assign timer_int = timer0_int | timer1_int | timer2_int |
                   timer3_int;
assign icb_wack  = icb_wack_tmr0 | icb_wack_tmr1 | icb_wack_tmr2 |
                   icb_wack_tmr3 | icb_wack_rand0 | icb_wack_rand1 |
                   icb_wack_rand2 | icb_wack_rand3;
assign icb_rack  = icb_rack_tmr0 | icb_rack_tmr1 | icb_rack_tmr2 |
                   icb_rack_tmr3 | icb_rack_rand0 | icb_rack_rand1 |
                   icb_rack_rand2 | icb_rack_rand3;


//****************************************************************
//
// dev_dec inst
//
//****************************************************************
icb_dec #(.aw(10)) dev_dec(
    .icb_wr         (icb_wr             ),
    .icb_wadr       (icb_wadr[19:10]    ),
    .icb_rd         (icb_rd             ),
    .icb_radr       (icb_radr[19:10]    ),

    .icb_wbus       (icb_wbus_dev       ),
    .icb_rbus       (icb_rbus_dev       ) 
);

// Read
always @(*)
begin
    case(1'b1)   // synopsys parallel_case
        icb_rack_tmr0    : icb_rdat = icb_rdat_tmr0;
        icb_rack_tmr1    : icb_rdat = icb_rdat_tmr1;
        icb_rack_tmr2    : icb_rdat = icb_rdat_tmr2;
        icb_rack_tmr3    : icb_rdat = icb_rdat_tmr3;
        icb_rack_rand0   : icb_rdat = icb_rdat_rand0;
        icb_rack_rand1   : icb_rdat = icb_rdat_rand1;
        icb_rack_rand2   : icb_rdat = icb_rdat_rand2;
        icb_rack_rand3   : icb_rdat = icb_rdat_rand3;
        default:           icb_rdat = 32'd0;
    endcase
end


//****************************************************************
//
// peripheral device 0 : timer0  
//
//****************************************************************
timer   timer0(
    .icb_wr         (icb_wbus_dev[`rv_timer0_base]      ),
    .icb_wadr       (icb_wadr[9:0]                      ),
    .icb_wdat       (icb_wdat                           ),
    .icb_wack       (icb_wack_tmr0                      ),
    .icb_rd         (icb_rbus_dev[`rv_timer0_base]      ),
    .icb_radr       (icb_radr[9:0]                      ),
    .icb_rdat       (icb_rdat_tmr0                      ),
    .icb_rack       (icb_rack_tmr0                      ),

    .int_sig_o      (timer0_int                         ),

    .clk            (clk),
    .rst            (rst)
);


//****************************************************************
//
// peripheral device 1 : timer1  
//
//****************************************************************
timer_multf   timer1(
    .icb_wr         (icb_wbus_dev[`rv_timer1_base]      ),
    .icb_wadr       (icb_wadr[9:2]                      ),
    .icb_wdat       (icb_wdat                           ),
    .icb_wack       (icb_wack_tmr1                      ),
    .icb_rd         (icb_rbus_dev[`rv_timer1_base]      ),
    .icb_radr       (icb_radr[9:2]                      ),
    .icb_rdat       (icb_rdat_tmr1                      ),
    .icb_rack       (icb_rack_tmr1                      ),

    .timer_int      (timer1_int                         ),

    .clk            (clk),
    .rst            (rst)
);


//****************************************************************
//
// peripheral device 2 : timer2  
//
//****************************************************************
timer_multf   timer2(
    .icb_wr         (icb_wbus_dev[`rv_timer2_base]      ),
    .icb_wadr       (icb_wadr[9:2]                      ),
    .icb_wdat       (icb_wdat                           ),
    .icb_wack       (icb_wack_tmr2                      ),
    .icb_rd         (icb_rbus_dev[`rv_timer2_base]      ),
    .icb_radr       (icb_radr[9:2]                      ),
    .icb_rdat       (icb_rdat_tmr2                      ),
    .icb_rack       (icb_rack_tmr2                      ),

    .timer_int      (timer2_int                         ),

    .clk            (clk),
    .rst            (rst)
);


//****************************************************************
//
// peripheral device 3 : timer3  
//
//****************************************************************
timer_multf   timer3(
    .icb_wr         (icb_wbus_dev[`rv_timer3_base]      ),
    .icb_wadr       (icb_wadr[9:2]                      ),
    .icb_wdat       (icb_wdat                           ),
    .icb_wack       (icb_wack_tmr3                      ),
    .icb_rd         (icb_rbus_dev[`rv_timer3_base]      ),
    .icb_radr       (icb_radr[9:2]                      ),
    .icb_rdat       (icb_rdat_tmr3                      ),
    .icb_rack       (icb_rack_tmr3                      ),

    .timer_int      (timer3_int                         ),

    .clk            (clk),
    .rst            (rst)
);


//****************************************************************
//
// peripheral device: random 0
//
//****************************************************************
rand_16b    rand0(
    .icb_wr         (icb_wbus_dev[`rv_rand0_base]       ),
    .icb_wadr       (icb_wadr[9:2]                      ),
    .icb_wdat       (icb_wdat                           ),
    .icb_wack       (icb_wack_rand0                     ),
    .icb_rd         (icb_rbus_dev[`rv_rand0_base]       ),
    .icb_radr       (icb_radr[9:2]                      ),
    .icb_rdat       (icb_rdat_rand0                     ),
    .icb_rack       (icb_rack_rand0                     ),

    .clk            (clk),
    .rst            (rst)
);


//****************************************************************
//
// peripheral device: random 1
//
//****************************************************************
rand_wcfg #(.num_bits(32))  rand1(
    .icb_wr         (icb_wbus_dev[`rv_rand1_base]       ),
    .icb_wadr       (icb_wadr[9:2]                      ),
    .icb_wdat       (icb_wdat                           ),
    .icb_wack       (icb_wack_rand1                     ),
    .icb_rd         (icb_rbus_dev[`rv_rand1_base]       ),
    .icb_radr       (icb_radr[9:2]                      ),
    .icb_rdat       (icb_rdat_rand1                     ),
    .icb_rack       (icb_rack_rand1                     ),

    .clk            (clk),
    .rst            (rst)
);


//****************************************************************
//
// peripheral device: random 2
//
//****************************************************************
rand_wcfg #(.num_bits(32))  rand2(
    .icb_wr         (icb_wbus_dev[`rv_rand2_base]       ),
    .icb_wadr       (icb_wadr[9:2]                      ),
    .icb_wdat       (icb_wdat                           ),
    .icb_wack       (icb_wack_rand2                     ),
    .icb_rd         (icb_rbus_dev[`rv_rand2_base]       ),
    .icb_radr       (icb_radr[9:2]                      ),
    .icb_rdat       (icb_rdat_rand2                     ),
    .icb_rack       (icb_rack_rand2                     ),

    .clk            (clk),
    .rst            (rst)
);


//****************************************************************
//
// peripheral device: random 3
//
//****************************************************************
rand_wcfg #(.num_bits(32))  rand3(
    .icb_wr         (icb_wbus_dev[`rv_rand3_base]       ),
    .icb_wadr       (icb_wadr[9:2]                      ),
    .icb_wdat       (icb_wdat                           ),
    .icb_wack       (icb_wack_rand3                     ),
    .icb_rd         (icb_rbus_dev[`rv_rand3_base]       ),
    .icb_radr       (icb_radr[9:2]                      ),
    .icb_rdat       (icb_rdat_rand3                     ),
    .icb_rack       (icb_rack_rand3                     ),

    .clk            (clk),
    .rst            (rst)
);



//********************************************************************************
//
// END of Module
//
//********************************************************************************
endmodule
