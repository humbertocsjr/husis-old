VideoTexto: dw _videotexto,0
    .Atualiza: dw _videotextoAtualiza,0
    .LimpaTela: dw _videotextoLimpaTela,0
        ; di = Cor unificada
    .Texto: dw _videotextoTexto, 0
        ; ax = X1
        ; bx = Y1
        ; cx = X2
        ; dx = Y2
        ; ds:si = Texto
        ; di = Cor unificada
    .Repete: dw _videotextoRepete,0
        ; dl = Caractere
        ; cx = Quantidade
        ; ax = X
        ; bx = Y
        ; di = Cor unificada
    .Limpa: dw _videotextoLimpa,0
        ; ax = X1
        ; bx = Y1
        ; cx = X2
        ; dx = Y2
        ; di = Cor unificada
    .Borda: dw _videotextoBorda, 0
        ; ax = X1
        ; bx = Y1
        ; cx = X2
        ; dx = Y2
        ; di = Cor unificada
    .Caractere: dw _videotextoCaractere,0
        ; dl = Caractere
        ; ax = X
        ; bx = Y
        ; di = Cor unificada
    .Preenche: dw _videotextoPreenche,0
        ; ax = X1
        ; bx = Y1
        ; cx = X2
        ; dx = Y2
        ; si = Caractere
        ; di = Cor unificada
    .PreencheTela: dw _videotextoPreencheTela,0
        ; si = Caractere
        ; di = Cor unificada
    .Info: dw _videotextoInfo, 0
        ; ret: cx = Largura
        ;      dx = Altura
        ;      ax = Cores: 2=MDA | 16=Colorido
    dw 0
    .SegVideo: dw 0,0

ObjVideoTexto:
    .Largura: equ 0
    .Altura: equ 2
    .PtrAtualiza: equ 4
    .LinhasAlteradas: equ 8
    ._CapacidadeLinhasAlteradas: equ 60
    .UltimaLinhaAlterada: equ .LinhasAlteradas + (._CapacidadeLinhasAlteradas * 4)
    .Simultaneos: equ .UltimaLinhaAlterada + 2
    .CursorTeclado: equ .Simultaneos + 2
    .CursorMouse: equ .CursorTeclado + 2
    .ExibeCursorTeclado: equ .CursorMouse + 2
    .ExibeCursorMouse: equ .ExibeCursorTeclado + 2
    .Cores: equ .ExibeCursorMouse + 2
    .UsoInterno: equ .Cores + 2
    ._CapacidadeUsoInterno: equ 16
    .Dados: equ .UsoInterno + ._CapacidadeUsoInterno
    ._Tam: equ .Dados

; ret: es:0 = ObjVideoTexto
__videotextoCarregaPonteiro:
    push ax
    cs mov ax, [VideoTexto.SegVideo]
    cmp ax, 0
    jne .ok
        clc
        jmp .fim
    .ok:
    mov es, ax
    stc
    .fim:
    pop ax
    ret

; es = ObjVideoTexto
__videotextoTrava:
    pushf
    cli
    es cmp byte [ObjVideoTexto.Simultaneos], 0
    je .fim
        popf
        cs call far [HUSIS.ProximaTarefa]
        jmp __videotextoTrava
    .fim:
    es mov byte [ObjVideoTexto.Simultaneos], 1
    popf
    ret

; es = ObjVideoTexto
__videotextoLiberaTrava:
    es mov byte [ObjVideoTexto.Simultaneos], 0
    ret

; bx = Linha alterada
; es:0 = ObjVideoTexto
__videotextoMarcarLinhaAlterada:
    push ax
    push bx
    push cx
    push dx
    push si
    call __videotextoTrava
    mov si, ObjVideoTexto.LinhasAlteradas
    es mov cx, [ObjVideoTexto.UltimaLinhaAlterada]
    .pesquisa:
        es cmp [si], bx
        je .fim
        add si, 4
        loop .pesquisa
    es mov si, [ObjVideoTexto.UltimaLinhaAlterada]
    shl si, 1
    shl si, 1
    add si, ObjVideoTexto.LinhasAlteradas
    es mov ax, [ObjVideoTexto.Largura]
    shl ax, 1
    mul bx
    es mov [si], bx
    es mov [si+2], ax
    es inc word [ObjVideoTexto.UltimaLinhaAlterada]
    .fim:
    call __videotextoLiberaTrava
    stc
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; ax = X
; bx = Y
; es:0 = ObjVideoTexto
; ret: di = Ponteiro
__videotextoPonteiroDados:
    push ax
    push bx
    push cx
    push dx
    shl ax, 1
    xchg ax, bx
    es mov cx, [ObjVideoTexto.Largura]
    shl cx, 1
    mul cx
    add ax, bx
    add ax, ObjVideoTexto.Dados
    mov di, ax
    stc
    pop dx
    pop cx
    pop bx
    pop ax
    ret

