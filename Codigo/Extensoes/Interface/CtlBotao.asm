_botao:
    push es
    push di
    push ax 
    push bx
    push cx
    push dx
    mov ax, cs
    es mov [di+ObjControle.PtrRenderiza+2], ax
    mov ax, _botaoRenderiza
    es mov [di+ObjControle.PtrRenderiza], ax
    mov ax, cs
    es mov [di+ObjControle.PtrProcessaTecla+2], ax
    mov ax, _botaoProcessaTecla
    es mov [di+ObjControle.PtrProcessaTecla], ax
    mov ax, cs
    es mov [di+ObjControle.PtrEntraNoFoco+2], ax
    mov ax, _botaoEntraNoFoco
    es mov [di+ObjControle.PtrEntraNoFoco], ax
    mov ax, cs
    es mov [di+ObjControle.PtrSaiDoFoco+2], ax
    mov ax, _botaoSaiDoFoco
    es mov [di+ObjControle.PtrSaiDoFoco], ax
    es mov word [di+ObjControle.Tipo], TipoControle.Botao
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

_botaoEntraNoFoco:
    push ax
    push bx
    push cx
    push dx
    push ds
    push si
    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor dx, dx
    call __interfaceExecutaAcaoFoco
    stc
    pop si 
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax
    retf

_botaoSaiDoFoco:
    push ax
    push bx
    push cx
    push dx
    push ds
    push si
    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor dx, dx
    call __interfaceExecutaAcaoSemFoco
    stc
    pop si
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax
    retf


__botaoExecutaAcao:
    push ax
    push bx
    push cx
    push dx
    push ds
    push si
    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor dx, dx
    call __interfaceExecutaAcao
    pop si
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax
    ret

_botaoProcessaTecla:
    push ax
    push bx
    push cx
    push dx
    push ds
    push si
    cmp bx, TipoTeclaEspecial.Enter
    jne .fim
        call __botaoExecutaAcao
    .fim:
    stc
    pop si
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax
    retf

_botaoRenderiza:
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
    es mov dx, [di+ObjControle.CalcY1]
    es mov di, [di+ObjControle.CorFundo]
    cs call far [VideoTexto.Limpa]
    pop di
    push di
    push cs
    pop ds
    mov si, .constInicio
    call __interfaceVerificaFoco
    jc .corBordaDestaqueInicio
        es mov di, [di+ObjControle.CorBorda]
        jmp .fimCorBordaInicio
    .corBordaDestaqueInicio:
        es mov di, [di+ObjControle.CorDestaque]
    .fimCorBordaInicio:
    cs call far [VideoTexto.Texto]
    pop di
    push di
    push ax
    mov si, .constFim
    mov ax, cx
    call __interfaceVerificaFoco
    jc .corBordaDestaqueFim
        es mov di, [di+ObjControle.CorBorda]
        jmp .fimCorBordaFim
    .corBordaDestaqueFim:
        es mov di, [di+ObjControle.CorDestaque]
    .fimCorBordaFim:
    cs call far [VideoTexto.Texto]
    pop ax
    pop di
    inc ax
    dec cx
    es cmp word [di+ObjControle.PtrConteudo + 2], 0
    je .ignoraTexto
        push di
        es push word [di+ObjControle.PtrConteudo+2]
        pop ds
        es mov si, [di+ObjControle.PtrConteudo]
        call __interfaceVerificaFoco
        jc .corDestaque
            es mov di, [di+ObjControle.CorFrente]
            jmp .fimCor
        .corDestaque:
            es mov di, [di+ObjControle.CorDestaque]
        .fimCor:
        cs call far [VideoTexto.Texto]
        pop di
    .ignoraTexto:
    .fim:
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
    .constInicio: db '<',0
    .constFim: db '>',0