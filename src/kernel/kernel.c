#include "austdio.h"
#include "austdkb.h"

void kernel(void)
{
    format_tty(0x0f);
    puts("Greetings, Planet in which I reside on!\r\n");

    format_tty(0x02);
    puts("0x");
    puthb(0x42);
    puts("\r\n");

    format_tty(0x08);
    puts("hey just so you know,,, you're in input mode ^^\r\npress esc to exit the input mode\r\nOK thanks for listening :)\r\n");

    uint8_t key;

    format_tty(0x07);

    while ((key = wait_key()) != 0x01) {
        if (convert_scancode_to_ascii(key) == 0x0a) {
            puts("\r\n");
        } else if (convert_scancode_to_ascii(key) == 0x08) {
            puts("\b \b");
        } else if (convert_scancode_to_ascii(key) == '=') {
            textcursor_t* cursor = get_cursor();
            if (cursor->row > 0)
                set_cursor(cursor->row - 1, cursor->col);
        } else if (convert_scancode_to_ascii(key) == '[') {
            textcursor_t* cursor = get_cursor();
            if (cursor->col > 0)
                set_cursor(cursor->row, cursor->col - 1);
        } else if (convert_scancode_to_ascii(key) == ']') {
            textcursor_t* cursor = get_cursor();
            if (cursor->col < 79)
                set_cursor(cursor->row, cursor->col + 1);
        } else if (convert_scancode_to_ascii(key) == '\'') {
            textcursor_t* cursor = get_cursor();
            if (cursor->row < 24)
                set_cursor(cursor->row + 1, cursor->col);
        } else {
            putc(convert_scancode_to_ascii(key));
        }
    }

    format_tty(0x05);
    puts("\r\nSalutations, Planet in which I reside on!\r\n");
}