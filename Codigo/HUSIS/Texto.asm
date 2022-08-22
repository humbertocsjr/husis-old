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
    .CopiaLocalRemoto: dw _textoCopiaLocalRemoto, 0
        ; Copia texto
        ; ds:si = Origem
        ; es:di = Destino
        ; cx = Capacidade destino
    .CopiaRemotoLocal: dw _textoCopiaRemotoLocal, 0
        ; Copia texto
        ; es:di = Origem
        ; ds:si = Destino
        ; cx = Capacidade destino
    .CopiaEstaticoRemoto: dw _textoCopiaEstaticoRemoto, 0
        ; Copia texto
        ; cs:si = Origem
        ; es:di = Destino
        ; cx = Capacidade destino
    .CopiaRemotoEstatico: dw _textoCopiaRemotoEstatico, 0
        ; Copia texto
        ; es:di = Origem
        ; cs:si = Destino
        ; cx = Capacidade destino
    .CopiaLocalEstatico: dw _textoCopiaLocalEstatico, 0
        ; Copia texto
        ; ds:si = Origem
        ; cs:di = Destino
        ; cx = Capacidade destino
    .CopiaEstaticoLocal: dw _textoCopiaEstaticoLocal, 0
        ; Copia texto
        ; cs:di = Origem
        ; ds:si = Destino
        ; cx = Capacidade destino
    .CalculaTamanhoLocal: dw _textoCalculaTamanhoLocal, 0
        ; Calcula o tamanho de um texto
        ; ds:si = Texto
        ; ret: cx = Tamanho
    .CalculaTamanhoRemoto: dw _textoCalculaTamanhoRemoto, 0
        ; Calcula o tamanho de um texto
        ; es:di = Texto
        ; ret: cx = Tamanho
    .CalculaTamanhoEstatico: dw _textoCalculaTamanhoEstatico, 0
        ; Calcula o tamanho de um texto
        ; cs:si = Texto
        ; ret: cx = Tamanho
    .IgualLocalEstatico: dw _textoIgualLocalEstatico, 0
        ; Compara se dois textos sao iguais
        ; ds:si = Texto 1
        ; cs:di = Texto 2
        ; ret: cf = 1=Igual | 0=Diferente
    .IgualLocalLocal: dw _textoIgualLocalLocal, 0
        ; Compara se dois textos sao iguais
        ; ds:si = Texto 1
        ; ds:di = Texto 2
        ; ret: cf = 1=Igual | 0=Diferente
    .IgualLocalRemoto: dw _textoIgualLocalRemoto, 0
        ; Compara se dois textos sao iguais
        ; ds:si = Texto 1
        ; es:di = Texto 2
        ; ret: cf = 1=Igual | 0=Diferente
    .IgualRemotoEstatico: dw _textoIgualRemotoEstatico, 0
        ; Compara se dois textos sao iguais
        ; cs:si = Texto 1
        ; es:di = Texto 2
        ; ret: cf = 1=Igual | 0=Diferente
    .IgualRemotoRemoto: dw _textoIgualRemotoRemoto, 0
        ; Compara se dois textos sao iguais
        ; es:si = Texto 1
        ; es:di = Texto 2
        ; ret: cf = 1=Igual | 0=Diferente
    .IgualEstaticoEstatico: dw _textoIgualEstaticoEstatico, 0
        ; Compara se dois textos sao iguais
        ; cs:si = Texto 1
        ; cs:di = Texto 2
        ; ret: cf = 1=Igual | 0=Diferente
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

_textoCopiaLocalRemoto:
    pushf
    push ax
    push si
    push di
    push cx
    cmp cx, 0
    jmp .fim
    .copia:
        movsb
        cmp byte [si], 0
        je .fim
        loop .copia
    .fim:
    pop cx
    pop di
    pop si
    pop ax
    popf
    retf

_textoCopiaRemotoLocal:
    pushf
    push ax
    push es
    push ds
    push di
    push si
    ; Inverte ds com es
    mov ax, ds
    push ax
    mov ax, es
    mov ds, ax
    pop ax
    mov es, ax
    ; Inverte si com di
    mov ax, si
    mov si, di
    mov di, ax
    cs call far [Texto.CopiaLocalRemoto]
    pop si
    pop di
    pop ds
    pop es
    pop ax
    popf
    retf