_videotexto:
    push si
    push di
    mov si, Prog.Argumentos
    mov di, .constCGA
    cs call far [Texto.IgualLocalLocal]
    jc .cga
    mov di, .constEGA
    cs call far [Texto.IgualLocalLocal]
    jc .ega
    mov di, .constVGA
    cs call far [Texto.IgualLocalLocal]
    jc .ega
    ; Padrao CGA
    .cga:
        call __videotextoCGA
        jmp .fim
    .ega:
        call __videotextoEGA
        jmp .fim
    .vga:
        call __videotextoVGA
    .fim:
    pop di
    pop si
    retf
    .constCGA: db 'CGA',0
    .constEGA: db 'EGA',0
    .constVGA: db 'VGA',0

_videotextoAtualiza:
    push es
    push ax
    call __videotextoCarregaPonteiro
    es cmp word [ObjVideoTexto.PtrAtualiza + 2], 0
    jne .ok
        clc
        jmp .fim
    .ok:
    call __videotextoTrava
    es call far [ObjVideoTexto.PtrAtualiza]
    call __videotextoLiberaTrava
    stc
    .fim:
    pop ax
    pop es
    retf

_videotextoLimpaTela:
    push es
    push di
    push ax
    push bx
    push cx
    push dx
    call __videotextoCarregaPonteiro
    es mov dx, [ObjVideoTexto.Largura]
    es mov cx, [ObjVideoTexto.Altura]
    xor bx, bx
    mov ax, di
    xchg al, ah
    mov di, ObjVideoTexto.Dados
    .limpa:
        push cx
        mov cx, dx
        mov al, ' '
        rep stosw
        call __videotextoMarcarLinhaAlterada
        pop cx
        inc bx
        loop .limpa
    stc
    pop dx
    pop cx
    pop bx
    pop ax
    pop di
    pop es
    retf

; ax = X1
; bx = Y1
; cx = X2
; dx = Y2
; ds:si = Texto
; di = Cor unificada
_videotextoTexto:
    push ax
    push bx
    push cx
    push dx
    push es
    push di
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
    .varCor: equ -10
    call __videotextoCarregaPonteiro
    call __videotextoPonteiroDados
    jnc .fim
    call __videotextoMarcarLinhaAlterada
    .escreva:
        cmp ax, [bp+.varX2]
        jbe .xOk
            mov ax, [bp+.varX1]
            inc bx
            call __videotextoMarcarLinhaAlterada
            call __videotextoPonteiroDados
            jnc .fim
        .xOk:
        cmp bx, [bp+.varY2]
        ja .ok
        push ax
        push bx
        lodsb
        cmp al, 0
        jne .caractereOk
            pop bx
            pop ax
            jmp .ok
        .caractereOk:
        mov ah, [bp+.varCor]
        stosw
        pop bx
        pop ax
        inc ax
        jmp .escreva
    .ok:
    stc
    .fim:
    mov sp, bp
    pop bp
    pop si
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    retf

; dl = Caractere
; cx = Quantidade
; ax = X
; bx = Y
; di = Cor unificada
_videotextoRepete:
    push es
    push di
    push si
    push ax
    push bx
    push cx
    push dx
    mov si, di
    call __videotextoCarregaPonteiro
    jnc .fim
    call __videotextoMarcarLinhaAlterada
    call __videotextoPonteiroDados
    jnc .fim
    mov ax, si
    mov ah, dl
    xchg al, ah
    rep stosw
    stc
    .fim:
    pop dx
    pop cx
    pop bx
    pop ax
    pop si
    pop di
    pop es
    retf

; ax = X1
; bx = Y1
; cx = X2
; dx = Y2
; di = Cor unificada
_videotextoLimpa:
    push es
    push di
    push si
    push ax
    push bx
    push cx
    push dx
    mov si, di
    call __videotextoCarregaPonteiro
    sub dx, bx
    inc dx
    sub cx, ax
    inc cx
    xchg cx, dx
    push dx
    push cx
    push ax
    es mov ax, [ObjVideoTexto.Largura]
    mul bx
    shl ax, 1
    mov di, ax
    pop ax
    shl ax, 1
    add di, ax
    pop cx
    pop dx
    add di, ObjVideoTexto.Dados
    .limpa:
        push di
        push cx
        mov cx, dx
        mov ax, si
        xchg ah, al
        mov al, ' '
        rep stosw
        call __videotextoMarcarLinhaAlterada
        pop cx
        pop di
        es mov ax, [ObjVideoTexto.Largura]
        shl ax, 1
        add di, ax
        inc bx
        loop .limpa
    stc
    pop dx
    pop cx
    pop bx
    pop ax
    pop si
    pop di
    pop es
    retf

