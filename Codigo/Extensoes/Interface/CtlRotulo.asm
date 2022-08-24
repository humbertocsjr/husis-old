
_interfaceIniciaRotuloRemoto:
    cs call far [Interface.IniciaRemoto]
    cs call far [Interface.AlteraConteudoRemoto]
    jmp _interfaceIniciaRotuloRemotoInterno

_interfaceIniciaRotuloTradRemoto:
    cs call far [Interface.IniciaRemoto]
    cs call far [Interface.AlteraConteudoTradRemoto]
    jmp _interfaceIniciaRotuloRemotoInterno


_interfaceIniciaRotuloRemotoInterno:
    mov ax, cs
    es mov [di+ObjControle.PtrRenderiza+2], ax
    es mov word [di+ObjControle.PtrRenderiza], _interfaceRotuloRemoto
    es mov word [di+ObjControle.Tipo], TipoControle.Rotulo
    retf

_interfaceRotuloRemoto:
    push ds
    push si
    push ax
    cs call far [Interface.DesenhaFundoRemoto]
    es mov cx, [di+ObjControle.CalcX1]
    es mov dx, [di+ObjControle.CalcY1]
    call __interfacePtrConteudoLocal
    jnc .fim
    .renderiza:
        lodsb
        cmp al, 0
        je .ok
        es cmp cx, [di+ObjControle.CalcX2]
        ja .proxLinhaEscreve
        es cmp dx, [di+ObjControle.CalcY2]
        ja .ok
        cmp al, '\'
        jne .semEscape
            lodsb
            cmp al, 0
            je .ok
            cmp al, 'n'
            je .proxLinha
            cmp al, 't'
            je .escapeT
            jmp .continua
            .escapeT:
                mov al, ' '
                jmp .continua
        .semEscape:
        cmp al, 10
        jne .continua
            .proxLinha:
                es mov cx, [di+ObjControle.CalcX1]
                inc dx
                jmp .renderiza
            .proxLinhaEscreve:
                es mov cx, [di+ObjControle.CalcX1]
                inc dx
        .continua:
        es mov ah, [di+ObjControle.CorFrente]
        cs call far [Interface.DesenhaCaractere]
        inc cx
        jmp .renderiza
    .ok:
    stc
    .fim:
    pop ax
    pop si
    pop ds
    retf
