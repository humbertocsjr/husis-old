; ======================
;  Manipulador de Texto
; ======================
;
; Prototipo........: 20/08/2022
; Versao Inicial...: 20/08/2022
; Autor............: Humberto Costa dos Santos Junior
;
; Funcao...........: Manipula e converte textos
;
; Limitacoes.......: 
;
; Historico........:
;
; - 20/08/2022 - Humberto - Prototipo inicial
Texto: dw _texto, 0
    .LocalParaNumero: dw _textoLocalParaNumero, 0
        ; Converte texto para numero
        ; ds:si = Texto (Altera SI para apos o numero)
        ; ret: cf = 1=Sucesso | 0=Insucesso
        ;      ax = Valor (Caso de insucesso retorna 0)
    .LocalParaHexadecimal: dw _textoLocalParaHexadecimal, 0
        ; Converte texto hexadecimal em numero
        ; ds:si = Texto (Altera SI para apos o numero)
        ; ret: cf = 1=Sucesso | 0=Insucesso
        ;      ax = Valor (Caso de insucesso retorna 0)
    .RemotoParaNumero: dw _textoRemotoParaNumero, 0
        ; Converte texto para numero
        ; es:di = Texto (Altera SI para apos o numero)
        ; ret: cf = 1=Sucesso | 0=Insucesso
        ;      ax = Valor (Caso de insucesso retorna 0)
    .RemotoParaHexadecimal: dw _textoRemotoParaHexadecimal, 0
        ; Converte texto hexadecimal em numero
        ; es:di = Texto (Altera SI para apos o numero)
        ; ret: cf = 1=Sucesso | 0=Insucesso
        ;      ax = Valor (Caso de insucesso retorna 0)
    dw 0

_texto:
    retf

; Converte texto para numero
; ds:si = Texto (Altera SI para apos o numero)
; ret: cf = 1=Sucesso | 0=Insucesso
;      ax = Valor (Caso de insucesso retorna 0)
_textoLocalParaNumero:
    push bx
    push dx
    xor bx, bx
    .processa:
        lodsb
        cmp al, 0
        je .fim
        cs call far [Caractere.EhNumero]
        jnc .fim
        cs call far [Caractere.ParaNumero]
        jnc .fim
        xchg ax, bx
        xor dx, dx
        cs mul word [.constDez]
        xchg ax, bx
        add bx, ax
        jmp .processa
    .fim:
    stc
    dec si
    mov ax, bx
    pop dx
    pop bx
    retf
    .constDez: dw 10


; Converte texto para numero
; es:di = Texto (Altera SI para apos o numero)
; ret: cf = 1=Sucesso | 0=Insucesso
;      ax = Valor (Caso de insucesso retorna 0)
_textoRemotoParaNumero:
    push ds
    push si
    push es
    pop ds
    mov si, di
    cs call far [Texto.LocalParaNumero]
    pop si
    pop ds
    retf

; Converte texto hexadecimal em numero
; ds:si = Texto (Altera SI para apos o numero)
; ret: cf = 1=Sucesso | 0=Insucesso
;      ax = Valor (Caso de insucesso retorna 0)
_textoLocalParaHexadecimal:
    push bx
    push dx
    xor bx, bx
    .processa:
        lodsb
        cmp al, 0
        je .fim
        cs call far [Caractere.EhHexadecimal]
        jnc .fim
        cs call far [Caractere.ParaHexadecimal]
        jnc .fim
        xchg ax, bx
        xor dx, dx
        cs mul word [.constDezesseis]
        xchg ax, bx
        add bx, ax
        jmp .processa
    .fim:
    stc
    dec si
    mov ax, bx
    pop dx
    pop bx
    retf
    .constDezesseis: dw 16

; Converte texto hexadecimal em numero
; ds:si = Texto (Altera SI para apos o numero)
; ret: cf = 1=Sucesso | 0=Insucesso
;      ax = Valor (Caso de insucesso retorna 0)
_textoRemotoParaHexadecimal:
    push ds
    push si
    push es
    pop ds
    mov si, di
    cs call far [Texto.RemotoParaNumero]
    pop si
    pop ds
    retf