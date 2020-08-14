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
	unsigned char i;
	i = 0;
	RV_TIMER2->CNT = 1;
	UART0_REG(UART0_BAUD) = 0x1B8;  // 115200
	UART0_REG(UART0_CTRL) = BIT(1) | BIT(0);
	UART0_REG(UART0_TXDATA) = 0x29;

	while(1)
	{
		while(UART0_REG(UART0_STATUS) & BIT(0));// IDLE
		UART0_REG(UART0_BAUD) = baud[i%8];  // baud rate
        UART0_REG(UART0_TXDATA) = txdat[i%8]; // uart txdat
		RV_TIMER2->CNT = UART0_REG(UART0_BAUD);
        i++;
	}
}


//******************************************************************************//
// 
// END of Main 
//
//******************************************************************************//

