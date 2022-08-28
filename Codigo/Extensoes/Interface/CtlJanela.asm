
; Rotina que inicializa um Objeto Controle generico em uma Janela

; Versao usando um texto como titulo
_interfaceIniciaJanelaRemoto:
    cs call far [Interface.AlteraConteudoRemoto]
    jmp _interfaceIniciaJanelaRemotoInterno

; Versao usando um item da traducao como titulo
_interfaceIniciaJanelaTradRemoto:
    cs call far [Interface.AlteraConteudoTradRemoto]
    jmp _interfaceIniciaJanelaRemotoInterno

; Rotina principal para criacao do Objeto Controle
_interfaceIniciaJanelaRemotoInterno:
    mov ax, cs
    es mov [di+ObjControle.PtrRenderiza+2], ax
    es mov word [di+ObjControle.PtrRenderiza], _interfaceJanelaRemoto
    es mov word [di+ObjControle.Tipo], TipoControle.Janela
    ; Definicao da margem interna da janela em pixels
    es mov word [di+ObjControle.MargemX1], 4  ; Borda
    es mov word [di+ObjControle.MargemY1], 19 ; Titulo
    es mov word [di+ObjControle.MargemX2], 4  ; Borda
    es mov word [di+ObjControle.MargemY2], 4  ; Borda
    retf

ctlJanelaIcone:
    dw 0, 16, 16
    db 0b00000000,0b00000000
    db 0b01111111,0b11111110
    db 0b01001010,0b10101010
    db 0b01111111,0b11111110
    db 0b01000000,0b00000010
    db 0b01001101,0b11011010
    db 0b01000000,0b00000010
    db 0b01001110,0b10111010
    db 0b01000000,0b00000010
    db 0b01001011,0b01101010
    db 0b01000000,0b00000010
    db 0b01000000,0b00000010
    db 0b01000000,0b00000010
    db 0b01000000,0b00000010
    db 0b01111111,0b11111110
    db 0b00000000,0b00000000

ctlJanelaIconeFechar:
    dw 0, 16, 16
    db 0b11111111,0b11111111
    db 0b11111000,0b00011111
    db 0b11100000,0b00000111
    db 0b11000000,0b00000011
    db 0b11000000,0b00000011
    db 0b10000100,0b00100001
    db 0b10000010,0b01000001
    db 0b10000001,0b10000001
    db 0b10000001,0b10000001
    db 0b10000010,0b01000001
    db 0b10000100,0b00100001
    db 0b11000000,0b00000011
    db 0b11000000,0b00000011
    db 0b11100000,0b00000111
    db 0b11111000,0b00011111
    db 0b11111111,0b11111111

; Rotina que desenha a janela na tela
_interfaceJanelaRemoto:
    push ax
    push bx
    push cx
    push dx
    push ds
    push si
    push di

    ; Desenha o caixote com borda da janela
    push di
    es mov ax, [di+ObjControle.CalcX1]
    es mov bx, [di+ObjControle.CalcY1]
    es mov cx, [di+ObjControle.CalcX2]
    es mov dx, [di+ObjControle.CalcY2]
    cs mov si, [di+Interface.TemaCorBorda]
    es mov di, [di+ObjControle.CorFundo]
    cs call far [Video.Caixa]
    pop di
    ; Desenha o caixote da barra de titulos
    push di
    es mov ax, [di+ObjControle.CalcX1]
    add ax, 17
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
    add dx, 17
    es mov [di+ObjControle.InternoY2], dx
    cs mov si, [di+Interface.TemaCorBorda]
    es mov di, [di+ObjControle.CorFrente]
    cs call far [Video.Caixa]
    pop di
    es mov ax, [di+ObjControle.CorFundo]
    es mov [di+ObjControle.InternoCor], ax

    ; Carrega o texto do titulo
    call __interfacePtrConteudoLocal

    es inc word [di+ObjControle.InternoY1]

    ; Escreve o titulo na barra de titulo
    .titulo:
        lodsb
        cmp al, 0
        je .fim
        call __interfaceDesenhaCaractere
        jmp .titulo
    .fim:
    es mov ax, [di+ObjControle.CalcX1]
    add ax, 2
    es mov [di+ObjControle.InternoX1], ax
    es inc word [di+ObjControle.InternoX1]
    es mov bx, [di+ObjControle.CalcY1]
    add bx, 17
    es mov [di+ObjControle.InternoY1], bx
    es inc word [di+ObjControle.InternoY1]
    es mov cx, [di+ObjControle.CalcX2]
    sub cx, 2
    es mov [di+ObjControle.InternoX2], cx
    es mov dx, [di+ObjControle.CalcY2]
    sub dx, 2
    es mov [di+ObjControle.InternoY2], dx
    cs mov si, [di+Interface.TemaCorBorda]
    cs call far [Video.Borda]

    es mov ax, [di+ObjControle.CalcX1]
    add ax, 1
    es mov [di+ObjControle.InternoX1], ax
    es mov bx, [di+ObjControle.CalcY1]
    add bx, 1
    es mov [di+ObjControle.InternoY1], bx
    es mov cx, [di+ObjControle.CalcX1]
    add cx, 15
    es mov [di+ObjControle.InternoX2], cx
    es mov dx, [di+ObjControle.CalcY1]
    add dx, 15
    es mov [di+ObjControle.InternoY2], dx
    es cmp word [di+ObjControle.PtrExtensao+2], 0
    je .usarIcone
        es push word [di+ObjControle.PtrExtensao+2]
        pop ds
        es mov si, [di+ObjControle.PtrExtensao]
        jmp .ignorarIconePadrao
    .usarIcone:
        push cs
        pop ds
        mov si, ctlJanelaIcone
    .ignorarIconePadrao:
    cs call far [Video.ImagemLocal]


    es mov ax, [di+ObjControle.CalcX2]
    sub ax, 17
    es mov [di+ObjControle.InternoX1], ax
    es mov bx, [di+ObjControle.CalcY1]
    add bx, 2
    es mov [di+ObjControle.InternoY1], bx
    es mov cx, [di+ObjControle.CalcX2]
    sub cx, 1
    es mov [di+ObjControle.InternoX2], cx
    es mov dx, [di+ObjControle.CalcY1]
    add dx, 16
    es mov [di+ObjControle.InternoY2], dx
    push cs
    pop ds
    mov si, ctlJanelaIconeFechar
    cs call far [Video.ImagemLocal]

    pop di
    pop si
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax
    retf