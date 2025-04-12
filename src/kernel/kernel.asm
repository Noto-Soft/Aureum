org 0x7e00
bits 32

start:
    jmp main

main:
    mov esi, msg
    mov bh, 0x02
    call puts

    ret

msg: db 0x22, "According to all known laws of aviation, there is no way a bee should be able", 0x0d, "to fly. Its wings are too small to get its fat little body off the ground. The ", 0x0d, "bee, of course, flies anyway because bees don't care what humans think is ", 0x0d, "impossible.", 0x22, " - Tom McGrath and Vicky Jenson, read by Jim Cummings", 0

cursor: dw 0

set_cursor:
    push ebp
    mov ebp, esp

    push eax
    push ebx
    push ecx
    push edx

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

    mov dl, [putc.last_format]
    and dl, 0x0f
    mov dh, [ebx * 2 + 0xb8001]
    and dh, 0xf0
    or dl, dh
    mov byte [ebx * 2 + 0xb8001], dl

    pop edx
    pop ecx
    pop ebx
    pop eax

    mov esp, ebp
    pop ebp
	ret

putc:
    push ebp
    mov ebp, esp
    
    mov [.last_format], bh

    push ecx
    push edx
    push eax

    cmp bl, 0x0d
    je .newline
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
    call set_cursor

    jmp .return
.newline:
    mov cx, word [cursor]
    inc ch
    xor cl, cl
    call set_cursor

    jmp .return
.return:
    pop eax
    pop edx
    pop ecx

    mov esp, ebp
    pop ebp
    ret
.last_format: db 0x07

puts:
    push ebp
    mov ebp, esp
.loop:
    mov bl, [esi]
    cmp bl, 0
    je .return
    inc esi
    call putc
    jmp .loop
.return:
    mov esp, ebp
    pop ebp
    ret

times (512*64)-($-$$) db 0