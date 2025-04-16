#include "austdio.h"

void putc(unsigned char character)
{
    putcf(character, get_last_format());
}

void puts(const char* str)
{
    putsf(str, get_last_format());
}