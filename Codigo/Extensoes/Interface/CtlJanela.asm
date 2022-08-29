_janela:
    push es
    push di
    push ax 
    push bx
    push cx
    push dx
    mov ax, cs
    es mov [di+ObjControle.PtrRenderiza+2], ax
    mov ax, _janelaRenderiza
    es mov [di+ObjControle.PtrRenderiza], ax
    es mov word [di+ObjControle.Tipo], TipoControle.Janela
    cs mov ax, [Interface.TemaCorFrente]
    es mov [di+ObjControle.CorFrente], ax
    cs mov ax, [Interface.TemaCorBorda]
    es mov [di+ObjControle.CorBorda], ax
    cs mov ax, [Interface.TemaCorFundo]
    es mov [di+ObjControle.CorFundo], ax
    cs mov ax, [Interface.TemaCorTitulo]
    es mov [di+ObjControle.CorDestaque], ax
    es mov word [di+ObjControle.MargemX1], 1
    es mov word [di+ObjControle.MargemY1], 1
    es mov word [di+ObjControle.MargemX2], 1
    es mov word [di+ObjControle.MargemY2], 1

    pop dx
    pop cx
    pop bx
    pop ax
    pop di
    pop es
    retf

_janelaRenderiza:
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
    es mov ax, [di+ObjControle.X1]
    es mov bx, [di+ObjControle.Y1]
    es mov cx, [di+ObjControle.X2]
    es mov dx, [di+ObjControle.Y2]
    es mov di, [di+ObjControle.CorFrente]
    call __interfaceShl8DI
    es or di, [di+ObjControle.CorFundo]
    cs call far [VideoTexto.Limpa]
    pop di
    push di
    es mov di, [di+ObjControle.CorBorda]
    cs call far [VideoTexto.Borda]
    pop di
    push di
    push ax
    push cx
    push dx
    mov ax, cx
    sub ax, 2
    mov cx, 1
    mov dl, 'x'
    cs mov di, [Interface.TemaCorBotaoFechar]
    cs call far [VideoTexto.Repete]
    pop dx
    pop cx
    pop ax
    pop di
    es cmp word [di+ObjControle.PtrConteudo + 2], 0
    je .ignoraTexto
        push di
        es push word [di+ObjControle.PtrConteudo+2]
        pop ds
        es mov si, [di+ObjControle.PtrConteudo]
        es mov di, [di+ObjControle.CorDestaque]
        add ax, 2
        sub cx, 4
        mov dx, bx
        cs call far [VideoTexto.Texto]
        pop di
    .ignoraTexto:
    push es
    pop ds
    mov si, di
    call __interfaceCalcIguala
    mov dx, si
    add si, ObjControle.Itens
    mov cx, ObjControle._CapacidadeItens
    .subItens:
        lodsw
        mov di, ax
        lodsw
        cmp ax, 0
        je .ignoraSubItem
        mov es, ax
        es cmp word [di+ObjControle.PtrRenderiza+2], 0
        je .ignoraSubItem
            push si
            mov si, dx
            call __interfaceCalcAcimaAbaixo
            jnc .foraDosParametros
                es call [di+ObjControle.PtrRenderiza]
            .foraDosParametros:
            pop si
        .ignoraSubItem:
        loop .subItens
    .fim:
    cs call far [VideoTexto.Atualiza]
    pop dx
    pop cx
    pop bx
    pop ax
    pop di
    pop es
    pop si
    pop ds
    retf