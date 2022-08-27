; ============================
;  Setor Inicial para MinixFS
; ============================
;
; Prototipo........: 16/08/2022
; Versao Inicial...: 17/08/2022
; Autor............: Humberto Costa dos Santos Junior
;
; Funcao...........: Inicia um arquivo do sistema de arquivos e carrega 
;                    conforme configuracoes definidas no cabecalho.
;
; Limitacoes.......: Carrega arquivos de no maximo 6 KiB
;
; Historico........:
;
; - 16/08/2022 - Humberto - Prototipo inicial
; - 17/08/2022 - Humberto - Versao inicial funcional com limitacao de 6 KiB
; - 17/08/2022 - Humberto - Avisa caso tente carregar um arquivo maior


cpu 8086
org 0


Inicio:

    ; Garante que os segmentos apontam para o 0x7c0
    cli
    mov ax, 0x7c0
    push ax
    pop ds
    push ax
    pop es
    push ax
    mov ax, 0x600
    mov ss, ax
    mov sp, 0x7bfe-0x6000
    sti

    ; Pula para o segmento definido
    push es
    mov ax, .desvio0
    push ax
    retf

    .desvio0:

    ; Grava o disco atual
    mov [Config.Disco], dl

    ; Le continuacao deste binario
    .leContinuacao:

    ; Escreve na tela sem as funcoes extendidas
    mov ah, 0xe
    mov al, '>'
    int 0x10
    mov ah, 0xe
    mov al, ' '
    int 0x10
    mov ah, 0xe
    mov al, '.'
    int 0x10

    ; Le a continuacao do setor inicial, completando o 1 KiB de codigo
    mov ax, 0x201
    mov dh, 0
    mov dl, [Config.Disco]
    mov cx, 2
    mov bx, Continuacao
    int 0x13
    jnc .ok
        ; Caso nao consiga ler, escreve um X e tenta novamente
        mov ah, 0xe
        mov al, 'X'
        int 0x10
        mov dl, [Config.Disco]
        xor ax, ax
        int 0x13
        jmp .leContinuacao
    .ok:

    call TermEscreva
    db ' [ OK ]',13,10,'Montando',0

    xor dx, dx
    mov ax, 1
    mov bx, [Config.Disco]
    mov di, Indice
    call DiscoLer
    jc .okIndice
        jmp ErroLeitura
    .okIndice:

    ; Calcular posicao da lista e itens
    mov ax, 2
    add ax, [Indice.BlocosMapaBlocos]
    add ax, [Indice.BlocosMapaItens]
    add [Config.PosItens], ax
    mov bx, [Indice.PrimeiroBloco]
    sub bx, ax
    mov [Config.QtdBlocosItens], bx

    ; Calcula o Bloco e Posicao do Arquivo
    mov ax, [Config.ArquivoCodigo]
    dec ax
    xor dx, dx
    mov bx, ObjItem._QtdPorBloco
    div bx
    push ax
    mov ax, dx
    mov bx, ObjItem._Tam
    mul bx
    mov [Config.PosArquivo], ax
    pop ax
    add ax, [Config.PosItens]

    ; Carregar Itens
    xor dx, dx
    mov bx, [Config.Disco]
    mov di, Itens
    call DiscoLer
    jc .okItens
        jmp ErroLeitura
    .okItens:

    call TermEscrevaOk

    call TermEscreva
    db 'Carregando',0

    mov si, [Config.PosArquivo]
    add si, Itens
    cmp word [si+ObjItem.ZonaDuplaIndireta], 0
    je .arquivoOk
        call TermEscreva
        db ' [ ARQUIVO GRANDE ]',0
        jmp LoopInfinito
    .arquivoOk:
    add si, ObjItem.Zonas
    mov cx, ObjItem._QtdZonas
    mov ax, [Config.Destino]
    mov es, ax

    xor di, di
    .carrega:
        mov ax, [si]
        cmp ax, 0
        je .fimCarrega
        xor dx, dx
        mov bx, [Config.Disco]
        call DiscoLer
        jc .okCarrega
            jmp ErroLeitura
        .okCarrega:
        add si, 2
        add di, 1024
        loop .carrega
    cs cmp word [.trava], 0
    jne .fimCarrega
        call TermEscreva
        db ' || ',0
        mov ax, [si]
        cmp ax, 0
        je .fimCarrega
        push es
        push di

        push ds
        pop es
        mov di, Itens
        xor dx, dx
        mov ax, [si]
        mov bx, [Config.Disco]
        call DiscoLer
        jc .okCarregaExt
            jmp ErroLeitura
        .okCarregaExt:
        pop di
        pop es
        mov cx, 512
        mov si, Itens
        cs mov word [.trava], 1
        jmp .carrega
    .trava: dw 0
    .fimCarrega:

    call TermEscrevaOk
    
    call TermEscreva
    db 'Iniciando',0

    xor si, si
    es mov [si+6], di

    xor di, di
    mov cx, [Config.Cilindros]
    mov dh, [Config.Cabecas]
    mov dl, [Config.Disco]
    mov bx, [Config.Setores]
    call TermEscreva
    db ' .',0
    push es
    pop ds
    push cs
    mov ax, LoopInfinito
    push ax
    push ds
    mov ax, [si+4]
    push ax
    mov ax, 1989
    call TermEscreva
    db ' . [ OK ]',13,10,13,10,0
    retf
    
