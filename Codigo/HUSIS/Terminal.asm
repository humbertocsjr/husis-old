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
; - 20/08/2022 - Humberto - Adaptado para o nucleo reorganizado

Terminal: dw _terminal, 0
    .EscrevaC: dw _terminalC, 0
    .Escreva: dw _terminalEscreva, 0
    .EscrevaOk: dw _terminalEscrevaOk, 0
    .EscrevaPonto: dw _terminalEscrevaPonto, 0
    .EscrevaLocal: dw _terminalEscrevaLocal, 0
    .EscrevaEstatico: dw _terminalEscrevaEstatico, 0
    .EscrevaRemoto: dw _terminalEscrevaRemoto, 0
    .EscrevaHex: dw _terminalEscrevaHex, 0
    .EscrevaNum: dw _terminalEscrevaNum, 0
    .EscrevaNumAX: dw _terminalEscrevaNumAX, 0
    .EscrevaNumBX: dw _terminalEscrevaNumBX, 0
    .EscrevaNumCX: dw _terminalEscrevaNumCX, 0
    .EscrevaNumDX: dw _terminalEscrevaNumDX, 0
    .EscrevaNumSI: dw _terminalEscrevaNumSI, 0
    .EscrevaNumDI: dw _terminalEscrevaNumDI, 0
    .EscrevaNumCS: dw _terminalEscrevaNumCS, 0
    .EscrevaNumDS: dw _terminalEscrevaNumDS, 0
    .EscrevaNumES: dw _terminalEscrevaNumES, 0
    .EscrevaNumEmDSSI: dw _terminalEscrevaNumEmDSSI, 0
    .EscrevaNumEmESDI: dw _terminalEscrevaNumEmESDI, 0
    .EscrevaNumEmDSSIBX: dw _terminalEscrevaNumEmDSSIBX, 0
    .EscrevaNumEmESDIBX: dw _terminalEscrevaNumEmESDIBX, 0
    .EscrevaDebug: dw _terminalEscrevaDebug, 0
    .EscrevaDebugCurto: dw _terminalEscrevaDebugCurto, 0
    .EscrevaDebugDSSI: dw _terminalEscrevaDebugDSSI, 0
    .EscrevaDebugESDI: dw _terminalEscrevaDebugESDI, 0
    .EscrevaDebugDSSIESDI: dw _terminalEscrevaDebugDSSIESDI, 0
    .EscrevaDebugESSI: dw _terminalEscrevaDebugESSI, 0
    .EscrevaDebugPilha: dw _terminalEscrevaDebugPilha, 0
    .EscrevaDebugPara: dw _terminalEscrevaDebugPara, 0
    .EscrevaEnter: dw _terminalEscrevaEnter, 0
    dw 0

_terminal:
    push ax
    mov ax, 0x0003
    push bp
    int 0x10
    pop bp
    pop ax
    retf

; Escreve um caractere no terminal
; al = caractere
_terminalC:
    pushf
    push ax
    push bp
    mov ah, 0xe
    int 0x10
    cmp al, 10
    jne .fim
        mov ah, 0xe
        mov al, 13
        int 0x10
    .fim:
    pop bp
    pop ax
    popf
    retf

_terminalEscrevaPonto:
    pushf
    cs call far [Terminal.Escreva]
    db ' .',0
    popf
    retf

_terminalEscrevaOk:
    pushf
    cs call far [Terminal.Escreva]
    db ' [ OK ]\n',0
    popf
    retf

