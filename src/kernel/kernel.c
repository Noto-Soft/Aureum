#include "lib/austdio.h"
#include "lib/austdkb.h"
#include "lib/audelay.h"
#include "lib/aumath.h"

uint32_t mem_test(void)
{
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

    return mem_size;
}

void __attribute__((section(".text.entry"))) kernel(void)
{
    format_tty(0x07);

    puts("Aureum Kernel is testing memory\r\n");

    uint32_t mem_size = mem_test();

    puthd(mem_size);
    puts("\r\nDone!\r\n");

    putbr();

    puts("Au$ ");
    
    uint8_t key;
    while ((key = wait_key()) != 0x01) {
        putc(convert_scancode_to_ascii(key));
    }

    puts("\r\nGoodbye\r\n");
}