ErroLeitura:
    call TermEscreva
    db ' [ FALHA LEITURA ]',0
    jmp LoopInfinito

LoopInfinito:
    call TermEscreva
    db 13,10,13,10,'-= EXECUCAO ENCERRADA =-',0
    .loop:
    hlt
    jmp .loop

times 510-($-$$) db 0
dw 0xaa55
Continuacao:

Config:
    .CabecalhoConfig: db 'HU'
    .VersaoConfig: dw 1
    .Destino: dw 0x880
    .Disco: dw 0
    .Cilindros: dw DEFCILINDROS
    .Cabecas: dw DEFCABECAS
    .Setores: dw DEFSETORES
    .SetoresCabecas: dw DEFSETORES * DEFCABECAS
    .Debug: dw 0
    .ArquivoCodigo: dw 2
    .PosItens: dw 0
    .QtdBlocosItens: dw 0
    .PosArquivo: dw 0

TermEscrevaEnter:
    call TermEscreva
    db 13,10,0
    ret

TermEscrevaOk:
    call TermEscreva
    db ' [ OK ]',13,10,0
    ret

TermEscreva:
    push bp
    mov bp, sp
    push si
    push ax
    mov si, [bp+2]
    .loop:
        cs lodsb
        cmp al, 0
        je .fim
        mov ah, 0xe
        int 0x10
        jmp .loop
    .fim:
    mov [bp+2], si
    pop ax
    pop si
    pop bp
    ret

TermEscrevaNum:
    push ax
    push dx
    mov dx, ax
    cmp ax, 0
    je .fim
        xor dx, dx
        cs div word [.constDez]
        cmp ax, 0
        je .fim
            call TermEscrevaNum
    .fim:
    mov al, dl
    add al, '0'
    mov ah, 0xe
    int 0x10
    pop dx
    pop ax
    ret
    .constDez: dw 10

TermEscrevaCHS:
    push ax
    push cx
    push dx
    call TermEscreva
    db '[C',0
    mov ah, cl
    push cx
    mov cl, 6
    shr ah, cl
    mov al, ch
    pop cx
    call TermEscrevaNum
    call TermEscreva
    db ':H',0
    xor ax, ax
    mov al, dh
    call TermEscrevaNum
    call TermEscreva
    db ':S',0
    mov al, cl
    and al, 0x3f
    call TermEscrevaNum
    call TermEscreva
    db ']',0
    pop dx
    pop cx
    pop ax
    ret

