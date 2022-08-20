; ======================
;  Controlador de Disco
; ======================
;
; Prototipo........: 17/08/2022
; Versao Inicial...: 17/08/2022
; Autor............: Humberto Costa dos Santos Junior
;
; Funcao...........: Controla os discos do computador
;
; Limitacoes.......: 
;
; Historico........:
;
; - 17/08/2022 - Humberto - Prototipo inicial

ObjDisco:
    .Id: equ 0
    .Cilindros: equ 2
    .Cabecas: equ 4
    .Setores: equ 6
    .CabecasSetores: equ 8
    .Removivel: equ 10
    ._Tam: equ 12

Disco: dw _disco, 0
    .Leia512: dw _discoLeia512, 0
    .Escreva512: dw _discoEscreva512, 0
    .Info: dw _discoInfo, 0
    .BuscaPorId: dw _discoBuscaPorId, 0
    dw 0
    ._Capacidade: equ 6
    .Dados: times (._Capacidade * ObjDisco._Tam) db 0xff
    .Debug: dw 1

_disco:
    push si
    push bx
    mov si, Disco.Dados
    xor bx, bx
    cs mov word [si+bx+ObjDisco.Id], 0
    cs mov word [si+bx+ObjDisco.Cilindros], 80
    cs mov word [si+bx+ObjDisco.Cabecas], 2
    cs mov word [si+bx+ObjDisco.Setores], 18
    cs mov word [si+bx+ObjDisco.CabecasSetores], 36
    cs mov word [si+bx+ObjDisco.Removivel], 1
    add bx, ObjDisco._Tam
    cs mov word [si+bx+ObjDisco.Id], 1
    cs mov word [si+bx+ObjDisco.Cilindros], 80
    cs mov word [si+bx+ObjDisco.Cabecas], 2
    cs mov word [si+bx+ObjDisco.Setores], 18
    cs mov word [si+bx+ObjDisco.CabecasSetores], 36
    cs mov word [si+bx+ObjDisco.Removivel], 1
    pop bx
    pop si
    retf


; Le informacoes de um disco
; bx = Disco
; ret: cf = 1=Encontrado | 0=Nao encontrado
;      ax = Cabecas * Setores
;      cx = Cilindros
;      dh = Cabecas
;      dl = Setores
;      bx = Disco
_discoInfo:
    push si
    push bx
    mov si, Disco.Dados
    mov ax, ObjDisco._Tam
    mul bx
    mov bx, ax
    mov ax, [si+bx+ObjDisco.CabecasSetores]
    mov cx, [si+bx+ObjDisco.Cilindros]
    mov dh, [si+bx+ObjDisco.Cabecas]
    mov dl, [si+bx+ObjDisco.Setores]
    pop bx
    cmp bx, 0xffff
    jne .ok
        clc
        jmp .fim
    .ok:
        stc
    .fim:
    pop si
    retf

; Busca um Disco usando o Id
; bx = Id
; ret: cf = 1=Encontrado | 0=Nao encontrado
;      ax = Cabecas * Setores
;      cx = Cilindros
;      dh = Cabecas
;      dl = Setores
;      bx = Disco
_discoBuscaPorId:
    push si
    mov si, Disco.Dados
    mov ax, bx
    xor bx, bx
    mov cx, Disco._Capacidade
    mov dx, 0
    .pesquisa:
        cmp [si+bx+ObjDisco.Id], ax
        je .ok
        add bx, ObjDisco._Tam
        inc dx
        loop .pesquisa
    .falha:
        clc
        jmp .fim
    .ok:
        mov bx, dx
        cs call far [Disco.Info]
    .fim:
    pop si
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

