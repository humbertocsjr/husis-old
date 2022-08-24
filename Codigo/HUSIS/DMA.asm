; ===================
;  ISA DMA 8/16 bits
; ===================
;
; Prototipo........: 24/08/2022
; Versao Inicial...: 24/08/2022
; Autor............: Humberto Costa dos Santos Junior
;
; Funcao...........: Implementa o DMA das placas ISA (SB16, Disquete, Rede)
;
; Limitacoes.......: 
;
; Historico........:
;
; - 24/08/2022 - Humberto - Prototipo inicial

ObjDMA:
    .Pagina: equ 0
    .Endereco: equ 1
    .Contagem: equ 2
    .Mascara: equ 3
    .Modo: equ 4
    .Limpa: equ 5
    ._Tam: equ 6

TipoModoDMA:
    .LeiaBloco:                      equ 0b10011000
    .GravaBloco:                     equ 0b10010100
    .LeiaBlocoAuto:                  equ 0b10001000
    .GravaBlocoAuto:                 equ 0b10000100
    .LeiaBlocoInc:                   equ 0b10111000
    .GravaBlocoInc:                  equ 0b10110100
    .LeiaBlocoIncAuto:               equ 0b10101000
    .GravaBlocoIncAuto:              equ 0b10100100
    .LeiaCascata:                    equ 0b11011000
    .GravaCascata:                   equ 0b11010100
    .LeiaCascataAuto:                equ 0b11001000
    .GravaCascataAuto:               equ 0b11000100
    .LeiaCascataInc:                 equ 0b11111000
    .GravaCascataInc:                equ 0b11110100
    .LeiaCascataIncAuto:             equ 0b11101000
    .GravaCascataIncAuto:            equ 0b11100100
    .LeiaDemanda:                    equ 0b00011000
    .GravaDemanda:                   equ 0b00010100
    .LeiaDemandaAuto:                equ 0b00001000
    .GravaDemandaAuto:               equ 0b00000100
    .LeiaDemandaInc:                 equ 0b00111000
    .GravaDemandaInc:                equ 0b00110100
    .LeiaDemandaIncAuto:             equ 0b00101000
    .GravaDemandaIncAuto:            equ 0b00100100
    .LeiaUnico:                      equ 0b01011000
    .GravaUnico:                     equ 0b01010100
    .LeiaUnicoAuto:                  equ 0b01001000
    .GravaUnicoAuto:                 equ 0b01000100
    .LeiaUnicoInc:                   equ 0b01111000
    .GravaUnicoInc:                  equ 0b01110100
    .LeiaUnicoIncAuto:               equ 0b01101000
    .GravaUnicoIncAuto:              equ 0b01100100

DMA: dw _dma, 0
    .IniciaRemoto: dw _dmaIniciaRemoto,0
        ; ax = DMA
    .Pausa: dw _dmaPausa,0
        ; ax = DMA
    .Continua: dw _dmaContinua, 0
        ; ax = DMA
    .Encerra: dw _dmaEncerra, 0
        ; ax = DMA
    dw 0
    .Dados:
        ; Lista de ObjDMA indo da 0 ate 7
        db 0x87,0x00,0x01,0x0A,0x0B,0x0C ; DMA 0
        db 0x83,0x02,0x03,0x0A,0x0B,0x0C ; DMA 1
        db 0x81,0x04,0x05,0x0A,0x0B,0x0C ; DMA 2
        db 0x82,0x06,0x07,0x0A,0x0B,0x0C ; DMA 3
        db 0x8F,0xC0,0xC2,0xD4,0xD6,0xD8 ; DMA 4
        db 0x8B,0xC4,0xC6,0xD4,0xD6,0xD8 ; DMA 5
        db 0x89,0xC8,0xCA,0xD4,0xD6,0xD8 ; DMA 6
        db 0x8A,0xCC,0xCE,0xD4,0xD6,0xD8 ; DMA 7


