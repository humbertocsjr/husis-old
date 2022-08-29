__videotextoCGA:
    cs call far [HUSIS.ProcessoAtual]
    mov cx, 80*25*2+ObjVideoTexto._Tam
    cs call far [Memoria.AlocaRemoto]
    jnc .fim
    es mov word [ObjVideoTexto.Largura],80
    es mov word [ObjVideoTexto.Altura],25
    es mov word [ObjVideoTexto.UltimaLinhaAlterada], 0
    es mov word [ObjVideoTexto.Simultaneos], 0
    mov ax, cs
    es mov word [ObjVideoTexto.PtrAtualiza+2], ax
    es mov word [ObjVideoTexto.PtrAtualiza], _videotextoAtualizaCGA
    es mov word [ObjVideoTexto.ExibeCursorMouse], 0
    es mov word [ObjVideoTexto.ExibeCursorTeclado], 0
    es mov word [ObjVideoTexto.Cores], 16
    es mov word [ObjVideoTexto.UsoInterno], 0
    mov ax, es
    cs mov [VideoTexto.SegVideo], ax
    .fim:
    ret


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