%include 'Interface.asm'
_interface:
    

    mov si, 80
    mov di, 25
    mov ax, cs
    mov bx, _interfaceTempDesenhaCaractere
    mov cx, 16
    mov dx, _interfaceTempAtualizaBuffer
    cs call far [Interface.RegistraTela]

    retf

_interfaceTempDesenhaCaractere:
    push ds
    push ax
    push bx
    push cx
    push dx

    push ax
    mov ax, 0xb000
    mov ds, ax
    mov ax, dx
    mov bx, 160
    mul bx
    add ax, cx
    add ax, cx
    mov bx, ax
    pop ax
    mov [bx], ax

    stc

    pop dx
    pop cx
    pop bx
    pop ax
    pop ds
    retf

_interfaceTempAtualizaBuffer:
    cmp ax, 0
    je .fim
        mov ax, 7
        int 0x10
        mov ch, 0b00000001
        mov cl, 0
        mov ah, 1
        int 0x10 
    .fim:
    retf

