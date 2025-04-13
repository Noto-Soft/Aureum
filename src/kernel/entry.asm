bits 32

extern kernel

global start
start:
    jmp main

global set_cursor
set_cursor:
    push ebp
    mov ebp, esp

    push ebx

    mov ch, [ebp + 8]
    mov cl, [ebp + 12]

    xor ax, ax
    mov al, cl
    mov bl, 80
    div bl

    add ch, al
    mov cl, ah
    
    mov [cursor], cx

    movzx bx, cl
    movzx ax, ch

    mov dl, 80
	mul dl
	add bx, ax

    mov dx, 0x03D4
	mov al, 0x0F
	out dx, al

	inc dl
	mov al, bl
	out dx, al

	dec dl
	mov al, 0x0E
	out dx, al

	inc dl
	mov al, bh
	out dx, al

    pop ebx

    mov esp, ebp
    pop ebp
	ret

global get_cursor
get_cursor:
    push ebp
    mov ebp, esp

    lea eax, [cursor]

    mov esp, ebp
    pop ebp
    ret

global putc
putc:
    push ebp
    mov ebp, esp
    
    push ebx

    mov bl, [ebp + 8]
    mov bh, [ebp + 12]

    mov [.last_format], bh

    cmp bl, 0x0d
    je .carriagereturn
    cmp bl, 0x0a
    je .newline
    cmp bl, 0x08
    je .backspace
    cmp bl, 0x09
    je .tab
    cmp bl, 0x00
    je .return
.printable:
    push ebx
    mov cx, word [cursor]
    movzx bx, cl
    movzx ax, ch

    mov dl, 80
	mul dl
	add bx, ax
    mov eax, ebx
    movzx eax, ax
    pop ebx

    mov [eax * 2 + 0xb8000], bx
    mov cx, word [cursor]
    inc cl
    movzx eax, cl
    push eax
    movzx eax, ch
    push eax
    call set_cursor
    add esp, 8

    jmp .return
.carriagereturn:
    mov cx, word [cursor]
    xor cl, cl
    movzx eax, cl
    push eax
    movzx eax, ch
    push eax
    call set_cursor
    add esp, 8

    jmp .return
.newline:
    mov cx, word [cursor]
    inc ch
    movzx eax, cl
    push eax
    movzx eax, ch
    push eax
    call set_cursor
    add esp, 8

    jmp .return
.backspace:
    mov cx, word [cursor]
    cmp cl, 0
    jng .return
    dec cl
    movzx eax, cl
    push eax
    movzx eax, ch
    push eax
    call set_cursor
    add esp, 8

    jmp .return
.tab:
    mov cx, word [cursor]
    add cl, 4
    and cl, ~3
    movzx eax, cl
    push eax
    movzx eax, ch
    push eax
    call set_cursor
    add esp, 8

    jmp .return
.return:
    pop ebx

    mov esp, ebp
    pop ebp
    ret
.last_format: db 0x07

global puts
puts:
    push ebp
    mov ebp, esp

    push ebx
    push esi

    mov esi, [ebp + 8]

    mov bh, [ebp + 12]
.loop:
    mov bl, [esi]
    cmp bl, 0
    je .return
    inc esi
    movzx eax, bh
    push eax
    movzx eax, bl
    push eax
    call putc
    add esp, 8
    jmp .loop
.return:
    pop esi
    pop ebx

    mov esp, ebp
    pop ebp
    ret

global wait_key
wait_key:
    push ebp
    mov ebp, esp

.wait:
    in al, 0x64
    test al, 0x01
    jz .wait

    in al, 0x60
 
    mov esp, ebp
    pop ebp
    ret

global puthb
puthb:
    push ebp
    mov ebp, esp

    push ebx

    movzx ebx, byte [ebp + 12]

    movzx edx, byte [ebp + 8]
    shr edx, 4
    and edx, 0xf
    push ebx
    movzx eax, byte [hex_digits + edx]
    push eax
    call putc
    add sp, 4
    pop ebx
    movzx edx, byte [ebp + 8]
    and edx, 0xf
    push ebx
    movzx eax, byte [hex_digits + edx]
    push eax
    call putc
    add sp, 4
    pop ebx

    pop ebx

    mov esp, ebp
    pop ebp
    ret

global puthw
puthw:
    push ebp
    mov ebp, esp

    mov dx, [ebp + 8]
    mov bh, [ebp + 12]

    push dx
    movzx eax, bh
    push eax
    movzx eax, dh
    push eax
    call puthb
    add sp, 8
    pop dx
    push dx
    movzx eax, bh
    push eax
    movzx eax, dl
    push eax
    call puthb
    add sp, 8
    pop dx

    mov esp, ebp
    pop ebp
    ret

main:
    push 0x0e
    push msg
    call puts
    add esp, 8

    call kernel

    push 0x0e
    push debug
    call puts
    add esp, 8

    ret

section .data

msg: db "Entering Aureum Kernel.", 0x0d, 0x0a, 0
debug: db "Returned from Aureum Kernel.", 0x0d, 0x0a, 0
cursor: db 0, 0
hex_digits: db "0123456789ABCDEF"