; ax = X1
; bx = Y1
; cx = X2
; dx = Y2
; di = Cor unificada
_videotextoBorda:
    push es
    push di
    push si
    push ax
    push bx
    push cx
    push dx
    mov si, di
    sub cx, ax
    dec cx
    sub dx, bx
    dec dx
    xchg cx, dx
    call __videotextoCarregaPonteiro
    ; Linha superior
    call __videotextoMarcarLinhaAlterada
    call __videotextoPonteiroDados
    push ax
    push bx
    push cx
    push dx
    push di
    push dx
    mov cx, 1
    mov di, si
    mov dl, 218
    cs call far [VideoTexto.Repete]
    pop dx
    push dx
    inc ax
    mov cx, dx
    mov di, si
    mov dl, 196
    cs call far [VideoTexto.Repete]
    pop dx
    add ax, dx
    mov cx, 1
    mov di, si
    mov dl, 191
    cs call far [VideoTexto.Repete]
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    inc bx
    ; Centro
    .vert:
        call __videotextoMarcarLinhaAlterada
        call __videotextoPonteiroDados
        push ax
        push bx
        push cx
        push dx
        push di
        mov cx, 1
        mov di, si
        push dx
        mov dl, 179
        cs call far [VideoTexto.Repete]
        pop dx
        add ax, dx
        inc ax
        mov dl, 179
        cs call far [VideoTexto.Repete]
        pop di
        pop dx
        pop cx
        pop bx
        pop ax
        inc bx
        loop .vert
    ; Linha Inferior
    call __videotextoMarcarLinhaAlterada
    call __videotextoPonteiroDados
    push ax
    push bx
    push cx
    push dx
    push di
    push dx
    mov cx, 1
    mov di, si
    mov dl, 192
    cs call far [VideoTexto.Repete]
    pop dx
    push dx
    inc ax
    mov cx, dx
    mov di, si
    mov dl, 196
    cs call far [VideoTexto.Repete]
    pop dx
    add ax, dx
    mov cx, 1
    mov di, si
    mov dl, 217
    cs call far [VideoTexto.Repete]
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    .fim:
    pop dx
    pop cx
    pop bx
    pop ax
    pop si
    pop di
    pop es
    retf

; dl = Caractere
; ax = X
; bx = Y
; di = Cor unificada
_videotextoCaractere:
    push es
    push di
    push si
    push ax
    push bx
    push cx
    push dx
    mov si, di
    call __videotextoCarregaPonteiro
    jnc .fim
    call __videotextoMarcarLinhaAlterada
    call __videotextoPonteiroDados
    jnc .fim
    mov ax, si
    mov ah, dl
    xchg al, ah
    stosw
    stc
    .fim:
    pop dx
    pop cx
    pop bx
    pop ax
    pop si
    pop di
    pop es
    retf

; ax = X1
; bx = Y1
; cx = X2
; dx = Y2
; si = Caractere
; di = Cor unificada
_videotextoPreenche:
    push es
    push di
    push si
    push ax
    push bx
    push cx
    push dx
    call __interfaceShl8DI
    and si, 0xff
    or si, di
    call __videotextoCarregaPonteiro
    sub dx, bx
    inc dx
    sub cx, ax
    inc cx
    xchg cx, dx
    push dx
    push cx
    push ax
    es mov ax, [ObjVideoTexto.Largura]
    mul bx
    shl ax, 1
    mov di, ax
    pop ax
    shl ax, 1
    add di, ax
    pop cx
    pop dx
    add di, ObjVideoTexto.Dados
    .limpa:
        push di
        push cx
        mov cx, dx
        mov ax, si
        rep stosw
        call __videotextoMarcarLinhaAlterada
        pop cx
        pop di
        es mov ax, [ObjVideoTexto.Largura]
        shl ax, 1
        add di, ax
        inc bx
        loop .limpa
    stc
    pop dx
    pop cx
    pop bx
    pop ax
    pop si
    pop di
    pop es
    retf

; si = Caractere
; di = Cor unificada
_videotextoPreencheTela:
    push es
    push di
    push si
    push ax
    push bx
    push cx
    push dx
    
    push si
    push di
    call __videotextoCarregaPonteiro
    xor ax, ax
    xor bx, bx
    es mov cx, [ObjVideoTexto.Largura]
    dec cx
    es mov dx, [ObjVideoTexto.Altura]
    dec dx
    pop di
    pop si
    cs call far [VideoTexto.Preenche]
    
    pop dx
    pop cx
    pop bx
    pop ax
    pop si
    pop di
    pop es
    retf

_videotextoInfo:
    push es
    call __videotextoCarregaPonteiro
    es mov ax, [ObjVideoTexto.Cores]
    es mov cx, [ObjVideoTexto.Largura]
    es mov dx, [ObjVideoTexto.Altura]
    pop es
    retf