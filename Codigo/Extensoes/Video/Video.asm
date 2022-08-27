; =================
;  Controlador CGA
; =================
;
; Prototipo........: 25/08/2022
; Versao Inicial...: 25/08/2022
; Autor............: Humberto Costa dos Santos Junior
;
; Funcao...........: Controla dispositivo de video 
;
; Limitacoes.......: 
;
; Historico........:
;
; - 25/08/2022 - Humberto - Prototipo inicial
%include '../../Incluir/Prog.asm'

; Cabecalho do executavel

nome: db 'Video',0
versao: dw 0,1,1
tipo: dw TipoProg.Executavel
modulos:
    dw Video
    dw 0

importar:
    %include '../../Incluir/Texto.asm'
    %include '../../Incluir/Memoria.asm'
    %include '../../Incluir/HUSIS.asm'
    dw 0
exportar:
    dw Video
    db 'Video',0
    dw 0

; Modulos exportados

Video: dw _video,0
    .Pixel: dw _videoPixel, 0
        ; ax = X
        ; bx = Y
        ; si = Cor
        ; ret: cf = 1=Ok | 0=Falha
    .Fundo: dw _videoFundo, 0
        ; ax = X1
        ; bx = Y1
        ; cx = X2
        ; dx = Y2
        ; di = Cor de Fundo
        ; ret: cf = 1=Ok | 0=Falha
    .Borda: dw _videoBorda, 0
        ; ax = X1
        ; bx = Y1
        ; cx = X2
        ; dx = Y2
        ; si = Cor da Borda
        ; ret: cf = 1=Ok | 0=Falha
    .Caixa: dw _videoCaixa, 0
        ; ax = X1
        ; bx = Y1
        ; cx = X2
        ; dx = Y2
        ; si = Cor da Borda
        ; di = Cor de Fundo
        ; ret: cf = 1=Ok | 0=Falha
    .Linha: dw _videoLinha, 0
        ; ax = X1
        ; bx = Y1
        ; cx = X2
        ; dx = Y2
        ; si = Cor da Linha
        ; ret: cf = 1=Ok | 0=Falha
    .LimpaTela: dw _videoLimpaTela,0
        ; di = Cor de Fundo
        ; ret: cf = 1=Ok | 0=Falha
    .ImagemLocal: dw _videoImagemLocal,0
        ; ax = X1
        ; bx = Y1
        ; cx = X2
        ; dx = Y2
        ; ds:si = Imagem
        ; ret: cf = 1=Ok | 0=Falha
    .RegistraVideo: dw _videoRegistraVideo,0
        ; cs:si = DesenhaPixel
        ; ax = Cores Simultaneas
        ; cx = Largura
        ; dx = Altura
        ; ret: cf = 1=Ok | 0=Falha
;------------------------------------------
    .PtrPixel: dw _videoPixel.inicio,0
    .PtrFundo: dw _videoFundo.inicio,0
    .PtrBorda: dw _videoBorda.inicio,0
    .PtrCaixa: dw _videoCaixa.inicio,0
    .PtrLinha: dw _videoLinha.inicio,0
    .PtrLimpaTela: dw _videoLimpaTela.inicio,0
    .PtrImagem: dw _videoImagemLocal.inicio,0
    dw 0
    .Largura: dw 0
    .Altura: dw 0
    .Cores: dw 0

; Rotinas do modulo Video

_video:
    retf

_videoPixel:
    cs jmp far [Video.PtrPixel]
    .inicio:
    clc
    retf

; ax = X1
; bx = Y1
; cx = X2
; dx = Y2
; di = Cor de Fundo
; ret: cf = 1=Ok | 0=Falha
_videoFundo:
    cs jmp far [Video.PtrFundo]
    .inicio:
    push ax
    push bx
    push si
    push bp
    mov bp, sp
    push ax
    .varX1: equ -2
    push bx
    .varY1: equ -4
    push cx
    .varX2: equ -6
    push dx
    .varY2: equ -8
    push di
    .varCorFundo: equ -10
    mov si, di
    .horiz:
        cmp ax, [bp+.varX2]
        ja .fimHoriz
        mov bx, [bp+.varY1]
        .vert:
            cmp bx, [bp+.varY2]
            ja .fimVert
            cs call far [Video.Pixel]
            jnc .fim
            inc bx
            jmp .vert
        .fimVert
        inc ax
        jmp .horiz
    .fimHoriz:
    stc
    .fim:
    mov sp, bp
    pop bp
    pop si
    pop bx
    pop ax
    retf

