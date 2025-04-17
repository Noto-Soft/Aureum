#include "austdio.h"
#include "aumath.h"
#include <stdint.h>

void puthb(uint8_t byte)
{
    uint8_t high = byte >> 4;
    uint8_t low = byte & 0x0f;
    high = min(high, 15);
    low = min(low, 15);
    uint8_t high_offset = '0';
    uint8_t low_offset = '0';
    if (high > 9) high_offset = 'a' - 10;
    if (low > 9) low_offset = 'a' - 10;
    putc(high_offset + high);
    putc(low_offset + low);
}

void puthw(uint16_t word)
{
    puthb(word >> 8);
    puthb(word);
}

void puthd(uint32_t dword)
{
    puthb(dword >> 24);
    puthb(dword >> 16);
    puthb(dword >> 8);
    puthb(dword);
}

void clear_vga(uint8_t color)
{
    uint16_t blank = (color << 8) | ' ';
    for (int i = 0; i < 80 * 25; i++) VGA_MEMORY[i] = blank;
    format_tty(color);
}