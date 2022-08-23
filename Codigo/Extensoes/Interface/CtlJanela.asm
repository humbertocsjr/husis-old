


_interfaceIniciaJanelaRemoto:
    cs call far [Interface.IniciaRemoto]
    mov ax, ds
    es mov [di+ObjControle.PtrConteudo+2], ax
    es mov word [di+ObjControle.PtrConteudo], si
    mov ax, cs
    es mov [di+ObjControle.PtrRenderiza+2], ax
    es mov word [di+ObjControle.PtrRenderiza], _interfaceJanelaRemoto
    es mov word [di+ObjControle.Tipo], TipoControle.Janela
    es mov word [di+ObjControle.MargemX1], 1
    es mov word [di+ObjControle.MargemY1], 1
    es mov word [di+ObjControle.MargemX2], 1
    es mov word [di+ObjControle.MargemY2], 1
    retf

_interfaceJanelaRemoto:
    push ds
    push si
    push ax
    push bx
    cs call far [Interface.DesenhaCaixaRemoto]
    es mov cx, [di+ObjControle.CalcX1]
    es mov dx, [di+ObjControle.CalcY1]
    inc cx
    mov al, TipoBorda.HorizDir
    cs mov ah, [Interface.TemaCorBorda]
    cs call far [Interface.DesenhaCaractere]
    inc cx
    mov al, ' '
    cs call far [Interface.DesenhaCaractere]
    inc cx
    call __interfacePtrConteudoLocal
    jnc .fim
    .renderiza:
        lodsb
        cmp al, 0
        je .ok
        es cmp dx, [di+ObjControle.CalcY2]
        ja .ok
        es mov bx, [di+ObjControle.CalcX2]
        sub bx, 3
        cmp cx, bx
        ja .ok
        cs mov ah, [Interface.TemaCorTitulo]
        cs call far [Interface.DesenhaCaractere]
        inc cx
        jmp .renderiza
    .ok:
    cs mov ah, [Interface.TemaCorBorda]
    mov al, ' '
    cs call far [Interface.DesenhaCaractere]
    inc cx
    mov al, TipoBorda.HorizEsq
    cs call far [Interface.DesenhaCaractere]
    stc
    .fim:
    pop bx
    pop ax
    pop si
    pop ds

    retf