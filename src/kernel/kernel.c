#include "austdio.h"
#include "austdkb.h"

void kernel(void)
{
    puts("Greetings, Planet in which I reside on!\r\n",0x0f);

    puts("hey just so you know,,, you're in input mode ^^\r\npress esc to exit the input mode\r\nOK thanks for listening :)\r\n",0x08);

    uint8_t key;

    while ((key = wait_key()) != 0x01) {
        if (convert_scancode_to_ascii(key) == 0x0a)
            puts("\r\n", 0x07);
        else if (convert_scancode_to_ascii(key) == 0x08)
            puts("\b \b", 0x07);
        else
            putc(convert_scancode_to_ascii(key), 0x07);
    }

    puts("\r\nSalutations, Planet in which I reside on!\r\n", 0x0b);
}