#include "audelay.h"

void delay(int ticks) {
    volatile int i, j;
    for (i = 0; i < ticks; i++) {
        for (j = 0; j < 100000; j++) {
            __asm__ __volatile__("nop");
        }
    }
}