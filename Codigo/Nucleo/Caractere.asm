; ===========================
;  Manipulador de Caracteres
; ===========================
;
; Prototipo........: 20/08/2022
; Versao Inicial...: --/08/2022
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
    .EhLetra: dw _caractereEhLetra,0
        ; Verifica se um caractere eh letra
        ; al = Caractere
        ; ret: cf = 1=Sim | 0=Nao
    .DeNumero: dw _caractereDeNumero,0
        ; Converte um numero em caractere (Serve para Decimal ou Hexadecimal)
        ; al = Numero ate 15
        ; ret: cf = 1=Ok | 0=Numero invalido
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
_caractereEhLetra:
    cmp al, 'A'
    jb .nao
    cmp al, 'z'
    ja .nao
    cmp al, 'a'
    jae .sim
    cmp al, 'Z'
    jbe .sim
    jmp .fim
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