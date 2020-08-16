#include <stdint.h>

#include "../include/gpio.h"
#include "../include/risc_v.h"
#include "../include/utils.h"


int main()
{
#if 0
    GPIO_REG(GPIO_CTRL) |= 0x1;       // gpio0输出模式
    GPIO_REG(GPIO_CTRL) |= 0x1 << 3;  // gpio1输入模式

    while (1) {
        // 如果GPIO1输入高
        if (GPIO_REG(GPIO_DATA) & 0x2)
            GPIO_REG(GPIO_DATA) |= 0x1;  // GPIO0输出高
        // 如果GPIO1输入低
        else
            GPIO_REG(GPIO_DATA) &= ~0x1; // GPIO0输出低
    }
#endif
    unsigned int para = 0;
    GPIO_REG(GPIO_DATA) = 0x1234;  // GPIO0输出高
    GPIO_REG(GPIO_CTRL) = 0x1;     // gpio0输出模式
    GPIO_REG(GPIO_CTRL) = 0x1<<3;  // gpio1输出模式

    RV_TIMER0->PERIOD = 200;     // 10us period
    RV_TIMER0->CON = 0x07;     // enable interrupt and start timer

    RV_TIMER2->CNT = 0x22;
    para = RV_TIMER0->PERIOD;
    RV_TIMER2->CNT = para;

    //para = GPIO_REG(GPIO_CTRL);
    //RV_TIMER2->CNT = para;
    //para = RV_TIMER2->CNT;
    //RV_TIMER3->CNT = para;

    while(1)
    {

    }
}
