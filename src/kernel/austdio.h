#pragma once

#include <stdint.h>

typedef struct
{
    uint8_t col;
    uint8_t row;
} textcursor_t;

extern void set_cursor(uint8_t row, uint8_t column);
extern textcursor_t* get_cursor(void);
extern void putcf(unsigned char character, uint8_t format);
extern void putsf(const char* str, uint8_t format);
extern void puthbf(uint8_t byte, uint8_t format);
extern void puthwf(uint16_t word, uint8_t format);

extern void format_tty(uint8_t format);
extern uint8_t get_last_format(void);

void putc(unsigned char character);
void puts(const char* str);