; Escreve no terminal
_terminalEscreva:
    push bp
    mov bp, sp
    pushf
    push si
    push ax
    .varAx: equ -6
    push bx
    .varBx: equ -8
    push ds
    .varLSeg: equ -10
    push si
    .varL: equ -12
    push es
    .varRSeg: equ -14
    push di
    .varR: equ -16
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
        cmp al, '%'
        je .externo
        .escreve:
        cs call far [Terminal.EscrevaC]
        jmp .caractere
    .externo:
        lodsb
        cmp al, 0
        je .fim
        cmp al, 'a'
        je .externoA
        cmp al, 'b'
        je .externoB
        cmp al, 'c'
        je .externoC
        cmp al, 'd'
        je .externoD
        cmp al, 'L'
        je .externoLSeg
        cmp al, 'l'
        je .externoL
        cmp al, 'R'
        je .externoRseg
        cmp al, 'r'
        je .externoR
        cmp al, 'E'
        je .externoEseg
        jmp .escreve
    .externoA:
        mov bx, [bp+.varAx]
        jmp .externoForma
    .externoB:
        mov bx, [bp+.varBx]
        jmp .externoForma
    .externoC:
        mov bx, cx
        jmp .externoForma
    .externoD:
        mov bx, dx
        jmp .externoForma
    .externoLSeg:
        mov bx, [bp+.varLSeg]
        jmp .externoForma
    .externoL:
        mov bx, [bp+.varL]
        jmp .externoForma
    .externoRseg:
        mov bx, [bp+.varRSeg]
        jmp .externoForma
    .externoR:
        mov bx, [bp+.varR]
        jmp .externoForma
    .externoEseg:
        mov bx, [bp+4]
        jmp .externoForma
    .externoForma:
        lodsb
        cmp al, 0
        je .fim
        cmp al, 'n'
        je .externoNum
        cmp al, 'h'
        je .externoHex
        cmp al, 'c'
        je .externoCarac
        cmp al, 'l'
        je .externoLocal
        cmp al, 'r'
        je .externoRemoto
        cmp al, 'e'
        je .externoEstatico
        cmp al, 't'
        je .externoTrad
        jmp .escreve
    .externoNum:
        cs call far [Terminal.EscrevaNumBX]
        jmp .caractere
    .externoHex:
        mov ax, bx
        cs call far [Terminal.EscrevaHex]
        jmp .caractere
    .externoCarac:
        mov ax, bx
        cs call far [Terminal.EscrevaC]
        jmp .caractere
    .externoLocal:
        push si
        mov si, bx
        cs call far [Terminal.EscrevaLocal]
        pop si
        jmp .caractere
    .externoRemoto:
        push di
        mov di, bx
        cs call far [Terminal.EscrevaRemoto]
        pop di
        jmp .caractere
    .externoEstatico:
        push si
        push ds
        mov si, bx
        cs call far [Terminal.EscrevaEstatico]
        pop ds
        pop si
        jmp .caractere
    .externoTrad:
        push si
        push ds
        mov si, bx
        add si, Trad
        cs call far [Terminal.EscrevaEstatico]
        pop ds
        pop si
        jmp .caractere
    .escape:
        lodsb
        cmp al, 0
        je .fim
        cmp al, 'n'
        je .escapeN
        cmp al, 'r'
        je .escapeR
        cmp al, 't'
        je .escapeN
        jmp .escreve
    .escapeN:
        mov al, 10
        cs call far [Terminal.EscrevaC]
        jmp .caractere
    .escapeR:
        mov al, 13
        cs call far [Terminal.EscrevaC]
        jmp .caractere
    .escapeT:
        mov al, ' '
        jmp .escreve
    .fim:
    mov [bp+2], si
    pop ds
    pop di
    pop es
    pop si
    pop ds
    pop bx
    pop ax
    pop si
    popf
    pop bp
    retf

; Escreve no terminal
; ds:si = Texto
_terminalEscrevaLocal:
    pushf
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
        cmp al, 'r'
        je .escapeR
        cmp al, 't'
        je .escapeN
        jmp .escreve
    .escapeN:
        mov al, 10
        cs call far [Terminal.EscrevaC]
        jmp .caractere
    .escapeR:
        mov al, 13
        cs call far [Terminal.EscrevaC]
        jmp .caractere
    .escapeT:
        mov al, ' '
        jmp .escreve
    .fim:
    pop ax
    pop si
    popf
    retf

_terminalEscrevaNumAX:
    cs call far [Terminal.EscrevaNum]
    retf

_terminalEscrevaNumBX:
    push ax
    mov ax, bx
    cs call far [Terminal.EscrevaNum]
    pop ax
    retf

_terminalEscrevaNumCX:
    push ax
    mov ax, cx
    cs call far [Terminal.EscrevaNum]
    pop ax
    retf

