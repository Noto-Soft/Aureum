#pragma once

#include <stdint.h>

#define convert_scancode_to_ascii(scancode) (ascii_table[scancode])

const char ascii_table[256] = {
    0, 0, '1', '2', '3', '4', '5', '6', '7', '8',  \
    '9', '0', '-', '=', 0x08, 0x09, 'q', 'w',   \
    'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[',\
    ']', 0x0a, 0, 'a', 's', 'd', 'f', 'g', 'h', \
    'j', 'k', 'l', ';', '\'', '`', 0, '\\', 'z',\
    'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/',\
    0, 0, 0, ' '
};