_textoCopiaLocalEstatico:
    pushf
    push ax
    push es
    mov ax, cs
    mov es, ax
    cs call far [Texto.CopiaLocalRemoto]
    pop es
    pop ax
    popf
    retf

_textoCopiaEstaticoLocal:
    pushf
    push ax
    push es
    mov ax, cs
    mov es, ax
    cs call far [Texto.CopiaRemotoLocal]
    pop es
    pop ax
    popf
    retf

_textoCopiaRemotoEstatico:
    pushf
    push ax
    push ds
    mov ax, cs
    mov ds, ax
    cs call far [Texto.CopiaRemotoLocal]
    pop ds
    pop ax
    popf
    retf

_textoCopiaEstaticoRemoto:
    pushf
    push ax
    push ds
    mov ax, cs
    mov ds, ax
    cs call far [Texto.CopiaLocalRemoto]
    pop ds
    pop ax
    popf
    retf

_textoCalculaTamanhoLocal:
    push ax
    push si
    xor cx, cx
    .calcula:
        lodsb
        cmp al, 0
        je .fim
        inc cx
        jmp .calcula
    .fim:
    pop si
    pop ax
    retf

_textoCalculaTamanhoRemoto:
    push ax
    push ds
    push si
    mov ax, es
    mov ds, ax
    mov si, di
    xor cx, cx
    .calcula:
        lodsb
        cmp al, 0
        je .fim
        inc cx
        jmp .calcula
    .fim:
    pop si
    pop ds
    pop ax
    retf

_textoCalculaTamanhoEstatico:
    push ax
    push ds
    push si
    mov ax, cs
    mov ds, ax
    xor cx, cx
    .calcula:
        lodsb
        cmp al, 0
        je .fim
        inc cx
        jmp .calcula
    .fim:
    pop si
    pop ds
    pop ax
    retf

_textoIgualLocalRemoto:
    push ax
    push si
    push di
    .compara:
        cmpsb
        jne .diferente
        cmp byte [si-1], 0
        jne .compara
            stc
            jmp .fim
        .diferente:
            clc
            jmp .fim
    .fim:
    pop di
    pop si
    pop ax
    retf

_textoIgualLocalEstatico:
    push ax
    push es
    push si
    push di
    mov ax, cs
    mov es, ax
    .compara:
        cmpsb
        jne .diferente
        cmp byte [si-1], 0
        jne .compara
            stc
            jmp .fim
        .diferente:
            clc
            jmp .fim
    .fim:
    pop di
    pop si
    pop es
    pop ax
    retf

_textoIgualRemotoEstatico:
    push ax
    push ds
    push si
    push di
    mov ax, cs
    mov ds, ax
    .compara:
        cmpsb
        jne .diferente
        cmp byte [si-1], 0
        jne .compara
            stc
            jmp .fim
        .diferente:
            clc
            jmp .fim
    .fim:
    pop di
    pop si
    pop ds
    pop ax
    retf

_textoIgualRemotoRemoto:
    push ax
    push ds
    push si
    push di
    mov ax, es
    mov ds, ax
    .compara:
        cmpsb
        jne .diferente
        cmp byte [si-1], 0
        jne .compara
            stc
            jmp .fim
        .diferente:
            clc
            jmp .fim
    .fim:
    pop di
    pop si
    pop ds
    pop ax
    retf

_textoIgualLocalLocal:
    push ax
    push es
    push si
    push di
    mov ax, ds
    mov es, ax
    .compara:
        cmpsb
        jne .diferente
        cmp byte [si-1], 0
        jne .compara
            stc
            jmp .fim
        .diferente:
            clc
            jmp .fim
    .fim:
    pop di
    pop si
    pop es
    pop ax
    retf

_textoIgualEstaticoEstatico:
    push ax
    push es
    push ds
    push si
    push di
    mov ax, cs
    mov ds, ax
    mov es, ax
    .compara:
        cmpsb
        jne .diferente
        cmp byte [si-1], 0
        jne .compara
            stc
            jmp .fim
        .diferente:
            clc
            jmp .fim
    .fim:
    pop di
    pop si
    pop ds
    pop es
    pop ax
    retf