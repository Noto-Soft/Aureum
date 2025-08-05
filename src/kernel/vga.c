#include "vga.h"
#include "ports.h"

struct {
    uint8_t row;
    uint8_t col;
} cursor;

void enable_cursor(uint8_t cursor_start, uint8_t cursor_end) {
	outb(0x3D4, 0x0A);
	outb(0x3D5, (inb(0x3D5) & 0xC0) | cursor_start);

	outb(0x3D4, 0x0B);
	outb(0x3D5, (inb(0x3D5) & 0xE0) | cursor_end);
}

void disable_cursor() {
	outb(0x3D4, 0x0A);
	outb(0x3D5, 0x20);
}

void update_cursor(uint8_t row, uint8_t col) {
	uint16_t pos = row * VGA_WIDTH + col;

	outb(0x3D4, 0x0F);
	outb(0x3D5, (uint8_t) (pos & 0xFF));
	outb(0x3D4, 0x0E);
	outb(0x3D5, (uint8_t) ((pos >> 8) & 0xFF));
}

uint16_t get_cursor_position(void) {
    uint16_t pos = 0;
    outb(0x3D4, 0x0F);
    pos |= inb(0x3D5);
    outb(0x3D4, 0x0E);
    pos |= ((uint16_t)inb(0x3D5)) << 8;
    return pos;
}

static void scroll_line() {
    uint16_t *mem = (uint16_t*)0xb8000;
    for (uint32_t i; i < VGA_WIDTH * VGA_HEIGHT; i++) {
        if (i >= (VGA_WIDTH * VGA_HEIGHT) - VGA_WIDTH) {
            mem[i] = 0;
            continue;
        }
        mem[i] = mem[i + VGA_WIDTH];
    }
}

static void putchar(uint8_t character, uint8_t attr) {
    switch (character) {
        case '\n':
            cursor.row++;
            cursor.col = 0;
            break;
        default: {
            uint16_t *mem = (uint16_t*)0xb8000;
            uint16_t offset = (cursor.row * VGA_WIDTH) + cursor.col;
            mem[offset] = (uint16_t)character | (attr << 8);
            mem[offset + 1] = (mem[offset + 1] & 0xf0ff) | ((attr << 8) & 0x0f00);
            cursor.col++;
            break;
        }
    }
    if (cursor.col == VGA_WIDTH) {
        cursor.row++;
        cursor.col = 0;
    }
    if (cursor.row == VGA_HEIGHT) {
        scroll_line();
        cursor.row--;
    }
}

void putc_attr(uint8_t character, uint8_t attr) {
    putchar(character, attr);
    update_cursor(cursor.row, cursor.col);
}

void puts_attr(const uint8_t* string, uint8_t attr) {
    for (uint32_t i; string[i] != '\0'; i++) {
        putchar(string[i], attr);
    }
    update_cursor(cursor.row, cursor.col);
}

void scroll_lines(uint8_t amount) {
    for (uint8_t i; i < amount; i++) {
        scroll_line();
    }
}