org 0x7c00
bits 16

start:
    jmp main.bits16

gdt_start:
    dq 0x0000000000000000
    dq 0x00CF9A000000FFFF
    dq 0x00CF92000000FFFF
gdt_end:

gdt_ptr:
    dw gdt_end - gdt_start - 1
    dd gdt_start

main.bits16:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov sp, 0x7c00

    mov ah, 0
    mov al, 3
    int 0x10

    mov ah, 1
    mov cx, 0x7
    int 0x10

    mov ah, 2
    mov al, 64
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov bx, 0x7e00
    int 0x13

    cli

    lgdt [gdt_ptr]
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp 0x08:main.bits32

halt.bits16:
    hlt
    jmp halt.bits16

bits 32
main.bits32:
    mov eax, 0x10
    mov ds, eax
    mov es, eax
    mov fs, eax
    mov gs, eax
    mov ss, eax
    mov esp, 0x90000
    
    jmp 0x7e00

halt.bits32:
    hlt
    jmp halt.bits32

times 510-($-$$) db 0
dw 0xaa55