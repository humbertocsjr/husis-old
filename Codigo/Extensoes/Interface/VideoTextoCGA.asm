
_videotextoAtualizaCGA:
    push es
    push ds
    push si
    push di
    push ax
    push cx
    mov ax, es
    mov ds, ax
    mov ax, 0xb800
    mov es, ax
    mov cx, 80*25
    mov si, ObjVideoTexto.Dados
    xor di, di
    rep movsw
    mov word [ObjVideoTexto.UltimaLinhaAlterada], 0
    stc
    pop cx
    pop ax
    pop di
    pop si
    pop ds
    pop es
    retf