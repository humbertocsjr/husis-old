; ======================
;  Controlador de Disco
; ======================
;
; Prototipo........: 20/08/2022
; Versao Inicial...: --/08/2022
; Autor............: Humberto Costa dos Santos Junior
;
; Funcao...........: Controla os discos do computador
;
; Limitacoes.......: 
;
; Historico........:
;
; - 20/08/2022 - Humberto - Prototipo inicial
Disco: dw _disco,0
    .RegistraManualmente: dw _discoRegistaManualmente, 0
    dw 0
    .Debug: dw 0

_disco:
    stc
    retf

_discoRegistaManualmente:
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    cs call far [Terminal.EscrevaPonto]
    cs call far [Unidade.ReservaRemoto]
    jnc .fim
    es mov [di+ObjUnidade.IdBios], ax
    es mov [di+ObjUnidade.Cilindros], bx
    es mov [di+ObjUnidade.Cabecas], cx
    es mov [di+ObjUnidade.Setores], dx
    cs call far [Terminal.EscrevaPonto]
    mov ax, dx
    mul cx
    es mov [di+ObjUnidade.SetoresPorCilindro], ax
    mul bx
    es mov [di+ObjUnidade.TotalBlocos], ax
    es mov [di+ObjUnidade.TotalBlocos+2], dx
    cs call far [Terminal.EscrevaPonto]
    mov ax, cs
    mov bx, _discoLeia
    es mov [di+ObjUnidade.PtrLeia], bx
    es mov [di+ObjUnidade.PtrLeia+2], ax
    mov bx, _discoEscreva
    es mov [di+ObjUnidade.PtrEscreva], bx
    es mov [di+ObjUnidade.PtrEscreva+2], ax

    es mov word [di+ObjUnidade.Status], StatusUnidade.Alocado
    cs call far [Terminal.EscrevaPonto]

    stc
    .fim:
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    retf

__discoDebug:
    push ax
    push cx
    push dx
    cs call far [Terminal.Escreva]
    db '[C',0
    mov ah, cl
    push cx
    mov cl, 6
    shr ah, cl
    mov al, ch
    pop cx
    cs call far [Terminal.EscrevaNum]
    cs call far [Terminal.Escreva]
    db ':H',0
    xor ax, ax
    mov al, dh
    cs call far [Terminal.EscrevaNum]
    cs call far [Terminal.Escreva]
    db ':S',0
    mov al, cl
    and al, 0x3f
    cs call far [Terminal.EscrevaNum]
    cs call far [Terminal.Escreva]
    db '->',0
    mov ax, es
    cs call far [Terminal.EscrevaNum]
    cs call far [Terminal.Escreva]
    db ':',0
    mov ax, bx
    cs call far [Terminal.EscrevaNum]
    cs call far [Terminal.Escreva]
    db ']',0
    pop dx
    pop cx
    pop ax
    ret

_discoLeia:
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    push ds
    push si
    push bp
    mov bp, sp
    xor cx, cx
    push cx
    .varCilindro: equ -2
    push cx
    .varCabeca: equ -4
    push cx
    .varSetor: equ -6
    push cx
    .varDisco: equ -8
    mov cx, 3
    push cx
    .varTentativas: equ -10
    push di
    .varDestino: equ -12
    ; Calcula Cilindros
    ds div word [si+ObjUnidade.SetoresPorCilindro]
    mov [bp+.varCilindro], ax
    ; Calcula Setores e cabecas
    xchg ax, dx
    xor dx, dx
    ds div word [si+ObjUnidade.Setores]
    mov [bp+.varCabeca], ax
    inc dx
    mov [bp+.varSetor], dx
    ; Grava Id do Disco
    ds mov ax, [si+ObjUnidade.IdBios]
    ; Tenta ler
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
        cs cmp word [Disco.Debug], 0
        je .ignoraDebug
            call __discoDebug
        .ignoraDebug:
        push bp
        int 0x13
        pop bp
        jnc .ok
            dec word [bp+.varTentativas]
            cmp word [bp+.varTentativas], 0
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
    pop si
    pop ds
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    retf

_discoEscreva:
    clc
    retf