; ==========================
;  Interrupcoes de Hardware
; ==========================
;
; Prototipo........: 23/08/2022
; Versao Inicial...: 23/08/2022
; Autor............: Humberto Costa dos Santos Junior
;
; Funcao...........: Implementa IRQs
;
; Limitacoes.......: 
;
; Historico........:
;
; - 23/08/2022 - Humberto - Prototipo inicial

Interrupcoes: dw _interrupcoes, 0
    dw 0
    .Mapeado00: dw 0,0
    .Mapeado01: dw 0,0
    .Mapeado02: dw 0,0
    .Mapeado03: dw 0,0
    .Mapeado04: dw 0,0
    .Mapeado05: dw 0,0
    .Mapeado06: dw 0,0
    .Mapeado07: dw 0,0
    .Mapeado08: dw 0,0
    .Mapeado09: dw 0,0
    .Mapeado10: dw 0,0
    .Mapeado11: dw 0,0
    .Mapeado12: dw 0,0
    .Mapeado13: dw 0,0
    .Mapeado14: dw 0,0
    .Mapeado15: dw 0,0

_interrupcoes00:
    cs cmp word     [Interrupcoes.Mapeado00], 0
    je .fim
        cs jmp far [Interrupcoes.Mapeado00]
    .fim:
    iret

_interrupcoes01:
    cs cmp word     [Interrupcoes.Mapeado01], 0
    je .fim
        cs jmp far [Interrupcoes.Mapeado01]
    .fim:
    iret

_interrupcoes02:
    cs cmp word     [Interrupcoes.Mapeado02], 0
    je .fim
        cs jmp far [Interrupcoes.Mapeado02]
    .fim:
    iret

_interrupcoes03:
    cs cmp word     [Interrupcoes.Mapeado03], 0
    je .fim
        cs jmp far [Interrupcoes.Mapeado03]
    .fim:
    iret

_interrupcoes04:
    cs cmp word     [Interrupcoes.Mapeado04], 0
    je .fim
        cs jmp far [Interrupcoes.Mapeado04]
    .fim:
    iret

_interrupcoes05:
    cs cmp word     [Interrupcoes.Mapeado05], 0
    je .fim
        cs jmp far [Interrupcoes.Mapeado05]
    .fim:
    iret

_interrupcoes06:
    cs cmp word     [Interrupcoes.Mapeado06], 0
    je .fim
        cs jmp far [Interrupcoes.Mapeado06]
    .fim:
    iret

_interrupcoes07:
    cs cmp word     [Interrupcoes.Mapeado07], 0
    je .fim
        cs jmp far [Interrupcoes.Mapeado07]
    .fim:
    iret

_interrupcoes08:
    cs cmp word     [Interrupcoes.Mapeado08], 0
    je .fim
        cs jmp far [Interrupcoes.Mapeado08]
    .fim:
    iret

_interrupcoes09:
    cs cmp word     [Interrupcoes.Mapeado09], 0
    je .fim
        cs jmp far [Interrupcoes.Mapeado09]
    .fim:
    iret

_interrupcoes10:
    cs cmp word     [Interrupcoes.Mapeado10], 0
    je .fim
        cs jmp far [Interrupcoes.Mapeado10]
    .fim:
    iret

_interrupcoes11:
    cs cmp word     [Interrupcoes.Mapeado11], 0
    je .fim
        cs jmp far [Interrupcoes.Mapeado11]
    .fim:
    iret

_interrupcoes12:
    cs cmp word     [Interrupcoes.Mapeado12], 0
    je .fim
        cs jmp far [Interrupcoes.Mapeado12]
    .fim:
    iret

_interrupcoes13:
    cs cmp word     [Interrupcoes.Mapeado13], 0
    je .fim
        cs jmp far [Interrupcoes.Mapeado13]
    .fim:
    iret

_interrupcoes14:
    cs cmp word     [Interrupcoes.Mapeado14], 0
    je .fim
        cs jmp far [Interrupcoes.Mapeado14]
    .fim:
    iret

_interrupcoes15:
    cs cmp word     [Interrupcoes.Mapeado15], 0
    je .fim
        cs jmp far [Interrupcoes.Mapeado15]
    .fim:
    iret

_interrupcoes:
    push ax
    push dx

    ; Arruma os ponteiros das IRQs
    pushf
    cli
    push ds
    mov ax, cs
    mov [32*4+2],ax
    mov word [32*4], _interrupcoes00
    mov [33*4+2],ax
    mov word [32*4], _interrupcoes01
    mov [34*4+2],ax
    mov word [32*4], _interrupcoes02
    mov [35*4+2],ax
    mov word [32*4], _interrupcoes03
    mov [36*4+2],ax
    mov word [32*4], _interrupcoes04
    mov [37*4+2],ax
    mov word [32*4], _interrupcoes05
    mov [38*4+2],ax
    mov word [32*4], _interrupcoes06
    mov [39*4+2],ax
    mov word [32*4], _interrupcoes07
    mov [40*4+2],ax
    mov word [32*4], _interrupcoes08
    mov [41*4+2],ax
    mov word [32*4], _interrupcoes09
    mov [42*4+2],ax
    mov word [32*4], _interrupcoes10
    mov [43*4+2],ax
    mov word [32*4], _interrupcoes11
    mov [44*4+2],ax
    mov word [32*4], _interrupcoes12
    mov [45*4+2],ax
    mov word [32*4], _interrupcoes13
    mov [46*4+2],ax
    mov word [32*4], _interrupcoes14
    mov [47*4+2],ax
    mov word [32*4], _interrupcoes15

    pop ds
    popf

    ; Configura IRQs
    mov dx, 0x20
    mov al, 0x11
    out dx, al
    mov dx, 0xa0
    mov al, 0x11
    out dx, al

    mov dx, 0x21
    mov al, 0x20
    out dx, al
    mov dx, 0xa1
    mov al, 0x28
    out dx, al

    mov dx, 0x21
    mov al, 0x04
    out dx, al
    mov dx, 0xa1
    mov al, 0x02
    out dx, al

    mov dx, 0x21
    mov al, 0x01
    out dx, al
    mov dx, 0xa1
    mov al, 0x01
    out dx, al

    mov dx, 0x21
    mov al, 0x00
    out dx, al
    mov dx, 0xa1
    mov al, 0x00
    out dx, al

    pop dx
    pop ax
    retf