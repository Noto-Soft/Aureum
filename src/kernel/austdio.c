#include "austdio.h"
#include "aumath.h"
#include <stdint.h>

void puthb(uint8_t byte)
{
    uint8_t high = byte >> 4;
    uint8_t low = byte & 0x0f;
    high = min(high, 15);
    low = min(low, 15);
    putc('0' + high);
    putc('0' + low);
}

void puthw(uint16_t word)
{
    uint8_t high = word >> 8;
    uint8_t low = word & 0xff;
    puthb(high);
    puthb(low);
}