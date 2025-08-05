#pragma once

#include <stdint.h>

#define VGA_WIDTH 80
#define VGA_HEIGHT 25

void enable_cursor(uint8_t cursor_start, uint8_t cursor_end);
void disable_cursor();
void update_cursor(uint8_t row, uint8_t col);
uint16_t get_cursor_position(void);
void putc_attr(uint8_t character, uint8_t attr);
void puts_attr(const uint8_t* string, uint8_t attr);
void scroll_lines(uint8_t amount);