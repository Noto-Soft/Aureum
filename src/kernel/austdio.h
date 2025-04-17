#pragma once

#include <stdint.h>

#define VGA_MEMORY ((uint16_t*)0xb8000)

#define putbr() {putc('\r'); putc('\n');}

typedef struct
{
    uint8_t col;
    uint8_t row;
} textcursor_t;

void puthb(uint8_t byte);
void puthw(uint16_t word);
void puthd(uint32_t dword);

void clear_vga(uint8_t color);

/*
    libx86 functions
*/
extern void putc(unsigned char character);
extern void puts(const char* str);
extern void set_cursor(uint8_t row, uint8_t column);
extern textcursor_t* get_cursor(void);

extern void format_tty(uint8_t format);
extern uint8_t get_last_format(void);

// these are deprecated and will probably be removed in the future. they also are not going to recieve any updates
extern void putcf(unsigned char character, uint8_t format);
extern void putsf(const char* str, uint8_t format);

// these are deprecated as well mainly because they rely on deprecated subroutines and also they'd be better off written in c
extern void puthbf(uint8_t byte, uint8_t format);
extern void puthwf(uint16_t word, uint8_t format);