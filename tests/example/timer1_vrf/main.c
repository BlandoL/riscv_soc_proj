//******************************************************************************//
// Module Name  : main.c
// Description  : 
// Designer     :
// Date         :
//******************************************************************************//
#include <stdint.h>

#include "../include/risc_v.h"
#include "../include/utils.h"

#define SFR(sfr, start, len, dat) (sfr = sfr & ~((~(0xffffffff<<len))<<start) | ((dat & (~(0xffffffff<<len)))<<start))
#define BIT(n)                    (1 << n)

static volatile unsigned int count;


//----------------------------------------------------------------------//
// interrupt
//----------------------------------------------------------------------//
void timer0_irq_handler()
{
    // clear int pending and start timer
	RV_TIMER1->CON = BIT(8) | BIT(1) | BIT(0);
    count++;
}


//----------------------------------------------------------------------//
// main
//----------------------------------------------------------------------//
int main()
{
    count = 0;

#ifdef SIMULATION
    RV_TIMER1->PERIOD = 500;     // 10us period
    RV_TIMER1->CON = 0x03 | BIT(8);     // enable interrupt and start timer

    while (1) {
        if (count == 20) {
            RV_TIMER1->CON = 0x00;   // stop timer
            count = 0;

            set_test_pass();
            break;
        }
    }
#else
    RV_TIMER1->PERIOD = 500000;     // 10us period
    RV_TIMER1->CON = 0x03 | BIT(8);     // enable interrupt and start timer

    while (1) {
        // 500ms
        if (count == 50) {
            count = 0;
        }
    }
#endif

    return 0;
}

//******************************************************************************//
// 
// END of Main 
//
//******************************************************************************//
