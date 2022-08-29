_tela:
    push es
    push di
    push ax 
    push bx
    push cx
    push dx
    mov ax, es
    es mov [di+ObjControle.PtrAcima+2], ax
    es mov [di+ObjControle.PtrAcima], di
    mov ax, cs
    es mov [di+ObjControle.PtrRenderiza+2], ax
    mov ax, _telaRenderiza
    es mov [di+ObjControle.PtrRenderiza], ax
    es mov word [di+ObjControle.Tipo], TipoControle.Tela
    cs mov ax, [Interface.TemaCorFrente]
    es mov [di+ObjControle.CorFrente], ax
    cs mov ax, [Interface.TemaCorBorda]
    es mov [di+ObjControle.CorBorda], ax
    cs mov ax, [Interface.TemaCorTela]
    es mov [di+ObjControle.CorFundo], ax
    cs mov ax, [Interface.TemaCorDestaque]
    es mov [di+ObjControle.CorDestaque], ax
    es mov word [di+ObjControle.Visivel], 1
    es mov word [di+ObjControle.X1], 0
    es mov word [di+ObjControle.Y1], 0
    cs call far [VideoTexto.Info]
    dec cx
    es mov word [di+ObjControle.X2], cx
    dec dx
    es mov word [di+ObjControle.Y2], dx
    es mov word [di+ObjControle.MargemX1], 0
    es mov word [di+ObjControle.MargemY1], 0
    es mov word [di+ObjControle.MargemX2], 0
    es mov word [di+ObjControle.MargemY2], 0

    pop dx
    pop cx
    pop bx
    pop ax
    pop di
    pop es
    retf

_telaRenderiza:
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
    cs mov si, [Interface.TemaCaractereTela]
    cs call far [VideoTexto.Preenche]
    pop di
    call __interfaceRenderizaSubItens
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