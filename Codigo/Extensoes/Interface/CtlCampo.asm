_campo:
    push es
    push di
    push ax 
    push bx
    push cx
    push dx
    mov ax, cs
    es mov [di+ObjControle.PtrRenderiza+2], ax
    mov ax, _campoRenderiza
    es mov [di+ObjControle.PtrRenderiza], ax
    mov ax, cs
    es mov [di+ObjControle.PtrProcessaTecla+2], ax
    mov ax, _campoProcessaTecla
    es mov [di+ObjControle.PtrProcessaTecla], ax
    es mov word [di+ObjControle.Tipo], TipoControle.Campo
    cs mov ax, [Interface.TemaCorFrente]
    es mov [di+ObjControle.CorFrente], ax
    cs mov ax, [Interface.TemaCorBorda]
    es mov [di+ObjControle.CorBorda], ax
    cs mov ax, [Interface.TemaCorFundo]
    es mov [di+ObjControle.CorFundo], ax
    cs mov ax, [Interface.TemaCorDestaque]
    es mov [di+ObjControle.CorDestaque], ax
    es mov word [di+ObjControle.ValorPosicao], 0
    es mov word [di+ObjControle.ValorPosicao+2], 0
    es mov word [di+ObjControle.ValorTamanho], 0
    pop dx
    pop cx
    pop bx
    pop ax
    pop di
    pop es
    retf

; ds:si = Texto terminado em 0
; al  = Caractere
__campoInsereCaractere:
    push si
    push ax
    mov al, [si]
    .copia:
        cmp al, 0
        je .fim
            inc si
            mov ah, [si]
            mov [si], al
            mov al, ah
        jmp .copia
    .fim:
    inc si
    mov [si], al
    pop ax
    pop si
    mov [si], al
    ret

; ds:si = Texto terminado em 0
__campoRemoveCaractere:
    push ax
    push si
    cmp byte [si], 0
    je .fim
        .copia:
            mov al, [si + 1]
            mov [si], al
            cmp al, 0
            je .fim
            inc si
            jmp .copia
    .fim:
    pop si
    pop ax
    ret

_campoProcessaTecla:
    push ax
    push bx
    push cx
    push dx
    push ds
    push si
    cmp bx, TipoTeclaEspecial.SetaEsquerda
    jne .continuaEsquerda
        es dec word [di+ObjControle.ValorPosicao]
        es mov cx, [di+ObjControle.ValorPosicao]
        cmp cx, [di+ObjControle.ValorPosicao + 2]
        jae .fimEsquerda
            es mov [di+ObjControle.ValorPosicao + 2], cx
        .fimEsquerda:
        jmp .fim
    .continuaEsquerda:
    cmp bx, TipoTeclaEspecial.SetaDireita
    jne .continuaDireita
        es dec word [di+ObjControle.ValorPosicao]
        es mov cx, [di+ObjControle.ValorPosicao]
        es mov cx, [di+ObjControle.CalcX2]
        es sub cx, [di+ObjControle.CalcX1]
        sub cx, 2
        cmp cx, [di+ObjControle.ValorPosicao]