_terminalEscrevaNumDX:
    push ax
    mov ax, dx
    cs call far [Terminal.EscrevaNum]
    pop ax
    retf

_terminalEscrevaNumSI:
    push ax
    mov ax, si
    cs call far [Terminal.EscrevaNum]
    pop ax
    retf

_terminalEscrevaNumDI:
    push ax
    mov ax, di
    cs call far [Terminal.EscrevaNum]
    pop ax
    retf

_terminalEscrevaNumCS:
    push ax
    mov ax, cs
    cs call far [Terminal.EscrevaNum]
    pop ax
    retf

_terminalEscrevaNumDS:
    push ax
    mov ax, cx
    cs call far [Terminal.EscrevaNum]
    pop ax
    retf

_terminalEscrevaNumES:
    push ax
    mov ax, es
    cs call far [Terminal.EscrevaNum]
    pop ax
    retf

_terminalEscrevaNum:
    pushf
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
    popf
    retf
    .constDez: dw 10

_terminalEscrevaHex:
    pushf
    push ax
    push dx
    mov dx, ax
    cmp ax, 0
    je .fim
        xor dx, dx
        cs div word [.constDezesseis]
        cmp ax, 0
        je .fim
            cs call far [Terminal.EscrevaHex]
    .fim:
    mov al, dl
    cs call far [Caractere.DeHexadecimal]
    cs call far [Terminal.EscrevaC]
    pop dx
    pop ax
    popf
    retf
    .constDezesseis: dw 16

_terminalEscrevaEnter:
    pushf
    cs call far [Terminal.Escreva]
    db '\n',0
    popf
    retf

_terminalEscrevaNumEmESDI:
    pushf
    push ax
    es mov ax, [di]
    cs call far [Terminal.EscrevaNum]
    pop ax
    popf
    retf

_terminalEscrevaNumEmDSSI:
    pushf
    push ax
    ds mov ax, [si]
    cs call far [Terminal.EscrevaNum]
    pop ax
    popf
    retf

_terminalEscrevaNumEmESDIBX:
    pushf
    push ax
    es mov ax, [di+bx]
    cs call far [Terminal.EscrevaNum]
    pop ax
    popf
    retf

_terminalEscrevaNumEmDSSIBX:
    pushf
    push ax
    ds mov ax, [si+bx]
    cs call far [Terminal.EscrevaNum]
    pop ax
    popf
    retf

_terminalEscrevaDebug:
    push bp
    mov bp, sp
    pushf
    push bx
    push ax
    cs call far [Terminal.Escreva]
    db '\nDEBUG: AX: 0x%ah[%an]',0
    call .subCaractere
    mov ax, bx
    cs call far [Terminal.Escreva]
    db ' BX: 0x%ah[%an]',0
    mov ax, cx
    cs call far [Terminal.Escreva]
    db ' CX: 0x%ah[%an]',0
    mov ax, dx
    cs call far [Terminal.Escreva]
    db ' DX: 0x%ah[%an]',0
    pop ax
    pop bx
    popf
    pushf
    push bx
    push ax
    jc .cfSim
        cs call far [Terminal.Escreva]
        db ' CF: 0',0
        jmp .cfFim
    .cfSim:
        cs call far [Terminal.Escreva]
        db ' CF: 1',0
    .cfFim:
    mov ax, [bp+4]
    cs call far [Terminal.Escreva]
    db '\n       CS: 0x',0
    cs call far [Terminal.EscrevaHex]
    mov ax, ds
    cs call far [Terminal.Escreva]
    db ' DS: 0x',0
    cs call far [Terminal.EscrevaHex]
    mov ax, si
    cs call far [Terminal.Escreva]
    db ' SI: ',0
    cs call far [Terminal.EscrevaNum]
    mov ax, es
    cs call far [Terminal.Escreva]
    db ' ES: 0x',0
    cs call far [Terminal.EscrevaHex]
    mov ax, di
    cs call far [Terminal.Escreva]
    db ' DI: ',0
    cs call far [Terminal.EscrevaNum]
    cs call far [Terminal.Escreva]
    db '\n       [DS:SI]: ',0
    cs call far [Terminal.EscrevaNum]
    call .subCaractere
    es mov ax, [di]
    cs call far [Terminal.Escreva]
    db ' [ES:DI]: ',0
    cs call far [Terminal.EscrevaNum]
    call .subCaractere
    es mov ax, [si]
    cs call far [Terminal.Escreva]
    db ' [ES:SI]: ',0
    cs call far [Terminal.EscrevaNum]
    call .subCaractere
    ds mov ax, [bx]
    cs call far [Terminal.Escreva]
    db '\n       [DS:BX]: ',0
    cs call far [Terminal.EscrevaNum]
    call .subCaractere
    ds mov ax, [si+bx]
    cs call far [Terminal.Escreva]
    db ' [DS:SI+BX]: ',0
    cs call far [Terminal.EscrevaNum]
    call .subCaractere
    es mov ax, [di+bx]
    cs call far [Terminal.Escreva]
    db ' [ES:DI+BX]: ',0
    cs call far [Terminal.EscrevaNum]
    call .subCaractere
    cs call far [Terminal.Escreva]
    db '\n',0
    mov ax, ss
    mov bx, sp
    cs call far [Terminal.Escreva]
    db '       SS: 0x%ah SP: %bn\n',0
    pop ax
    pop bx
    popf
    pop bp
    retf
    .subCaractere:
        cmp ax, ' '
        jb .fimCaractere
        cmp ax, 'z'
        ja .fimCaractere
            cs call far [Terminal.Escreva]
            db '"',0
            cs call far [Terminal.EscrevaC]
            cs call far [Terminal.Escreva]
            db '"',0
        .fimCaractere:
        ret

