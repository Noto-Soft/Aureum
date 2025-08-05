cpu 686
org 0x7c00
bits 16

start:
    jmp main.bits16

gdt_start:
    dq 0x0000000000000000          ; Null descriptor

gdt_code:                          ; Code segment descriptor
    dw 0xFFFF                      ; Limit low
    dw 0x0000                      ; Base low
    db 0x00                        ; Base middle
    db 10011010b                   ; Access byte
    db 11001111b                   ; Flags and limit high
    db 0x00                        ; Base high

gdt_data:                          ; Data segment descriptor
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 10010010b
    db 11001111b
    db 0x00

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

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