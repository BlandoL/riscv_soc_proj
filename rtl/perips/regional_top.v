//*******************************************************************************
// Project      : 
// Module       : regional_top.v
// Description  : regional part, maximum support 256 regions
// Designer     :
// Version      : 
//********************************************************************************

module regional_top(
input   wire            req_i,
input   wire            we_i,
input   wire [31:0]     addr_i,
input   wire [31:0]     data_i,
output  reg  [31:0]     data_o,
output  wire            ack_o,

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
wire [255:0] icb_wbus_bank;
wire [255:0] icb_rbus_bank;

wire [31:0]  icb_rdat_bank0;
wire         icb_wack_bank0;
wire         icb_rack_bank0;


//****************************************************************
//
// assignment
//
//****************************************************************
wire icb_wr = req_i & we_i;
wire icb_rd = req_i & !we_i;
wire [7:0] addr_bank    = addr_i[27:20];

wire [19:0] icb_wadr_bank = addr_i[19:0];
wire [31:0] icb_wdat_bank = data_i;

wire [19:0] icb_radr_bank = addr_i[19:0];

assign ack_o = icb_wack_bank0 | icb_rack_bank0;


//****************************************************************
//
// bank_dec inst
//
//****************************************************************
icb_dec #(.aw(8)) bank_dec(
    .icb_wr     (icb_wr         ),
    .icb_wadr   (addr_bank      ),
    .icb_rd     (icb_rd         ),
    .icb_radr   (addr_bank      ),

    .icb_wbus   (icb_wbus_bank  ),
    .icb_rbus   (icb_rbus_bank  ) 
);


// read
always @(*)
begin
    case(1'b1)   // synopsys parallel_case
        icb_rack_bank0    : data_o = icb_rdat_bank0;
        default:            data_o = 32'd0;
    endcase
end


//****************************************************************
//
// region 0: peripheral region
//
//****************************************************************
perips_top  perips_top(
    .icb_wr         (icb_wbus_bank[`rv_bank0]   ),
    .icb_wadr       (icb_wadr_bank              ),
    .icb_wdat       (icb_wdat_bank              ),
    .icb_wack       (icb_wack_bank0             ),
    .icb_rd         (icb_rbus_bank[`rv_bank0]   ),
    .icb_radr       (icb_radr_bank              ),
    .icb_rdat       (icb_rdat_bank0             ),
    .icb_rack       (icb_rack_bank0             ),

    .timer_int      (timer_int                  ),

    .clk            (clk),
    .rst            (rst)
);


//****************************************************************
//
// region 1: accelerator region
//
//****************************************************************
//accele_top  accele_top(
//
//
//
//    .clk            (clk),
//    .rst            (rst)
//);


//****************************************************************
//
// region 2: digital communication region
//
//****************************************************************
//digital_com_top  digital_com_top(
//
//
//
//    .clk            (clk),
//    .rst            (rst)
//);


//****************************************************************
//
// region n: ......  (add it yourself)
//
//****************************************************************







//********************************************************************************
//
// END of Module
//
//********************************************************************************
endmodule
