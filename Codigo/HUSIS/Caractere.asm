; ===========================
;  Manipulador de Caracteres
; ===========================
;
; Prototipo........: 20/08/2022
; Versao Inicial...: 20/08/2022
; Autor............: Humberto Costa dos Santos Junior
;
; Funcao...........: Manipula e converte caracteres
;
; Limitacoes.......: 
;
; Historico........:
;
; - 20/08/2022 - Humberto - Prototipo inicial
Caractere: dw _caractere, 0
    .EhNumero: dw _caractereEhNumero,0
        ; Verifica se um caractere eh numero
        ; al = Caractere
        ; ret: cf = 1=Sim | 0=Nao
    .EhHexadecimal: dw _caractereEhHexadecimal,0
        ; Verifica se um caractere eh numero
        ; al = Caractere
        ; ret: cf = 1=Sim | 0=Nao
    .EhLetra: dw _caractereEhLetra,0
        ; Verifica se um caractere eh letra
        ; al = Caractere
        ; ret: cf = 1=Sim | 0=Nao
    .EhMaiuscula: dw _caractereEhMaiuscula,0
        ; Verifica se um caractere eh letra maiuscula
        ; al = Caractere
        ; ret: cf = 1=Sim | 0=Nao
    .EhMinuscula: dw _caractereEhMinuscula,0
        ; Verifica se um caractere eh letra minuscula
        ; al = Caractere
        ; ret: cf = 1=Sim | 0=Nao
    .DeNumero: dw _caractereDeNumero,0
        ; Converte um numero em caractere (Serve para Decimal ou Hexadecimal)
        ; al = Numero ate 15
        ; ret: cf = 1=Ok | 0=Numero invalido
        ;      al = Numero em forma de caractere
    .ParaNumero: dw _caractereParaNumero,0
        ; Converte um numero de caractere (Serve para Decimal ou Hexadecimal)
        ; al = Numero ate 15 em caractere
        ; ret: cf = 1=Ok | 0=Numero invalido
        ;      al = Numero
    .DeHexadecimal: dw _caractereDeNumero,0
        ; Converte um numero em caractere (Serve para Decimal ou Hexadecimal)
        ; al = Numero ate 15
        ; ret: cf = 1=Ok | 0=Numero invalido
        ;      al = Numero em forma de caractere
    .ParaHexadecimal: dw _caractereParaNumero,0
        ; Converte um numero de caractere (Serve para Decimal ou Hexadecimal)
        ; al = Numero ate 15 em caractere
        ; ret: cf = 1=Ok | 0=Numero invalido
        ;      al = Numero
    dw 0

_caractere:
    retf

; Verifica se um caractere eh numero
; al = Caractere
; ret: cf = 1=Sim | 0=Nao
_caractereEhNumero:
    cmp al, '0'
    jb .nao
    cmp al, '9'
    ja .nao
        stc
        jmp .fim
    .nao:
    clc
    .fim:
    retf

; Verifica se um caractere eh letra
; al = Caractere
; ret: cf = 1=Sim | 0=Nao
;      al = Numero em forma de caractere
_caractereEhLetra:
    cmp al, 'A'
    jb .nao
    cmp al, 'z'
    ja .nao
    cmp al, 'a'
    jae .sim
    cmp al, 'Z'
    jbe .sim
    jmp .nao
    .sim:
        stc
        jmp .fim
    .nao:
    clc
    .fim:
    retf

; Verifica se um caractere eh letra maiuscula
; al = Caractere
; ret: cf = 1=Sim | 0=Nao
;      al = Numero em forma de caractere
_caractereEhMaiuscula:
    cmp al, 'A'
    jb .nao
    cmp al, 'Z'
    ja .nao
    .sim:
        stc
        jmp .fim
    .nao:
    clc
    .fim:
    retf

; Verifica se um caractere eh letra minuscula
; al = Caractere
; ret: cf = 1=Sim | 0=Nao
;      al = Numero em forma de caractere
_caractereEhMinuscula:
    cmp al, 'a'
    jb .nao
    cmp al, 'z'
    ja .nao
    .sim:
        stc
        jmp .fim
    .nao:
    clc
    .fim:
    retf

; Verifica se um caractere eh hexadecimal
; al = Caractere
; ret: cf = 1=Sim | 0=Nao
;      al = Numero em forma de caractere
_caractereEhHexadecimal:
    cs call far [Caractere.EhNumero]
    jc .fim
    cmp al, 'A'
    jb .nao
    cmp al, 'f'
    ja .nao
    cmp al, 'a'
    jae .sim
    cmp al, 'F'
    jbe .sim
    jmp .nao
    .sim:
        stc
        jmp .fim
    .nao:
    clc
    .fim:
    retf

; Converte um numero em caractere (Serve para Decimal ou Hexadecimal)
; al = Numero ate 15
; ret: cf = 1=Ok | 0=Numero invalido
_caractereDeNumero:
    push bx
    cmp al, 0xf
    jbe .ok
        clc
        jmp .fim
    .ok:
    mov bx, .constMapa
    add bx, ax
    cs mov al, [bx]
    stc
    .fim:
    pop bx
    retf
    .constMapa: db '0123456789ABCDEF'

; Converte um numero de caractere (Serve para Decimal ou Hexadecimal)
; al = Numero ate 15 em caractere
; ret: cf = 1=Ok | 0=Numero invalido
;      al = Numero
_caractereParaNumero:
    push bx
    cs call far [Caractere.EhHexadecimal]
    jc .ok
        clc
        jmp .fim
    .ok:
    cs call far [Caractere.EhNumero]
    jc .numero
        cs call far [Caractere.EhMaiuscula]
        jc .maiuscula
            sub al, 'a' - 10
            jmp .encerra
        .maiuscula:
            sub al, 'A' - 10
            jmp .encerra
    .numero:
        sub al, '0'
    .encerra:
    stc
    .fim:
    pop bx
    retf
    .constMapa: db '0123456789ABCDEF'