; ax = X1
; bx = Y1
; cx = X2
; dx = Y2
; si = Cor da Borda
; ret: cf = 1=Ok | 0=Falha
_videoBorda:
    cs jmp far [Video.PtrBorda]
    .inicio:
    push ax
    push bx
    push bp
    mov bp, sp
    push ax
    .varX1: equ -2
    push bx
    .varY1: equ -4
    push cx
    .varX2: equ -6
    push dx
    .varY2: equ -8
    push si
    .varCorBorda: equ -10
    .horiz:
        cmp ax, [bp+.varX2]
        ja .fimHoriz
        mov bx, [bp+.varY1]
        cs call far [Video.Pixel]
        jnc .fim
        mov bx, [bp+.varY2]
        cs call far [Video.Pixel]
        jnc .fim
        inc ax
        jmp .horiz
    .fimHoriz:
    mov bx, [bp+.varY1]
    .vert:
        cmp bx, [bp+.varY2]
        ja .fimVert
        mov ax, [bp+.varX1]
        cs call far [Video.Pixel]
        jnc .fim
        mov ax, [bp+.varX2]
        cs call far [Video.Pixel]
        jnc .fim
        inc bx
        jmp .vert
    .fimVert:
    stc
    .fim:
    mov sp, bp
    pop bp
    pop bx
    pop ax
    retf

; ax = X1
; bx = Y1
; cx = X2
; dx = Y2
; si = Cor da Borda
; di = Cor de Fundo
; ret: cf = 1=Ok | 0=Falha
_videoCaixa:
    cs jmp far [Video.PtrCaixa]
    .inicio:
    cs call far [Video.Fundo]
    cs call far [Video.Borda]
    .fim:
    retf

; ax = X1
; bx = Y1
; cx = X2
; dx = Y2
; si = Cor da Linha
; ret: cf = 1=Ok | 0=Falha
_videoLinha:
    cs jmp far [Video.PtrLinha]
    .inicio:
    clc
    retf

; di = Cor de Fundo
; ret: cf = 1=Ok | 0=Falha
_videoLimpaTela:
    cs jmp far [Video.PtrLimpaTela]
    .inicio:
    push ax
    push bx
    push cx
    push dx
    xor ax, ax
    xor bx, bx
    cs mov cx, [Video.Largura]
    dec cx
    cs mov dx, [Video.Altura]
    dec dx
    cs call far [Video.Fundo]
    pop dx
    pop cx
    pop bx
    pop ax
    retf

; ax = X1
; bx = Y1
; cx = X2
; dx = Y2
; ds:si = Imagem
; ret: cf = 1=Ok | 0=Falha
_videoImagemLocal:
    cs jmp far [Video.PtrImagem]
    .inicio:
    push si
    push ax
    push bx
    push cx
    push dx
    push bp
    mov bp, sp
    push ax
    .varX: equ -2
    push bx
    .varY: equ -4
    push cx
    .varX2: equ -6
    push dx
    .varY2: equ -8
    xor ax, ax
    push ax
    .varLargura: equ -10
    push ax
    .varTemp: equ -12
    push ax
    .varLarguraBytes: equ -14
    lodsw
    cmp ax, 0
    je .tipo0
    jmp .falha
        .tipo0:
            lodsw
            mov [bp+.varLargura], ax
            mov bx, [bp+.varX2]
            sub bx, [bp+.varX]
            cmp ax, bx
            ja .larguraOk
                add ax, [bp+.varX]
                mov [bp+.varX2], ax
            .larguraOk:
            mov ax, [bp+.varLargura]
            xor dx, dx
            mov bx, 8
            div bx
            cmp dx, 0
            je .ignoraByteExtra
                inc ax
            .ignoraByteExtra:
            mov [bp+.varLarguraBytes], ax
            lodsw
            mov bx, [bp+.varY2]
            sub bx, [bp+.varY]
            cmp ax, bx
            ja .alturaOk
                add ax, [bp+.varY]
                mov [bp+.varY2], ax
            .alturaOk:
            mov bx, [bp+.varY]
            .vert:
                cmp bx, [bp+.varY2]
                ja .fimVert
                mov dx, [bp+.varLargura]
                mov ax, [bp+.varX]
                push si
                .horiz
                    cmp ax, [bp+.varX2]
                    ja .fimHoriz
                    mov cx, 8
                    push ax
                    lodsb
                    mov [bp+.varTemp], al
                    pop ax
                    .horizByte:
                        cmp dx, 0
                        je .ignora
                            shl byte [bp+.varTemp], 1
                            push si
                            jc .corSim
                                mov si, 0
                                jmp .fimCor
                            .corSim:
                                mov si, 15
                            .fimCor:
                            cs call far [Video.Pixel]
                            pop si
                            dec dx
                        .ignora:
                        inc ax
                        loop .horizByte
                jmp .horiz
                .fimHoriz
                pop si
                add si, [bp+.varLarguraBytes]
                inc bx
                jmp .vert
            .fimVert:
    .ok:
    stc 
    jmp .fim
    .falha:
    clc
    .fim:
    mov sp, bp
    pop bp
    pop dx
    pop cx
    pop bx
    pop ax
    pop si
    retf

; cs:si = DesenhaPixel
; ax = Cores Simultaneas
; cx = Largura
; dx = Altura
_videoRegistraVideo:
    push bp
    mov bp, sp
    pushf
    push bx
    cli
    mov bx, [bp+4]
    cs mov [Video.PtrPixel+2], bx
    cs mov [Video.PtrPixel], si
    cs mov [Video.Largura], cx
    cs mov [Video.Altura], dx
    cs mov [Video.Cores], ax
    pop bx
    popf
    pop bp
    retf

; Rotina principal
inicial:
    cs call far [HUSIS.EntraEmModoBiblioteca]
    retf

Trad: