_rotulo:
    push es
    push di
    push ax 
    push bx
    push cx
    push dx
    mov ax, cs
    es mov [di+ObjControle.PtrRenderiza+2], ax
    mov ax, _rotuloRenderiza
    es mov [di+ObjControle.PtrRenderiza], ax
    mov ax, cs
    es mov [di+ObjControle.PtrEntraNoFoco+2], ax
    mov ax, _rotuloEntraNoFoco
    es mov [di+ObjControle.PtrEntraNoFoco], ax
    es mov word [di+ObjControle.Tipo], TipoControle.Rotulo
    cs mov ax, [Interface.TemaCorFrente]
    es mov [di+ObjControle.CorFrente], ax
    cs mov ax, [Interface.TemaCorBorda]
    es mov [di+ObjControle.CorBorda], ax
    cs mov ax, [Interface.TemaCorFundo]
    es mov [di+ObjControle.CorFundo], ax
    cs mov ax, [Interface.TemaCorDestaque]
    es mov [di+ObjControle.CorDestaque], ax

    pop dx
    pop cx
    pop bx
    pop ax
    pop di
    pop es
    retf

_rotuloEntraNoFoco:
    call __interfaceTab
    stc
    retf

_rotuloRenderiza:
    push ds
    push si
    push es
    push di
    push ax 
    push bx
    push cx
    push dx
    ; Desenha Borda
    push di
    es mov ax, [di+ObjControle.CalcX1]
    es mov bx, [di+ObjControle.CalcY1]
    es mov cx, [di+ObjControle.CalcX2]
    es mov dx, [di+ObjControle.CalcY2]
    es mov di, [di+ObjControle.CorFundo]
    cs call far [VideoTexto.Limpa]
    pop di
    es cmp word [di+ObjControle.PtrConteudo + 2], 0
    je .ignoraTexto
        push di
        es push word [di+ObjControle.PtrConteudo+2]
        pop ds
        es mov si, [di+ObjControle.PtrConteudo]
        es mov di, [di+ObjControle.CorFrente]
        cs call far [VideoTexto.Texto]
        pop di
    .ignoraTexto:
    stc
    pop dx
    pop cx
    pop bx
    pop ax
    pop di
    pop es
    pop si
    pop ds
    retf