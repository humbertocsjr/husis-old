; Formato:
;
; | Pos | Tam | Nome                      |
; |-----|-----|---------------------------|
; | 000 | 004 | Ponteiro para o prox item |
; | 004 | 004 | Identificador             |
; | 008 | 032 | Texto                     |
;



_lista:
    push es
    push di
    push ax 
    push bx
    push cx
    push dx
    mov ax, cs
    es mov [di+ObjControle.PtrRenderiza+2], ax
    mov ax, _listaRenderiza
    es mov [di+ObjControle.PtrRenderiza], ax
    es mov word [di+ObjControle.Tipo], TipoControle.Lista
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

_listaRenderiza:
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
    call __interfaceCalcIguala
    es mov ax, [di+ObjControle.CalcX1]
    es mov bx, [di+ObjControle.CalcY1]
    es mov cx, [di+ObjControle.CalcX2]
    es mov dx, [di+ObjControle.CalcY2]
    es mov di, [di+ObjControle.CorFundo]
    cs call far [VideoTexto.Limpa]
    pop di
    push di
    es mov di, [di+ObjControle.CorBorda]
    cs call far [VideoTexto.Borda]
    pop di
    push di
    inc ax
    dec cx
    es cmp word [di+ObjControle.PtrConteudo + 2], 0
    je .ignoraConteudo
        es push word [di+ObjControle.PtrConteudo+2]
        pop ds
        es mov si, [di+ObjControle.PtrConteudo]
        .lista:
            es cmp bx, [di+ObjControle.Y2]
            jae .ignoraConteudo
            mov dx, bx
            push si
            add si, 8
            push di
            es mov di, [di+ObjControle.CorFrente]
            cs call far [VideoTexto.Texto]
            pop di
            pop si
            cmp word [si+2], 0
            je .ignoraConteudo
            push word [si+2]
            pop ds
            mov si, [si]
            inc bx
            jmp .lista
    .ignoraConteudo:
    .fim:
    call __interfaceSolicitaAtualizacao
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