; Le um bloco de um disco
; dx:ax = Endereco em blocos de 512 bytes
; bx = Disco
; es:di = Destino
; ret: cf = 1=Lido | 0=Erro
_discoLeia512:
    push ax
    push bx
    push cx
    push dx
    push di
    push bp
    mov bp, sp
    push ax
    push dx
    .varEndereco: equ -4
    push ax
    .varCilindro: equ -6
    push ax
    .varCabeca: equ -8
    push ax
    .varSetor: equ -10
    push bx
    .varDisco: equ -12
    push di
    .varDestino: equ -14
    push ax
    .varFalhas: equ -16
    push ax
    .varQtdCilindros: equ -18
    push ax
    .varQtdCabecas: equ -20
    push ax
    .varQtdSetores: equ -22
    push ax
    .varQtdCabSet: equ -24
    mov word [bp+.varFalhas], 3
    ; Busca o ID do disco
    push dx
    push ax
    push bx
    push cx
    mov bx, [bp+.varDisco]
    cs call far [Disco.Info]
    jc .discoExiste
        pop cx
        pop bx
        pop ax
        pop dx
        jmp .falha
    .discoExiste:
    mov [bp+.varDisco], bx
    mov [bp+.varQtdCilindros], cx
    push dx
    xor dh, dh
    mov [bp+.varQtdSetores], dx
    pop dx
    xchg dl, dh
    xor dh, dh
    mov [bp+.varQtdCabecas], dx
    mov [bp+.varQtdCabSet], ax
    pop cx
    pop bx
    pop ax
    pop dx
;cs call far [Terminal.EscrevaDebugPilha]
    ; Calculo do endereço
    div word [bp+.varQtdCabSet]
    mov [bp+.varCilindro], ax
    xchg ax, dx
    xor dx, dx
    div word [bp+.varQtdSetores]
    mov [bp+.varCabeca], ax
    inc dx
    mov [bp+.varSetor], dx
    ; Montando comando bios
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
            dec word [bp+.varFalhas]
            cmp word [bp+.varFalhas], 0
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
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    retf


; Escreve um bloco de um disco
; dx:ax = Endereco em blocos de 512 bytes
; bx = Disco
; es:di = Origem
; ret: cf = 1=Lido | 0=Erro
_discoEscreva512:
    push ax
    push bx
    push cx
    push dx
    push di
    push bp
    mov bp, sp
    push ax
    push dx
    .varEndereco: equ -4
    push ax
    .varCilindro: equ -6
    push ax
    .varCabeca: equ -8
    push ax
    .varSetor: equ -10
    push bx
    .varDisco: equ -12
    push di
    .varDestino: equ -14
    push ax
    .varFalhas: equ -16
    push ax
    .varQtdCilindros: equ -18
    push ax
    .varQtdCabecas: equ -20
    push ax
    .varQtdSetores: equ -22
    push ax
    .varQtdCabSet: equ -24
    mov word [bp+.varFalhas], 3
    ; Busca o ID do disco
    push dx
    push ax
    push bx
    push cx
    mov bx, [bp+.varDisco]
    cs call far [Disco.Info]
    jc .discoExiste
        pop cx
        pop bx
        pop ax
        pop dx
        jmp .falha
    .discoExiste:
    mov [bp+.varDisco], bx
    mov [bp+.varQtdCilindros], cx
    push dx
    xor dh, dh
    mov [bp+.varQtdSetores], dx
    pop dx
    xchg dl, dh
    xor dh, dh
    mov [bp+.varQtdCabecas], dx
    mov [bp+.varQtdCabSet], ax
    pop cx
    pop bx
    pop ax
    pop dx
    ; Calculo do endereço
    div word [bp+.varQtdCabSet]
    mov [bp+.varCilindro], ax
    xchg ax, dx
    xor dx, dx
    div word [bp+.varQtdSetores]
    mov [bp+.varCabeca], ax
    inc dx
    mov [bp+.varSetor], dx
    ; Montando comando bios
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
        mov ax, 0x301
        push bp
        int 0x13
        pop bp
        jnc .ok
            dec word [bp+.varFalhas]
            cmp word [bp+.varFalhas], 0
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
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    retf