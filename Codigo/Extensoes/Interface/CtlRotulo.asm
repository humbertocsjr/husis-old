
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
    push ax
    push bx
    push cx
    push dx
    push ds
    push si
    push di


    push di
    es mov ax, [di+ObjControle.CalcX1]
    es mov [di+ObjControle.InternoX1], ax

    es mov bx, [di+ObjControle.CalcY1]
    es mov [di+ObjControle.InternoY1], bx

    es mov cx, [di+ObjControle.CalcX2]
    es mov [di+ObjControle.InternoX2], cx

    es mov dx, [di+ObjControle.CalcY2]
    es mov [di+ObjControle.InternoY2], dx

    es mov di, [di+ObjControle.CorFundo]
    cs call far [Video.Fundo]
    pop di
    es mov ax, [di+ObjControle.CorFrente]
    es mov [di+ObjControle.InternoCor], ax
    call __interfacePtrConteudoLocal

    .texto:
        lodsb
        cmp al, 0
        je .fim
        cmp al, '\'
        jne .desenha
            lodsb
            cmp al, 0
            je .fim
            cmp al, 'n'
            je .escapeN
            jmp .desenha
            .escapeN:
                es mov bx, [di+ObjControle.CalcX1]
                es mov [di+ObjControle.InternoX1], bx
                es add word [di+ObjControle.InternoY1], 11
                jmp .texto
        .desenha:
            call __interfaceDesenhaCaractere
        jmp .texto
    .fim:
    pop di
    pop si
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax
    retf
