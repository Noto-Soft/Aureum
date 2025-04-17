bits 32

extern kernel

extern format_tty
extern puts

extern puthw

global start
start:
    jmp main

main:
    push 0x07
    call format_tty
    add esp, 4

    push msg
    call puts
    add esp, 4

    call kernel

    ret

section .data

msg: db "Entering kernel", 0x0d, 0x0a, 0

section .note.GNU-stack