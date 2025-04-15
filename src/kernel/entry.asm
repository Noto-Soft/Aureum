bits 32

extern kernel

extern putsf

global start
start:
    jmp main

main:
    push 0x0e
    push msg
    call putsf
    add esp, 8

    call kernel

    push 0x0e
    push debug
    call putsf
    add esp, 8

    ret

section .data

msg: db "Entering Aureum Kernel.", 0x0d, 0x0a, 0
debug: db "Returned from Aureum Kernel.", 0x0d, 0x0a, 0

section .note.GNU-stack