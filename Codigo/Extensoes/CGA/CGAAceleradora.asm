; ======================================
;  Controlador CGA - Acelerador Grafico
; ======================================
;
; Prototipo........: 28/08/2022
; Versao Inicial...: 28/08/2022
; Autor............: Humberto Costa dos Santos Junior
;
; Funcao...........: Controla dispositivo de video 
;
; Limitacoes.......: 
;
; Historico........:
;
; - 25/08/2022 - Humberto - Prototipo inicial
; - 27/08/2022 - Humberto - Implementado rotina direta de desenho de pixel
; - 28/08/2022 - Humberto - Criado uma versão com buffer 
%include '../../Incluir/Prog.asm'

; Cabecalho do executavel

nome: db 'CGAAceleradora',0
versao: dw 0,1,1
tipo: dw TipoProg.Executavel
modulos:
    dw 0

importar:
    %include '../../Incluir/Texto.asm'
    %include '../../Incluir/Memoria.asm'
    %include '../../Incluir/HUSIS.asm'
    %include '../../Incluir/Video.asm'
    dw 0
exportar:
    dw 0

; Rotinas Auxiliares

; Desenha um pixel
; ax = X
; bx = Y
; si = Cor
; ret: cf = 1=Ok | 0=Falha
Pixel:
    push ds
    push di
    push si
    push ax
    push bx
    push cx
    push dx
    shl ax, 1
    cmp ax, 640
    jb .larguraOk
        clc
        jmp .fim
    .larguraOk:
    cmp bx, 200
    jb .alturaOk
        clc
        jmp .fim
    .alturaOk:
    shr bx, 1
    jc .inpar
        push ax
        mov ax, cs
        mov di, TempPar
        mov ds, ax
        pop ax
        jmp .fimPonteiro
    .inpar:
        push ax
        mov ax, cs
        mov di, TempInPar
        mov ds, ax
        pop ax
    .fimPonteiro:
    mov dx, ax
    and dx, 7
    mov cx, 3
    shr ax, cl
    mov cx, ax
    mov ax, 640/8
    push dx
    mul bx
    pop dx
    add ax, cx
    add di, ax
    mov cx, dx
    mov ax, 0b11000000
    shr al, cl
    cmp si, 0
    jne .mantem
        not ax
        and [di], al
        jmp .ok
    .mantem:
        or [di], al
        jmp .ok
    .ok:
    stc
    .fim:
    pop dx
    pop cx
    pop bx
    pop ax
    pop si
    pop di
    pop ds
    retf

AtualizaTela:
    push ds
    push es
    push si
    push di
    push ax
    push cx
    mov ax, cs
    mov ds, ax
    mov si, TempPar
    mov ax, 0xb800
    mov es, ax
    mov di, 0
    mov cx, 640/8*100/2
    rep movsw
    mov si, TempInPar
    mov di, 0x2000
    mov cx, 640/8*100/2
    rep movsw
    stc
    pop cx
    pop ax
    pop di
    pop si
    pop es
    pop ds
    retf


; Rotina Principal

inicial:
    mov ax, 6
    int 0x10
    mov si, AtualizaTela
    cs call far [Video.RegistraAtualizaTela]
    mov si, Pixel
    mov cx, 320
    mov dx, 200
    mov ax, 2
    cs call far [Video.RegistraVideo]
    cs call far [Video.LimpaTela]
    cs call far [HUSIS.EntraEmModoBiblioteca]
    retf


TempPar:
    times 640/8*100 db 0
TempInPar:
    times 640/8*100 db 0
Trad: