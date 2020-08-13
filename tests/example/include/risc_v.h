#ifndef _RISCV_H_
#define _RISCV_H_

#define region_base             0x20000000

#define perp_bank               (region_base + 0x00000000)
#define accele_bank             (region_base + 0x00100000)
#define digital_bank            (region_base + 0x00200000)
#define video_codec_bank        (region_base + 0x00300000)

#define _RW                     volatile 
#define _RO                     volatile const

#define _u32                    unsigned int

// grp=(0x00~0x3FF), device support 1024
// adr=(0x00~0xFF), reg config support 256
#define map_adr(grp, adr)       ((256*grp + adr)*4)


//----------------------------------------------------------------------//
// Peripherals Region
//----------------------------------------------------------------------//
// timer
typedef struct{
    _RW _u32   CON;
    _RW _u32   CNT;
    _RW _u32   PERIOD;
} RV_TIMER_Typedef;

//------------ timer0: 0x2000_0000 -------------// 
#define RV_TIMER0_BASE          (perp_bank)
#define RV_TIMER0               ((RV_TIMER_Typedef *)RV_TIMER0_BASE)

//------------ timer1: 0x2000_0400 -------------// 
#define RV_TIMER1_BASE          (perp_bank + map_adr(0x001, 0))
#define RV_TIMER1               ((RV_TIMER_Typedef *)RV_TIMER1_BASE)

//------------ timer2: 0x2000_0800 -------------// 
#define RV_TIMER2_BASE          (perp_bank + map_adr(0x002, 0))
#define RV_TIMER2               ((RV_TIMER_Typedef *)RV_TIMER2_BASE)

//------------ timer2: 0x2000_0C00 -------------// 
#define RV_TIMER3_BASE          (perp_bank + map_adr(0x003, 0))
#define RV_TIMER3               ((RV_TIMER_Typedef *)RV_TIMER3_BASE)

// rand
typedef struct{
    _RW _u32   CON;
    _RW _u32   SEED;
} RV_RAND_Typedef;


//------------ rand0: 0x2000_2000 -------------// 
#define RV_RAND0_BASE           (perp_bank + map_adr(0x008, 0))
#define RV_RAND0                ((RV_RAND_Typedef *)RV_RAND0_BASE)

//------------ rand1: 0x2000_2400 -------------// 
#define RV_RAND1_BASE           (perp_bank + map_adr(0x009, 0))
#define RV_RAND1                ((RV_RAND_Typedef *)RV_RAND1_BASE)

//------------ rand2: 0x2000_2800 -------------// 
#define RV_RAND2_BASE           (perp_bank + map_adr(0x00A, 0))
#define RV_RAND2                ((RV_RAND_Typedef *)RV_RAND2_BASE)

//------------ rand3: 0x2000_2C00 -------------// 
#define RV_RAND3_BASE           (perp_bank + map_adr(0x00B, 0))
#define RV_RAND3                ((RV_RAND_Typedef *)RV_RAND3_BASE)


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

