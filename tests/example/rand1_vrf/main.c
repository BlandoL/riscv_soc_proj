//******************************************************************************//
// Module Name  : main.c
// Description  : 
// Designer     :
// Date         :
//******************************************************************************//
#include <stdint.h>

//----------------------------------------------------------------------//
// define SIMULATION 	 : for simulation mode
// not define SIMULATION : for actual test mode
//----------------------------------------------------------------------//

#include "../include/risc_v.h"
#include "../include/utils.h"

#define SFR(sfr, start, len, dat) (sfr = sfr & ~((~(0xffffffff<<len))<<start) | ((dat & (~(0xffffffff<<len)))<<start))
#define BIT(n)                    (1 << n)

static volatile unsigned char count;
static volatile unsigned int seed;

//----------------------------------------------------------------------//
// interrupt
//----------------------------------------------------------------------//
void timer0_irq_handler()
{
    seed = seed ^ 0x59028381;  
    RV_RAND0->SEED = seed;  
    RV_RAND0->CON = BIT(0) | BIT(1);     // enable rand and load seed pls
	
	RV_TIMER2->CNT = 0x66;
	RV_TIMER2->CNT = RV_RAND0->SEED;
    // clear int pending and start timer
	RV_TIMER1->CON = BIT(8) | BIT(1) | BIT(0);
    count++;
}

//----------------------------------------------------------------------//
// main
//----------------------------------------------------------------------//
int main()
{
	unsigned int para;
    count = 0;
	seed = 0x3759321A;

#ifdef SIMULATION
    RV_RAND1->SEED = 0x89FCA034;  
    RV_RAND1->CON = BIT(0) | BIT(1);     // enable rand and load seed pls

    RV_TIMER1->PERIOD = 800;     // 10us period
    RV_TIMER1->CON = 0x03 | BIT(8);     // enable interrupt and start timer
	
	RV_TIMER2->CNT = 0x55;
	para = RV_TIMER1->CON;
	RV_TIMER2->CNT = 0x44;
	para = RV_RAND1->SEED;
	RV_TIMER2->CNT = para;
	
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
