
; Rotina que inicializa um Objeto Controle generico em uma Janela

; Versao usando um texto como titulo
_interfaceIniciaJanelaRemoto:
    cs call far [Interface.IniciaRemoto]
    cs call far [Interface.AlteraConteudoRemoto]
    jmp _interfaceIniciaJanelaRemotoInterno

; Versao usando um item da traducao como titulo
_interfaceIniciaJanelaTradRemoto:
    cs call far [Interface.IniciaRemoto]
    cs call far [Interface.AlteraConteudoTradRemoto]
    jmp _interfaceIniciaJanelaRemotoInterno

; Rotina principal para criacao do Objeto Controle
_interfaceIniciaJanelaRemotoInterno:
    mov ax, cs
    es mov [di+ObjControle.PtrRenderiza+2], ax
    es mov word [di+ObjControle.PtrRenderiza], _interfaceJanelaRemoto
    es mov word [di+ObjControle.Tipo], TipoControle.Janela
    ; Definicao da margem interna da janela em pixels
    es mov word [di+ObjControle.MargemX1], 2  ; Borda
    es mov word [di+ObjControle.MargemY1], 16 ; Titulo
    es mov word [di+ObjControle.MargemX2], 2  ; Borda
    es mov word [di+ObjControle.MargemY2], 2  ; Borda
    retf

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

    ; Carrega o texto do titulo
    call __interfacePtrConteudoLocal

    ; Escreve o titulo na barra de titulo
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