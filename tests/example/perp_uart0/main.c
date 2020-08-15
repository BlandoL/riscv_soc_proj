//******************************************************************************//
// Module Name  : main.c
// Description  : 
// Designer     :
// Date         :
//******************************************************************************//
#include <stdint.h>

#include "../include/uart.h"
#include "../include/risc_v.h"
#include "../include/xprintf.h"

#define SFR(sfr, start, len, dat) (sfr = sfr & ~((~(0xffffffff<<len))<<start) | ((dat & (~(0xffffffff<<len)))<<start))
#define BIT(n)                    (1 << n)

unsigned char txdat[] = {0x29, 0x01, 0x12, 0x35, 0x42, 0xa9, 0xe4, 0xf3};
unsigned int baud[] = {0x1b8, 0x129, 0x134, 0x29, 0x143, 0x121, 0x93, 0x39};

//----------------------------------------------------------------------//
// main
//----------------------------------------------------------------------//
int main()
{
	unsigned int para = 0;
	unsigned char i = 0;
	RV_TIMER2->CNT = 4;
	RV_PERP_UART0->BAUD = 0x1B8;  // 115200
	RV_PERP_UART0->CON = BIT(1) | BIT(0);
	RV_PERP_UART0->TXDAT = 0x29;

	while(1)
	{
		para = RV_PERP_UART0->STATUS;	
		RV_TIMER2->CNT = para;
		if(!(para & BIT(0)))// IDLE
		{
			RV_PERP_UART0->BAUD = baud[i%8];  // baud rate
			RV_PERP_UART0->TXDAT = txdat[i%8]; // uart txdat
			RV_TIMER2->CNT = RV_PERP_UART0->BAUD;
			i++;
		}
	}
}


//******************************************************************************//
// 
// END of Main 
//
//******************************************************************************//

