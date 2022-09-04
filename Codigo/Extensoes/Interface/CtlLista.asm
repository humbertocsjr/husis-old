
_lista:
    push es
    push di
    push ax 
    push bx
    push cx
    push dx
    mov ax, cs
    es mov [di+ObjControle.FuncRenderiza+2], ax
    mov ax, _listaRenderiza
    es mov [di+ObjControle.FuncRenderiza], ax
    ;mov ax, cs
    ;es mov [di+ObjControle.FuncProcessaTecla+2], ax
    ;mov ax, _listaProcessaTecla
    ;es mov [di+ObjControle.FuncProcessaTecla], ax
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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

__listaExecutaAcaoAux:
    push ax
    push bx
    push cx
    push dx
    push ds
    push si
    es mov ax, [di+ObjControle.PtrConteudo + 2]
    mov ds, ax
    es mov si, [di+ObjControle.PtrConteudo]
    es mov cx, [di+ObjControle.ValorPosicao]
    cs call far [ListaLocal.NavVaPara]
    es add ax, [di+ObjControle.ValorPosicao]
    xor bx, bx
    xor cx, cx
    xor dx, dx
    call __interfaceExecutaAcaoAux
    pop si
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax
    ret

__listaExecutaAcao:
    push ax
    push bx
    push cx
    push dx
    push ds
    push si
    es mov ax, [di+ObjControle.PtrConteudo + 2]
    mov ds, ax
    es mov si, [di+ObjControle.PtrConteudo]
    es mov cx, [di+ObjControle.ValorPosicao]
    cs call far [ListaLocal.NavVaPara]
    es add ax, [di+ObjControle.ValorPosicao]
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

_listaProcessaTecla:
    push ax
    push bx
    push cx
    push dx
    push ds
    push si
    cmp bx, TipoTeclaEspecial.SetaAcima
    jne .continuaAcima
        es cmp word [di+ObjControle.ValorPosicao], 0
        ; Nao faz nada se ja estiver no inicio
        je .fimAcima
            ; Senao decrementa a posicao do cursor
            es dec word [di+ObjControle.ValorPosicao]
            es mov cx, [di+ObjControle.ValorPosicao]
            es cmp cx, [di+ObjControle.ValorPosicao + 2]
            ; Se a posicao do inicio do texto que esta exibindo estiver 
            ; mostrando depois de onde o cursor esta agora
            jae .fimAcima
                ; Decrementa o inicio do recorte do texto tbm
                es cmp word [di+ObjControle.ValorPosicao + 2], 0
                je .fimAcima
                    ; Apenas por desencargo, decrementa apenas se a posicao 
                    ; nao for zero
                    es dec word [di+ObjControle.ValorPosicao + 2]
            .fimAcima:
            ; Executa o Evento Auxiliar do Controle (Mudou a posicao do cursor)
            call __listaExecutaAcaoAux
            jmp .fim
    .continuaAcima:
    cmp bx, TipoTeclaEspecial.SetaAbaixo
    jne .continuaAbaixo
        es inc word [di+ObjControle.ValorPosicao]
        es mov cx, [di+ObjControle.ValorPosicao]
        es push word [di+ObjControle.PtrConteudo + 2]
        pop ds
        es mov si, [di+ObjControle.PtrConteudo]
        push cx
        cs call far [ListaLocal.CalculaTamanho]
        pop dx
        cmp cx, dx
        jb .posOk
            es dec word [di+ObjControle.ValorPosicao]
        .posOk:        
        es sub cx, [di+ObjControle.ValorPosicao + 2]
        es mov dx, [di+ObjControle.CalcY2]
        es sub dx, [di+ObjControle.CalcY1]
        sub dx, 2
        cmp cx, dx
        jb .fimAbaixo
            es inc word [di+ObjControle.ValorPosicao + 2]
        .fimAbaixo:
        call __listaExecutaAcaoAux
        jmp .fim
    .continuaAbaixo:
    .fim:
    stc
    pop si
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax
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
    call __interfaceVerificaFoco
    jc .corBordaDestaque
        es mov di, [di+ObjControle.CorBorda]
        jmp .fimCorBorda
    .corBordaDestaque:
        es mov di, [di+ObjControle.CorDestaque]
    .fimCorBorda:
    cs call far [VideoTexto.Borda]
    pop di
    es cmp word [di+ObjControle.PtrConteudo + 2], 0
    je .ignoraConteudo
        es push word [di+ObjControle.PtrConteudo+2]
        pop ds
        es mov si, [di+ObjControle.PtrConteudo]
        es mov cx, [di+ObjControle.ValorPosicao + 2]
        es mov bx, [di+ObjControle.CalcY1]
        inc bx
        cs call far [ListaLocal.NavVaPara]
        jnc .ignoraConteudo
        .lista:
            es cmp bx, [di+ObjControle.Y2]
            jae .ignoraConteudo
            push cx
            push bx
            mov dx, bx
            push si
            es add si, [di+ObjControle.ValorA]
            push di
            es mov ax, [di+ObjControle.CalcX1]
            inc ax
            push ax
            es mov ax, [di+ObjControle.CorFrente]
            es cmp cx, [di+ObjControle.ValorPosicao]
            jne .ignoraInversao
                mov ah, al
                mov cx, 4
                shl ah, cl
                mov cx, 4
                shr al, cl
                or al, ah
                xor ah, ah
            .ignoraInversao:
            es mov cx, [di+ObjControle.X2]
            dec cx
            mov di, ax
            pop ax
            cs call far [VideoTexto.Texto]
            pop di
            pop si
            cs call far [ListaLocal.NavProximo]
            pop bx
            pop cx
            jnc .ignoraConteudo
            inc bx
            inc cx
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