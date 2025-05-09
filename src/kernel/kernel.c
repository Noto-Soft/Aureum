#include "lib/austdio.h"
#include "lib/austdkb.h"
#include "lib/audelay.h"
#include "lib/aumath.h"
#include "lib/austring.h"
#include <stdbool.h>

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

void __attribute__((section(".text.entry"), noreturn)) kernel(void)
{
    format_tty(0x07);

    puts("Aureum Kernel is testing memory\r\n");

    uint32_t mem_size = mem_test();

    puthd(mem_size);
    puts("\r\nDone!\r\n");

    uint8_t key;
    unsigned char ascii;

    char command[256];
    uint8_t index;

    while (1) {
        putbr();
        puts("Au$ ");    
        
        index = 0;
        command[0] = '\0';
        while ((key = wait_key()) != 0x01) {
            unsigned char ascii = convert_scancode_to_ascii(key);
            
            if (ascii == 0x09 || ascii == 0x00) {
                continue;
            } else if (ascii == 0x0a) {
                break;
            } else if (ascii == 0x08) {
                if (index > 0) {
                    command[index] = '\0';
                    index--;
                    puts("\b \b");
                }
                continue;
            } else if (!(index < 255)) {
                continue;
            }
            putc(ascii);
            command[index] = ascii;
            command[index + 1] = '\0';
            index++;
        }

        if (strcmp(command, "exit") == 0) {
            break;
        }
    }

    puts("\r\nGoodbye\r\n");

    while (true) {}
}