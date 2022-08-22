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
    .PtrBufferErro: dw .BufferErro
    .BufferErro: times 513 db 0

_disco:
    stc
    retf

_discoRegistaManualmente:
    push ax
    push cx
    push dx
    push es
    push di
    push si
    cs call far [Terminal.EscrevaPonto]
    push bx
    cs call far [Unidade.ReservaRemoto]
    mov si, bx
    pop bx
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

    mov bx, si

    stc
    .fim:
    pop si
    pop di
    pop es
    pop dx
    pop cx
    pop ax
    retf

__discoDebug:
    push ax
    push cx
    push dx
    cs call far [Terminal.Escreva]
    db ' [DISCO C',0
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
    cs call far [Terminal.EscrevaHex]
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
    ; Protege a rotina de leitura contra o erro 9 (Estouro de limite de 64KiB)
    ; Usado 600 como margem para protecao
    push ax
    push bx
    cmp si, 0xffff - 600
    ja .protege
        mov bx, si
        add bx, 600
        shr bx, 1
        shr bx, 1
        shr bx, 1
        shr bx, 1
        mov ax, es
        and ax, 0xfff
        add ax, bx
        cmp ax, 0xfff
        ja .protege
    pop bx
    pop ax
    jmp _discoLeiaSemProtecao

    .protege:
        pop bx
        pop ax
        cs cmp word [Disco.Debug], 0
        je .ignoraDebugErro
            cs call far [Terminal.Escreva]
            db ' [CONTORNO AO ERRO 9 ES:%Rh DI:%rn VIA ',0
        .ignoraDebugErro:
        push es
        push di
        ; Copia o ponteiro do buffer de erro
        push cs
        pop es
        cs push word [Disco.PtrBufferErro]
        pop di
        cs cmp word [Disco.Debug], 0
        je .ignoraDebugErroCont
            cs call far [Terminal.Escreva]
            db ' ES:%Rh DI:%rn]',0
        .ignoraDebugErroCont:
        ; Faz a leitura no buffer backup
        push cs
        call _discoLeiaSemProtecao
        pop di
        pop es
        jnc .fim
        ; Salva ponteiros
        push ds
        push si
        push di
        push cx
        ; Efetua a copia
        mov cx, 512
        push cs
        pop ds
        mov si, Disco.BufferErro
        rep movsb
        ; Restaura ponteiros
        pop cx
        pop di
        pop si
        pop ds
        stc
        .fim:
        retf

_discoLeiaSemProtecao:
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
        int 0x13
        jnc .ok
            cs cmp word [Disco.Debug], 0
            je .ignoraDebugErro
                push ax
                call __discoDebug
                xchg ah, al
                xor ah, ah
                cs call far [Terminal.Escreva]
                db ' [ERRO %an ES:%Rh DI:%rn] ',0
                pop ax
            .ignoraDebugErro:
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