;cs call far [HUSIS.Debug]
        ;jb .fimDireita
            es inc word [di+ObjControle.ValorPosicao]
            es inc word [di+ObjControle.ValorPosicao + 2]
        .fimDireita:
        jmp .fim
    .continuaDireita:
    cmp bx, TipoTeclaEspecial.BackSpace
    jne .continuaBackSpace
        es cmp word [di+ObjControle.ValorPosicao], 0
        je .fimBackSpace
            es push word [di+ObjControle.PtrConteudo]
            pop ds
            es mov si, [di+ObjControle.PtrConteudo]
            es add si, [di+ObjControle.ValorPosicao]
            dec si
            call __campoRemoveCaractere
        .fimBackSpace:
        jmp .fim
    .continuaBackSpace:
    cmp bx, TipoTeclaEspecial.Delete
    jne .continuaDelete
        es cmp word [di+ObjControle.ValorPosicao], 0
        je .fimDelete
            es push word [di+ObjControle.PtrConteudo]
            pop ds
            es mov si, [di+ObjControle.PtrConteudo]
            es add si, [di+ObjControle.ValorPosicao]
            call __campoRemoveCaractere
        .fimDelete:
        jmp .fim
    .continuaDelete:
    cmp ax, 0
    je .continuaAscii
        cmp ax, ' '
        jb .continuaAscii
        es push word [di+ObjControle.PtrConteudo]
        pop ds
        es mov si, [di+ObjControle.PtrConteudo]
        cs call far [Texto.CalculaTamanhoLocal]
        es cmp cx, [di+ObjControle.ValorTamanho]
        jae .continuaAscii
        es add si, [di+ObjControle.ValorPosicao]
        cmp byte [si], 0
        je .fimLinha
            call __campoInsereCaractere
            jmp .continuaAscii
        .fimLinha:
            es add [di+ObjControle.ValorPosicao], cx
            mov [si], al
            inc si
            mov byte [si], 0
    .continuaAscii:
    .fim:
    stc
    pop si
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax
    retf

_campoRenderiza:
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
    es mov di, [di+ObjControle.CorBorda]
    cs call far [VideoTexto.Texto]
    pop di
    push di
    push ax
    mov si, .constFim
    mov ax, cx
    es mov di, [di+ObjControle.CorBorda]
    cs call far [VideoTexto.Texto]
    pop ax
    pop di
    inc ax
    es cmp word [di+ObjControle.PtrConteudo + 2], 0
    je .ignoraTexto
        es push word [di+ObjControle.PtrConteudo+2]
        pop ds
        es mov si, [di+ObjControle.PtrConteudo]
        es cmp word [di+ObjControle.ValorTamanho], 0
        ja .tamanhoOk
            cs call far [Texto.CalculaTamanhoLocal]
            es mov [di+ObjControle.ValorTamanho], cx
        .tamanhoOk:
        es mov cx, [di+ObjControle.ValorPosicao]
        es cmp cx, [di+ObjControle.ValorTamanho]
        jb .posicaoOk
            es mov cx, [di+ObjControle.ValorTamanho]
            dec cx
            es mov [di+ObjControle.ValorPosicao], cx
        .posicaoOk:
        es mov cx, [di+ObjControle.ValorPosicao + 2]
        es cmp cx, [di+ObjControle.ValorTamanho]
        jb .posicao2Ok
            es mov cx, [di+ObjControle.ValorTamanho]
            dec cx
            es mov [di+ObjControle.ValorPosicao + 2], cx
        .posicao2Ok:
        es mov cx, [di+ObjControle.ValorPosicao + 2]
        add si, cx
        .desenha:
            es cmp ax, [di+ObjControle.CalcX2]
            jae .fimDesenho
            push di
            mov dl, [si]
            es cmp cx, [di+ObjControle.ValorPosicao]
            jne .corComum
                push ax
                push cx
                es mov ax, [di+ObjControle.CorFrente]
                push es
                pop cx
                cs cmp [Interface.ObjEmFoco + 2], cx
                jne .ignoraInversao
                cs cmp [Interface.ObjEmFoco], di
                jne .ignoraInversao
                    mov ah, al
                    mov cx, 4
                    shl ah, cl
                    mov cx, 4
                    shr al, cl
                    or al, ah
                    xor ah, ah
                .ignoraInversao:
                mov di, ax
                pop cx
                pop ax
                jmp .fimCor
            .corComum:
                es mov di, [di+ObjControle.CorFrente]
            .fimCor:
            cs call far [VideoTexto.Caractere]
            pop di
            inc ax
            inc cx
            inc si
            jmp .desenha
        .fimDesenho:
    .ignoraTexto:
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
    .constInicio: db '[',0
    .constFim: db ']',0