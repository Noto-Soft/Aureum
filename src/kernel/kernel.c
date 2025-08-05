#include <stdint.h>

#include "vga.h"

void __attribute__((section(".text.entry"), noreturn)) entry() {
    enable_cursor(0, 15);
    puts_attr("Hello, world that i live ins!\nit is very interesting, this world!\n\nscrolling is kind of broken i plan to fix it soon", 0x0e);
    for (;;) {}
}