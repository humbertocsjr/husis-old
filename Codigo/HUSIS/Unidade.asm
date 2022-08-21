; =========================
;  Gerenciador de Unidades
; =========================
;
; Prototipo........: 20/08/2022
; Versao Inicial...: 20/08/2022
; Autor............: Humberto Costa dos Santos Junior
;
; Funcao...........: Gerencia Unidades de Armazenamento, usado como ponte entre Os tipos de Disco e o Sistema de Arquivos
;
; Limitacoes.......: 
;
; Historico........:
;
; - 20/08/2022 - Humberto - Prototipo inicial
ObjUnidade:
    .IdBios: equ 0
        ; 0xffff caso nao use
    .Cilindros: equ 2
    .Cabecas: equ 4
    .Setores: equ 6
    .SetoresPorCilindro: equ 8
    .TotalBlocos: equ 10
    .PtrLeia: equ 14
        ; Le um bloco de 512 bytes
        ; ds:ax = Endereco continuo
        ; ds:si = Unidade
        ; es:di = Destino
        ; ret: cf = 1=Lido | 0=Falha
    .PtrEscreva: equ 18
        ; Le um bloco de 512 bytes
        ; ds:ax = Endereco continuo
        ; ds:si = Unidade
        ; es:di = Origem
        ; ret: cf = 1=Lido | 0=Falha
    .PtrDesmontar: equ 22
    .Raiz: equ 26
        ; Segmento do ObjSisArq
    .Status: equ 28
    ._Tam: equ 30

StatusUnidade:
    .Vazio: equ 0
    .Reservado: equ 10
    .Alocado: equ 20
    .Montado: equ 30

Unidade: dw _unidade, 0
    .ReservaRemoto: dw _unidadeReservaRemoto, 0
        ; Reserva uma unidade
        ; ret: es:di = ObjUnidade reservado
        ;      cf = 1=Ok | 0=Estouro de capacidade
        ;      bx = Unidade
    .ReservaLocal: dw _unidadeReservaLocal, 0
        ; Reserva uma unidade
        ; ret: ds:si = ObjUnidade reservado
        ;      cf = 1=Ok | 0=Estouro de capacidade
        ;      bx = Unidade
    .BuscaRemoto: dw _unidadeBuscaRemoto, 0
        ; Busca uma unidade
        ; bx = Unidade
        ; ret: es:di = ObjUnidade
        ;      cf = 1=Encontrado | 0=Estouro de capacidade
    .BuscaLocal: dw _unidadeBuscaLocal, 0
        ; Busca uma unidade
        ; bx = Unidade
        ; ret: ds:si = ObjUnidade
        ;      cf = 1=Encontrado | 0=Estouro de capacidade
    .LeiaRemoto: dw _unidadeLeiaRemoto,0
        ; Le um bloco remoto
        ; dx:ax = Endereco
        ; bx = Unidade
        ; es:di = Bloco
        ; ret: cf = 1=Ok | 0=Falha
    .LeiaLocal: dw _unidadeLeiaLocal,0
        ; Le um bloco local
        ; dx:ax = Endereco
        ; bx = Unidade
        ; ds:si = Bloco
        ; ret: cf = 1=Ok | 0=Falha
    .LeiaRaizRemoto: dw _unidadeLeiaRaizRemoto,0
        ; Le a raiz de uma unidade
        ; bx = Unidade
        ; ret: cf = 1=Ok | 0=Falha
        ;      es:di = ObjSisArq
    .LeiaRaizLocal: dw _unidadeLeiaRaizLocal,0
        ; Le a raiz de uma unidade
        ; bx = Unidade
        ; ret: cf = 1=Ok | 0=Falha
        ;      ds:si = ObjSisArq
    dw 0
    .UnidadePrincipal: dw 0
    .Lista: dw 0
    ._Capacidade: equ 32

_unidade:
    push ax
    push cx
    push es
    cs mov al, [Prog.Processo]
    mov cx, ObjUnidade._Tam * Unidade._Capacidade
    cs call far [Memoria.AlocaRemoto]
    jnc .fim
    cs call far [Terminal.EscrevaPonto]
    mov ax, es
    cs mov [Unidade.Lista], ax
    mov cx, Unidade._Capacidade
    xor bx, bx
    cs call far [Terminal.EscrevaPonto]
    .limpa:
        es mov word [bx+ObjUnidade.IdBios], 0xffff
        es mov word [bx+ObjUnidade.Status], StatusUnidade.Vazio
        add bx, ObjUnidade._Tam
        loop .limpa
    stc
    .fim:
    cs call far [Terminal.EscrevaPonto]
    pop es
    pop cx
    pop ax
    retf

