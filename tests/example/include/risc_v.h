#ifndef _RISCV_H_
#define _RISCV_H_

#define ls_base                 0x50000000
#define hs_base                 0x60000000

#define _RW                     volatile 
#define _RO                     volatile const

#define _u32                    unsigned int

// grp=(0x00~0xFF), device support 256
// adr=(0x00~0x3F), reg config support 64
#define map_adr(grp, adr)       ((64*grp + adr)*4)


//----------------------------------------------------------------------//
// Timer0 : 0x2000_0000
//----------------------------------------------------------------------//
typedef struct{
    _RW _u32   CON;
    _RW _u32   CNT;
    _RW _u32   PERIOD;
} RV_TIMER_Typedef;

#define RV_TIMER0_BASE          (0x20000000)
#define RV_TIMER0               ((RV_TIMER_Typedef *)RV_TIMER0_BASE)


//----------------------------------------------------------------------//
// UART0 : 0x3000_0000
//----------------------------------------------------------------------//
typedef struct{
    _RW _u32   CON;
    _RW _u32   STATUS;
    _RW _u32   BAUD;
    _RW _u32   TXDAT;
} RV_UART_Typedef;

#define RV_UART0_BASE           (0x30000000)
#define RV_UART0                ((RV_UART_Typedef *)RV_UART0_BASE)


//----------------------------------------------------------------------//
// GPIO : 0x4000_0000
//----------------------------------------------------------------------//
typedef struct{
    _RW _u32   DAT;
} RV_GPIO_Typedef;

#define RV_GPIO_BASE            (0x40000000)
#define RV_GPIO                 ((RV_GPIO_Typedef *)RV_GPIO_BASE)


//----------------------------------------------------------------------//
// SPI : 0x5000_0000
//----------------------------------------------------------------------//
typedef struct{
    _RW _u32   CON;
    _RW _u32   DAT;
    _RW _u32   STA;
} RV_SPI_Typedef;

#define RV_SPI_BASE             (0x50000000)
#define RV_SPI                  ((RV_SPI_Typedef *)RV_SPI_BASE)
  
  
#endif

