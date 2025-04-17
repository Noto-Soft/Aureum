#include "austdio.h"
#include "austdkb.h"

void kernel(void)
{
    format_tty(0x07);

    puts("Aureum Kernel is testing memory\r\n");

    uint32_t mem_size;
    uint8_t* address = (uint8_t*)0x100000;

    uint8_t old;

    puts("0x");

    while ((uint32_t)address < 0xf00000) {
        old = *address;
        *address = 0xaa;
        if (*address != 0xaa) break;
        *address = 0x55;
        if (*address != 0x55) break;
        *address = old;
        address++;
        mem_size++;
    }

    puthd(mem_size);
    puts("\r\nDone!\r\n");
}