; Reserva uma unidade
; ret: es:di = ObjUnidade reservado
;      cf = 1=Encontrado | 0=Estouro de capacidade
;      bx = Unidade
_unidadeReservaRemoto:
    push ax
    push cx
    cs mov ax, [Unidade.Lista]
    mov es, ax
    xor di, di
    mov cx, Unidade._Capacidade
    xor bx, bx
    .busca:
        es cmp word [di+ObjUnidade.Status], StatusUnidade.Vazio
        jne .proximo
            es mov word [di+ObjUnidade.Status], StatusUnidade.Reservado
            stc
            jmp .fim
        .proximo:
        inc bx
        add di, ObjUnidade._Tam
        loop .busca
    clc
    .fim:
    pop cx
    pop ax
    retf

; Reserva uma unidade
; ret: ds:si = ObjUnidade reservado
;      cf = 1=Encontrado | 0=Estouro de capacidade
;      bx = Unidade
_unidadeReservaLocal:
    push es
    push di
    cs call far [Unidade.ReservaRemoto]
    jnc .fim
        push es
        pop ds
        mov si, di
    .fim:
    pop di
    pop es
    retf

; Busca uma unidade
; bx = Unidade
; ret: es:di = ObjUnidade
;      cf = 1=Encontrado | 0=Estouro de capacidade
_unidadeBuscaRemoto:
    push ax
    push bx
    cmp bx, Unidade._Capacidade
    jb .ok
        clc
        jmp .fim
    .ok:
    cs mov ax, [Unidade.Lista]
    mov es, ax
    mov ax, ObjUnidade._Tam
    mul bx
    mov di, ax
    stc
    .fim:
    pop bx
    pop ax
    retf


; Busca uma unidade
; bx = Unidade
; ret: ds:si = ObjUnidade
;      cf = 1=Encontrado | 0=Estouro de capacidade
_unidadeBuscaLocal:
    push es
    push di
    cs call far [Unidade.BuscaRemoto]
    jnc .fim
        push es
        pop ds
        mov si, di
    .fim:
    pop di
    pop es
    retf

; Le um bloco remoto
; dx:ax = Endereco
; bx = Unidade
; es:di = Bloco
; ret: cf = 1=Ok | 0=Falha
_unidadeLeiaRemoto:
    push ax
    push dx
    push bx
    push ds
    push si
    cs call far [Unidade.BuscaLocal]
    jnc .fim
    ds cmp word [ObjUnidade.PtrLeia], 0
    jne .ok
        clc
        jmp .fim
    .ok:
    shl ax, 1
    rcl dx, 1
    ds call far [ObjUnidade.PtrLeia]
    jnc .fim
    add di, 512
    add ax, 1
    adc dx, 0
    ds call far [ObjUnidade.PtrLeia]
    .fim:
    pop si
    pop ds
    pop bx
    pop dx
    pop ax
    retf

; Le um bloco local
; dx:ax = Endereco
; bx = Unidade
; ds:si = Bloco
; ret: cf = 1=Ok | 0=Falha
_unidadeLeiaLocal:
    push es
    push di
    push ds
    pop es
    mov di, si
    cs call far [Unidade.LeiaRemoto]
    pop di
    pop es
    retf

; Le a raiz de uma unidade
; bx = Unidade
; ret: cf = 1=Ok | 0=Falha
;      ds:si = ObjSisArq
_unidadeLeiaRaizLocal:
    push es
    push di
    cs call far [Unidade.BuscaRemoto]
    xor si, si
    es push word [ObjUnidade.Raiz]
    pop ds
    es cmp word [ObjUnidade.Raiz], 0
    jne .ok
        clc
        jmp .fim
    .ok:
        stc
    .fim:
    pop di
    pop es
    retf

; Le a raiz de uma unidade
; bx = Unidade
; ret: cf = 1=Ok | 0=Falha
;      es:di = ObjSisArq
_unidadeLeiaRaizRemoto:
    push ds
    push si
    cs call far [Unidade.BuscaLocal]
    xor di, di
    ds push word [ObjUnidade.Raiz]
    pop es
    ds cmp word [ObjUnidade.Raiz], 0
    jne .ok
        clc
        jmp .fim
    .ok:
        stc
    .fim:
    pop si
    pop ds
    retf