_terminalEscrevaDebugCurto:
    pushf
    push bx
    push ax
    cs call far [Terminal.Escreva]
    db '\nDEBUG: AX: 0x%ah[%an]',0
    call .subCaractere
    mov ax, bx
    cs call far [Terminal.Escreva]
    db ' BX: 0x%ah[%an]',0
    mov ax, cx
    cs call far [Terminal.Escreva]
    db ' CX: 0x%ah[%an]',0
    mov ax, dx
    cs call far [Terminal.Escreva]
    db ' DX: 0x%ah[%an]',0
    pop ax
    pop bx
    popf
    pushf
    push bx
    push ax
    jc .cfSim
        cs call far [Terminal.Escreva]
        db ' CF: 0',0
        jmp .cfFim
    .cfSim:
        cs call far [Terminal.Escreva]
        db ' CF: 1',0
    .cfFim:
    mov ax, cs
    cs call far [Terminal.Escreva]
    db '\n       CS: 0x',0
    cs call far [Terminal.EscrevaHex]
    mov ax, ds
    cs call far [Terminal.Escreva]
    db ' DS: 0x',0
    cs call far [Terminal.EscrevaHex]
    mov ax, si
    cs call far [Terminal.Escreva]
    db ' SI: ',0
    cs call far [Terminal.EscrevaNum]
    mov ax, es
    cs call far [Terminal.Escreva]
    db ' ES: 0x',0
    cs call far [Terminal.EscrevaHex]
    mov ax, di
    cs call far [Terminal.Escreva]
    db ' DI: ',0
    cs call far [Terminal.EscrevaNum]
    pop ax
    pop bx
    popf
    retf
    .subCaractere:
        cmp ax, ' '
        jb .fimCaractere
        cmp ax, 'z'
        ja .fimCaractere
            cs call far [Terminal.Escreva]
            db '"',0
            cs call far [Terminal.EscrevaC]
            cs call far [Terminal.Escreva]
            db '"',0
        .fimCaractere:
        ret

_terminalEscrevaDebugPara:
    cs call far [Terminal.EscrevaDebug]
    cs call far [Terminal.Escreva]
    db '-= SISTEMA PARALIZADO =-',0
    .loop:
        hlt
        jmp .loop

