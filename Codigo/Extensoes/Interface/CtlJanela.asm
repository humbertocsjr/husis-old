_interfaceIniciaJanelaRemoto:
    cs call far [Interface.IniciaRemoto]
    cs call far [Interface.AlteraConteudoRemoto]
    jmp _interfaceIniciaJanelaRemotoInterno

_interfaceIniciaJanelaTradRemoto:
    cs call far [Interface.IniciaRemoto]
    cs call far [Interface.AlteraConteudoTradRemoto]
    jmp _interfaceIniciaJanelaRemotoInterno


_interfaceIniciaJanelaRemotoInterno:
    mov ax, cs
    es mov [di+ObjControle.PtrRenderiza+2], ax
    es mov word [di+ObjControle.PtrRenderiza], _interfaceJanelaRemoto
    es mov word [di+ObjControle.Tipo], TipoControle.Janela
    es mov word [di+ObjControle.MargemX1], 2
    es mov word [di+ObjControle.MargemY1], 16
    es mov word [di+ObjControle.MargemX2], 2
    es mov word [di+ObjControle.MargemY2], 2
    retf

_interfaceJanelaRemoto:
    push ax
    push bx
    push cx
    push dx
    push ds
    push si
    push di


    push di
    es mov ax, [di+ObjControle.CalcX1]
    es mov bx, [di+ObjControle.CalcY1]
    es mov cx, [di+ObjControle.CalcX2]
    es mov dx, [di+ObjControle.CalcY2]
    cs mov si, [di+Interface.TemaCorBorda]
    es mov di, [di+ObjControle.CorFundo]
    cs call far [Video.Caixa]
    pop di
    push di
    es mov ax, [di+ObjControle.CalcX1]
    add ax, 2
    es mov [di+ObjControle.InternoX1], ax
    es inc word [di+ObjControle.InternoX1]
    es mov bx, [di+ObjControle.CalcY1]
    add bx, 2
    es mov [di+ObjControle.InternoY1], bx
    es inc word [di+ObjControle.InternoY1]
    es mov cx, [di+ObjControle.CalcX2]
    sub cx, 2
    es mov [di+ObjControle.InternoX2], cx
    es mov dx, [di+ObjControle.CalcY1]
    add dx, 14
    es mov [di+ObjControle.InternoY2], dx
    cs mov si, [di+Interface.TemaCorBorda]
    es mov di, [di+ObjControle.CorFrente]
    cs call far [Video.Caixa]
    pop di
    es mov ax, [di+ObjControle.CorFundo]
    es mov [di+ObjControle.InternoCor], ax

    call __interfacePtrConteudoLocal

    .titulo:
        lodsb
        cmp al, 0
        je .fim
        call __interfaceDesenhaCaractere
        jmp .titulo
    .fim:
    pop di
    pop si
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax
    retf