_dma:
    retf

; ax = DMA
; ret: cf = 1=Ok | 0=Canal nao existe
;      cs:si = ObjDMA
__dmaBusca:
    push ax
    push bx
    push dx
    cmp ax, 8
    jb .ok
        clc
        jmp .fim
    .ok:
    mov si, DMA.Dados
    mov bx, ObjDMA._Tam
    mul bx
    add si, bx
    stc
    .fim:
    pop dx
    pop bx
    pop ax
    retf


; ax = DMA
; es:di = Destino/Origem
; bx = modo
; cx = Quantidade de bytes
; ret: cf = 1=Ok | 0=Canal nao existe
_dmaIniciaRemoto:
    push ax
    push bx
    push cx
    push ds
    call __dmaBusca
    jnc .fim
        mov bh, al
        ; bl = Modo
        ; bh = DMA
        ; cx = Quantidade
        ; Para as interrupcoes
        pushf
        cli
        ; Define o canal que vamos usar impedindo que inicie
        cs mov dx, [si+ObjDMA.Mascara]
        mov al, bh
        and al, 3
        or al, 4
        out dx, al
        ; Limpa qualquer coisa que esteja fazendo
        cs mov dx, [si+ObjDMA.Limpa]
        xor al, al
        out dx, al
        ; Envia o modo
        cs mov dx, [si+ObjDMA.Modo]
        ; Aplica o canal na mascara (2 primeiros bits)
        mov al, bh
        and al, 3
        or al, bl
        out dx, al
        ; Reinicia o flip-flop 
        cs mov dx, [si+ObjDMA.Limpa]
        mov al, 0xff
        out dx, al
        ; Envia o endereco
        cs mov dx, [si+ObjDMA.Endereco]
        push cx
        ; Converte es:di em endereco (ds[0-12bit]*16+di[0-16bit])
        mov ax, es
        mov cl, 4
        shl ax, cl
        add ax, di
        out dx, al
        mov al, ah
        out dx, al
        ; Envia a pagina
        cs mov dx, [si+ObjDMA.Pagina]
        mov ax, es
        mov cl, 12
        shr ax, cl
        out dx, al
        pop cx
        ; Reinicia o flip-flop 
        cs mov dx, [si+ObjDMA.Limpa]
        mov al, 0xff
        out dx, al
        ; Envia quantidade
        cs mov dx, [si+ObjDMA.Contagem]
        dec cx
        mov al, cl
        out dx, al
        mov al, ch
        out dx, al
        ; Retira a mascara que impede que inicie
        cs mov dx, [si+ObjDMA.Mascara]
        mov al, bh
        and al, 3
        out dx, al
        popf
        stc
    .fim:
    pop dx
    pop cx
    pop bx
    pop ax
    retf

; ax = DMA
_dmaPausa:
    push ax
    push ds
    call __dmaBusca
    jnc .fim
        and al, 3
        cs mov dx, [si+ObjDMA.Mascara]
        or al, 4
        out dx, al
        stc
    .fim:
    pop dx
    pop ax
    retf

_dmaContinua:
    push ax
    push ds
    call __dmaBusca
    jnc .fim
        and al, 3
        cs mov dx, [si+ObjDMA.Mascara]
        out dx, al
        stc
    .fim:
    pop dx
    pop ax
    retf

_dmaEncerra:
    push ax
    push ds
    call __dmaBusca
    jnc .fim
        pushf
        cli
        and al, 3
        push ax
        ; Pausa
        cs mov dx, [si+ObjDMA.Mascara]
        or al, 4
        out dx, al
        ; Limpa qualquer coisa que esteja fazendo
        cs mov dx, [si+ObjDMA.Limpa]
        xor al, al
        out dx, al
        pop ax
        ; Pausa
        cs mov dx, [si+ObjDMA.Mascara]
        out dx, al
        popf
        stc
    .fim:
    pop dx
    pop ax
    retf