_terminalEscrevaDebugDSSI:
    pushf
    push ax
    push si
    push cx
    mov cx, 16
    cs call far [Terminal.Escreva]
    db 'DS:SI: [', 0
    xor ax, ax
    .escreve:
        lodsb
        cs call far [Terminal.Escreva]
        db ' %ah', 0
        cmp al, ' '
        jb .ignora
        cmp al, 'z'
        ja .ignora
            cs call far [Terminal.Escreva]
            db '"%ac"', 0
        .ignora:
        loop .escreve
    cs call far [Terminal.Escreva]
    db ' ]\n', 0
    pop cx
    pop si
    pop ax
    popf
    cs jmp far [Terminal.EscrevaDebug]


_terminalEscrevaDebugDSSIESDI:
    pushf
    push ax
    push si
    push cx
    mov cx, 16
    cs call far [Terminal.Escreva]
    db 'DS:SI: [', 0
    xor ax, ax
    .escreve:
        lodsb
        cs call far [Terminal.Escreva]
        db ' %ah', 0
        cmp al, ' '
        jb .ignora
        cmp al, 'z'
        ja .ignora
            cs call far [Terminal.Escreva]
            db '"%ac"', 0
        .ignora:
        loop .escreve
    cs call far [Terminal.Escreva]
    db ' ]\n', 0
    pop cx
    pop si
    pop ax
    popf
    pushf
    push ax
    push si
    push ds
    push cx
    mov cx, 16
    cs call far [Terminal.Escreva]
    db 'ES:DI: [', 0
    push es
    pop ds
    mov si, di
    xor ax, ax
    .escreve2:
        lodsb
        cs call far [Terminal.Escreva]
        db ' %ah', 0
        cmp al, ' '
        jb .ignora2
        cmp al, 'z'
        ja .ignora2
            cs call far [Terminal.Escreva]
            db '"%ac"', 0
        .ignora2:
        loop .escreve2
    cs call far [Terminal.Escreva]
    db ' ]\n', 0
    pop cx
    pop ds
    pop si
    pop ax
    popf
    cs jmp far [Terminal.EscrevaDebug]

_terminalEscrevaDebugESDI:
    pushf
    push ax
    push si
    push ds
    push cx
    mov cx, 16
    cs call far [Terminal.Escreva]
    db 'ES:DI:', 0
    push es
    pop ds
    mov si, di
    xor ax, ax
    .escreve:
        lodsb
        cs call far [Terminal.Escreva]
        db ' %ah', 0
        cmp al, ' '
        jb .ignora
        cmp al, 'z'
        ja .ignora
            cs call far [Terminal.Escreva]
            db '"%ac"', 0
        .ignora:
        loop .escreve
    pop cx
    pop ds
    pop si
    pop ax
    popf
    cs jmp far [Terminal.EscrevaDebug]

_terminalEscrevaDebugESSI:
    pushf
    push ax
    push si
    push ds
    push cx
    mov cx, 64
    cs call far [Terminal.Escreva]
    db 'ES:SI:', 0
    push es
    pop ds
    xor ax, ax
    .escreve:
        lodsb
        cs call far [Terminal.Escreva]
        db ' ', 0
        cs call far [Terminal.EscrevaHex]
        loop .escreve
    pop cx
    pop ds
    pop si
    pop ax
    popf
    cs jmp far [Terminal.EscrevaDebug]

_terminalEscrevaDebugPilha:
    pushf
    push ax
    push si
    push ds
    push cx
    mov cx, 16
    cs call far [Terminal.Escreva]
    db '\nPILHA:', 0
    push ss
    pop ds
    mov si, sp
    .escreve:
        mov ax, [si]
        cs call far [Terminal.Escreva]
        db ' ', 0
        cs call far [Terminal.EscrevaHex]
        add si, 2
        loop .escreve
    pop cx
    pop ds
    pop si
    pop ax
    popf
    cs jmp far [Terminal.EscrevaDebug]

_terminalEscrevaRemoto:
    pushf
    push ds
    push si
    push es
    pop ds
    mov si, di
    cs call far [Terminal.EscrevaLocal]
    pop si
    pop ds
    popf
    retf

_terminalEscrevaEstatico:
    pushf
    push ds
    push cs
    pop ds
    cs call far [Terminal.EscrevaLocal]
    pop ds
    popf
    retf