; Le um bloco do disco
; dx:ax = Endereco
; es:di = Destino
; bx = Disco
DiscoLer:
    push ax
    push dx
    push di
    call TermEscreva
    db ' .',0
    shl ax, 1
    rcl dx, 1
    call DiscoLer512
    jnc .fim
    add di, 512
    add ax, 1
    adc dx, 0
    call DiscoLer512
    .fim:
    pop di
    pop dx
    pop ax
    ret

; Le um bloco do disco
; dx:ax = Endereco
; es:di = Destino
; bx = Disco
DiscoLer512:
    cmp word [Config.Debug], 0
    je .ignoraDebugPre
        call TermEscreva
        db ' [',0
        call TermEscrevaNum
        call TermEscreva
        db ']',0
    .ignoraDebugPre:
    push ax
    push bx
    push cx
    push dx
    push di
    push bp
    mov bp, sp
    push ax
    push dx
    .varEndereco: equ -4
    push ax
    .varCilindro: equ -6
    push ax
    .varCabeca: equ -8
    push ax
    .varSetor: equ -10
    push bx
    .varDisco: equ -12
    push di
    .varDestino: equ -14
    push ax
    .varFalhas: equ -16
    mov word [bp+.varFalhas], 3
    ; Calculo do endereço
    div word [Config.SetoresCabecas]
    mov [bp+.varCilindro], ax
    xchg ax, dx
    xor dx, dx
    div word [Config.Setores]
    mov [bp+.varCabeca], ax
    inc dx
    mov [bp+.varSetor], dx
    ; Montando comando bios
    .tentativa:
        mov bx, [bp+.varDestino]
        mov dh, [bp+.varCabeca]
        mov dl, [bp+.varDisco]
        mov ch, [bp+.varCilindro]
        mov cl, [bp+.varSetor]
        mov al, [bp+.varCilindro+1]
        and al, 0x2
        shl al, 1
        shl al, 1
        shl al, 1
        shl al, 1
        shl al, 1
        shl al, 1
        or cl, al
        mov ax, 0x201
        cmp word [Config.Debug], 0
        je .ignoraDebug
            call TermEscrevaCHS
        .ignoraDebug:
        push bp
        int 0x13
        pop bp
        jnc .ok
            dec word [bp+.varFalhas]
            cmp word [bp+.varFalhas], 0
            je .falha
            xor ax, ax
            mov dl, [bp+.varDisco]
            push bp
            int 0x13
            pop bp
            jmp .tentativa
    .falha:
        clc
        jmp .fim
    .ok:
        stc
    .fim:
    mov sp, bp
    pop bp
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret


times 1024-($-$$) db 0

ObjItem:
    .Modo: equ 0x0
    .UsuarioCod: equ 0x2
    .Tamanho: equ 0x4
    .DataHora: equ 0x8
    .GrupoCod: equ 0xc
    .Ligacoes: equ 0xd
    .Zonas: equ 0xe
    ._QtdZonas: equ 7
    .ZonaIndireta: equ 0x1c
    .ZonaDuplaIndireta: equ 0x1e
    ._Tam: equ 32
    ._QtdPorBloco: equ 32

Indice:
    .QtdItens: equ Indice
    ; 1.44: 32
    .QtdBlocos: equ Indice + 0x2
    ; 1.44: 1440
    .BlocosMapaItens: equ Indice + 0x4
    ; 1.44: 1
    .BlocosMapaBlocos: equ Indice + 0x6
    ; 1.44: 1
    .PrimeiroBloco: equ Indice + 0x8
    ; 1.44: 5 (Posicao 0x1400)
    .TamanhoBloco: equ Indice + 0xa
    ; 1.44: 0
    .TamanhoMaxArq: equ Indice + 0xc
    ; 1.44: 268.966.912
    .Assinatura: equ Indice + 0x10
    ; 1.44: 0x7f13
    .EstadoMontagem: equ Indice + 0x12
    ; 1.44: 1

Itens: equ Indice + 1024
; Destino = 0x7c0 + 0x40(Binario) + 0x40(Indice) + 0x40(Itens) = 0x880