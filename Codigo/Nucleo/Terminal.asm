; ==================================
;  Controlador do Terminal de Texto
; ==================================
;
; Prototipo........: 17/08/2022
; Versao Inicial...: 17/08/2022
; Autor............: Humberto Costa dos Santos Junior
;
; Funcao...........: Controla o Dispositivo de Terminal de Texto (Uso do nucleo)
;
; Limitacoes.......: 
;
; Historico........:
;
; - 17/08/2022 - Humberto - Prototipo inicial

Terminal: dw _terminal, 0
    .EscrevaC: dw _terminalC, 0
    .Escreva: dw _terminalEscreva, 0
    .EscrevaSI: dw _terminalEscrevaSI, 0
    .EscrevaNum: dw _terminalEscrevaNum, 0
    .EscrevaEnter: dw _terminalEscrevaEnter, 0
    dw 0

_terminal:
    push ax
    mov ax, 0x0003
    int 0x10
    pop ax
    retf

; Escreve um caractere no terminal
; al = caractere
_terminalC:
    push ax
    push bp
    mov ah, 0xe
    int 0x10
    pop bp
    pop ax
    retf

; Escreve no terminal
_terminalEscreva:
    push bp
    mov bp, sp
    push si
    push ax
    push ds
    mov ax, [bp+4]
    mov ds, ax
    mov si, [bp+2]
    .caractere:
        lodsb
        cmp al, 0
        je .fim
        cmp al, '\'
        je .escape
        .escreve:
        cs call far [Terminal.EscrevaC]
        jmp .caractere
    .escape:
        lodsb
        cmp al, 0
        je .fim
        cmp al, 'n'
        je .escapeN
        cmp al, 't'
        je .escapeN
        jmp .escreve
    .escapeN:
        mov al, 13
        cs call far [Terminal.EscrevaC]
        mov al, 10
        cs call far [Terminal.EscrevaC]
        jmp .caractere
    .escapeT:
        mov al, ' '
        jmp .escreve
    .fim:
    mov [bp+2], si
    pop ds
    pop ax
    pop si
    pop bp
    retf

; Escreve no terminal
; ds:si = Texto
_terminalEscrevaSI:
    push si
    push ax
    .caractere:
        lodsb
        cmp al, 0
        je .fim
        cmp al, '\'
        je .escape
        .escreve:
        cs call far [Terminal.EscrevaC]
        jmp .caractere
    .escape:
        lodsb
        cmp al, 0
        je .fim
        cmp al, 'n'
        je .escapeN
        cmp al, 't'
        je .escapeN
        jmp .escreve
    .escapeN:
        mov al, 13
        cs call far [Terminal.EscrevaC]
        mov al, 10
        cs call far [Terminal.EscrevaC]
        jmp .caractere
    .escapeT:
        mov al, ' '
        jmp .escreve
    .fim:
    pop ax
    pop si
    retf

_terminalEscrevaNum:
    push ax
    push dx
    mov dx, ax
    cmp ax, 0
    je .fim
        xor dx, dx
        cs div word [.constDez]
        cmp ax, 0
        je .fim
            cs call far [Terminal.EscrevaNum]
    .fim:
    mov al, dl
    add al, '0'
    cs call far [Terminal.EscrevaC]
    pop dx
    pop ax
    retf
    .constDez: dw 10

_terminalEscrevaEnter:
    cs call far [Terminal.Escreva]
    db '\n',0
    retf