
//*******************************************************************************
//
// Description : address range - 0x2000_0000 ~ 0x3000_0000
//     1. divided into 256 banks, addr: 0x2000_0000 ~ 0x2FF0_0000
//        eg: bank4 addr 0x2040_0000 ~ 0x2050_0000
//     2. divided into 1024 devices per bank.
//        eg: bank4, dev3 addr 0x2040_0C00 ~ 0x2040_1000
//     3. divided into 256 configuration registers per device.
//        eg: bank4, dev3, con3 addr 0x2040_0C0C
//               
//********************************************************************************


//********************************************************************************
//
// bank : 0 ~ 255, maximum support 256 bank
//
//********************************************************************************
`define rv_bank0                8'd0
`define rv_bank1                8'd1
`define rv_bank2                8'd2
`define rv_bank3                8'd3
`define rv_bank4                8'd4
`define rv_bank5                8'd5
`define rv_bank6                8'd6
`define rv_bank7                8'd7

`define rv_bank8                8'd8 
`define rv_bank9                8'd9 
`define rv_bank10               8'd10
`define rv_bank11               8'd11
`define rv_bank12               8'd12
`define rv_bank13               8'd13
`define rv_bank14               8'd14
`define rv_bank15               8'd15


//********************************************************************************
//
// device : 0 ~ 1023, maximum support 1024 devices
//
//********************************************************************************
`define rv_timer0_base          10'd0
`define rv_timer1_base          10'd1
`define rv_timer2_base          10'd2
`define rv_timer3_base          10'd3

`define rv_uart0_base           10'd4
`define rv_uart1_base           10'd5
`define rv_uart2_base           10'd6
`define rv_uart3_base           10'd7

`define rv_rand0_base           10'd8 
`define rv_rand1_base           10'd9 
`define rv_rand2_base           10'd10
`define rv_rand3_base           10'd11

`define rv_spi0_base            10'd12
`define rv_spi1_base            10'd13
`define rv_spi2_base            10'd14
`define rv_spi3_base            10'd15


//********************************************************************************
//
// cfg register : 0 ~ 255, maximum support 256 cfg_register
//
//********************************************************************************
//---------------------------- timer ----------------------------//
`define rv_cfg_timer_con            8'd0
`define rv_cfg_timer_cnt            8'd1
`define rv_cfg_timer_value          8'd2

//---------------------------- uart ----------------------------//
`define rv_cfg_uart_con             8'd0
`define rv_cfg_uart_sta             8'd1
`define rv_cfg_uart_baud            8'd2
`define rv_cfg_uart_txdat           8'd3
`define rv_cfg_uart_rxdat           8'd4

//---------------------------- spi ----------------------------//
`define rv_cfg_spi_con              8'd0
`define rv_cfg_spi_dat              8'd1
`define rv_cfg_spi_sta              8'd2

//---------------------------- gpio ----------------------------//
`define rv_cfg_gpio_con             8'd0
`define rv_cfg_gpio_dat             8'd1

//---------------------------- rand ----------------------------//
`define rv_cfg_rand_con0            8'd0
`define rv_cfg_rand_seed            8'd1





