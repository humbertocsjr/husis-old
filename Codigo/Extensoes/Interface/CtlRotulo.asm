
_interfaceIniciaRotuloRemoto:
    cs call far [Interface.IniciaRemoto]
    mov ax, ds
    es mov [di+ObjControle.PtrConteudo+2], ax
    es mov word [di+ObjControle.PtrConteudo], si
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
    es mov cx, [di+ObjControle.X1]
    es mov dx, [di+ObjControle.Y1]
    call __interfacePtrConteudoLocal
    jnc .fim
    .renderiza:
        lodsb
        cmp al, 0
        je .ok
        es cmp cx, [di+ObjControle.X2]
        ja .proxLinha
        es cmp dx, [di+ObjControle.Y2]
        ja .ok
        cmp al, 10
        jne .continua
            .proxLinha:
            es mov cx, [di+ObjControle.X1]
            inc dx
            jmp .renderiza
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
