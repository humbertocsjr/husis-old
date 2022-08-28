; Rotina que inicializa um Objeto Controle generico em um Rotulo

; Versao usando um texto como titulo
_interfaceIniciaRotuloRemoto:
    cs call far [Interface.AlteraConteudoRemoto]
    jmp _interfaceIniciaRotuloRemotoInterno

; Versao usando um item da traducao como titulo
_interfaceIniciaRotuloTradRemoto:
    cs call far [Interface.AlteraConteudoTradRemoto]
    jmp _interfaceIniciaRotuloRemotoInterno


; Rotina principal para criacao do Objeto Controle
_interfaceIniciaRotuloRemotoInterno:
    mov ax, cs
    es mov [di+ObjControle.PtrRenderiza+2], ax
    es mov word [di+ObjControle.PtrRenderiza], _interfaceRotuloRemoto
    es mov word [di+ObjControle.Tipo], TipoControle.Rotulo
    retf

; Rotina que desenha o rotulo na tela
_interfaceRotuloRemoto:
    push ax
    push bx
    push cx
    push dx
    push ds
    push si
    push di


    ; Desenha o fundo do rotulo
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
    
    ; Prepara para desenhar o texto
    es mov ax, [di+ObjControle.CorFrente]
    es mov [di+ObjControle.InternoCor], ax

    ; Carrega o texto que esta no conteudo
    call __interfacePtrConteudoLocal

    ; Le o texto, caractere por caractere
    .texto:
        ; Carrega um caractere do ponteiro
        lodsb
        ; Verifica se chegou ao fim (Texto terminado em byte 0)
        cmp al, 0
        je .fim
        ; Verifica se eh um caractere de escape
        cmp al, '\'
        jne .desenha
            ; Carrega o caractere de escape
            lodsb
            ; Verifica se chegou ao fim
            cmp al, 0
            je .fim
            ; Desvia caso seja o escape Nova Linha
            cmp al, 'n'
            je .escapeN
            ; Se nao for um escape especial escreve este caractere
            jmp .desenha
            .escapeN:
                ; Escape nova linha
                ; Volta ao inicio da linha X = X1
                es mov bx, [di+ObjControle.CalcX1]
                es mov [di+ObjControle.InternoX1], bx
                ; Adiciona a altura de uma linha de texto
                es add word [di+ObjControle.InternoY1], 11
                jmp .texto
        .desenha:
            ; Desenha o caractere na tela (Fica no arquivo Interface.asm)
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
