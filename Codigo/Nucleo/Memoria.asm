; ========================
;  Gerenciador de Memoria
; ========================
;
; Prototipo........: 17/08/2022
; Versao Inicial...: 18/08/2022
; Autor............: Humberto Costa dos Santos Junior
;
; Funcao...........: Gerencia a Memoria separando em blocos
;
; Limitacoes.......: Aloca multiplos de 256 bytes, podendo alocar até 64 KiB por conjunto
;
; Historico........:
;
; - 17/08/2022 - Humberto - Prototipo inicial
; - 18/08/2022 - Humberto - Implementacao do mapa e mecanismo de alocacao de memoria

Memoria: dw _memoria, 0
    .AlocaBloco: dw _memoriaAlocaBloco, 0
    .LiberaBloco: dw _memoriaLiberaBloco, 0
    .Aloca: dw _memoriaAloca, 0
    .Libera: dw _memoriaLibera, 0
    .Calcula: dw _memoriaCalcula, 0
    .CalculaLivre: dw _memoriaCalculaLivre, 0
    dw 0
    .Mapa: dw 0
    .InicioLivre: dw 0
    .TotalBlocos: dw 0
    .InicioNucleo: dw 0

_memoria:
    push es
    push di
    push ax
    push bx
    push cx
    push dx
    ; Grava o numero do processo do nucleo
    cs mov word [Prog.Processo], 0xfe
    ; Grava o inicio do nucleo
    mov ax, cs
    cs mov [Memoria.InicioNucleo], ax
    ; Calcula o tamanho do nucleo em segmentos
    cs mov bx, [Prog.Tamanho]
    shr bx, 1
    shr bx, 1
    shr bx, 1
    shr bx, 1
    ; Calcula o final do binario do nucleo/Inicio do mapa
    mov ax, cs
    add ax, bx
    ; Grava o inicio do mapa (Segmento)
    cs mov [Memoria.Mapa], ax
    ; Carrega o segmento
    mov es, ax
    xor ax, ax
    int 0x12
    ; Converte KiB em Blocos de 256 (640 KiB*4=2560 Blocos)
    shl ax, 1
    shl ax, 1
    cs mov [Memoria.TotalBlocos], ax
    ; Converte Blocos(256B) em Tamanho ocupado pelo mapa em Segmentos (16B)
    ; (2560 Blocos / 8=320 Segmentos de Mapa)
    shr ax, 1
    shr ax, 1
    shr ax, 1
    ; Calcula o Inicio da Memoria Livre apos o mapa
    cs add ax, [Memoria.Mapa]
    ; Adiciona um segmento apos o fim do mapa por seguranca
    inc ax
    cs mov [Memoria.InicioLivre], ax

    ; Preenche mapa com areas vazias, reservadas e nucleo

    ; Define tamanho do mapa que deve ser preenchido
    cs mov cx, [Memoria.TotalBlocos]
    ; Posicao no mapa (binaria)
    xor di, di
    ; Posicao no mapa (logica / contador)
    xor dx, dx
    .preencheMapa:
        cmp dx, 0x6000 / 256
        jb .reservado
        cs mov ax, [Memoria.InicioNucleo]
        shr ax, 1
        shr ax, 1
        shr ax, 1
        shr ax, 1
        cmp dx, ax
        jb .vazio
        cs mov ax, [Memoria.InicioLivre]
        shr ax, 1
        shr ax, 1
        shr ax, 1
        shr ax, 1
        cmp dx, ax
        ja .vazio
        ; Processo 0xfe (Nucleo), Posicao 0xff (Final)
        mov ax, 0xfffe
        stosw
        jmp .proxPreenche
        .reservado:
            ; Processo 0xff (BIOS), Posicao 0xff (Final)
            mov ax, 0xffff
            stosw
            jmp .proxPreenche
        .vazio:
            ; Processo 0x0 (Livre), Posicao 0x0 (Inicial)
            xor ax, ax
            stosw
            jmp .proxPreenche
        .proxPreenche:
        inc dx
        loop .preencheMapa
    pop dx
    pop cx
    pop bx
    pop ax
    pop di
    pop es
    retf

; Calcula o espaco livre
; ret: bx = Total em Blocos de 256 Bytes
;      dx = Total em Segmentos de 16 Bytes
;      ax = Total em KiB
_memoriaCalculaLivre:
    push ds
    push si
    push cx
    push word [Memoria.Mapa]
    pop ds
    cs mov cx, [Memoria.TotalBlocos]
    xor bx, bx
    xor si, si
    .calcula:
        lodsw
        cmp ax, 0
        jne .continua
            inc bx
        .continua:
        loop .calcula
    mov dx, bx
    shl dx, 1
    shl dx, 1
    shl dx, 1
    shl dx, 1
    mov ax, bx
    shr ax, 1
    shr ax, 1
    pop cx
    pop si
    pop ds
    retf


; Calcula memoria de um processo
; al = Processo
; ret: bx = Total em Blocos de 256 Bytes
;      dx = Total em Segmentos de 16 Bytes
;      ax = Total em KiB
_memoriaCalcula:
    push ds
    push si
    push cx
    push word [Memoria.Mapa]
    pop ds
    mov dl, al
    cs mov cx, [Memoria.TotalBlocos]
    xor bx, bx
    xor si, si
    .calcula:
        lodsw
        cmp al, dl
        jne .continua
            inc bx
        .continua:
        loop .calcula
    mov dx, bx
    shl dx, 1
    shl dx, 1
    shl dx, 1
    shl dx, 1
    mov ax, bx
    shr ax, 1
    shr ax, 1
    pop cx
    pop si
    pop ds
    retf

; Aloca um espaco na memoria
; al = Processo
; cx = Espaco em Blocos de 256 Bytes
; ret: cf = 1=Ok | 0=Sem espaco livre OU Processo invalido
;      es = Segmento alocado
;      di = 0
_memoriaAlocaBloco:
    push si
    push ds
    push ax
    push bx
    push cx
    push dx
    push bp
    mov bp, sp
    xor ah, ah
    push ax
    .varProcesso: equ -2
    push cx
    .varQtdNecessario: equ -4
    xor ax, ax
    push ax
    .varEndereco: equ -6
    push ax
    .varEnderecoSI: equ -8

    push word [Memoria.Mapa]
    pop ds
    cs mov cx, [Memoria.TotalBlocos]
    xor bx, bx
    xor si, si
    xor dx, dx
    .busca:
        lodsw
        cmp ax, 0
        jne .preenchido
            cmp bx, 0
            jne .jaIniciado
                mov [bp+.varEndereco], dx
                mov [bp+.varEnderecoSI], si
                sub word [bp+.varEnderecoSI], 2
            .jaIniciado:
            inc bx
            cmp bx, [bp+.varQtdNecessario]
            jae .encontrado
            jmp .continua
        .encontrado:
            ; Limpa conteudo do destino
            mov ax, [bp+.varQtdNecessario]
            cmp ax, 256
            jne .calcula
                mov cx, 0xffff
                jmp .fimCalculo
            .calcula:
                mov cx, 256
                mul cx
                mov cx, ax
            .fimCalculo:
            mov ax, [bp+.varEndereco]
            mov es, ax
            xor di, di
            rep stosb
            ; Registra espaco ocupado
            push ds
            pop es
            mov di, [bp+.varEnderecoSI]
            mov cx, [bp+.varQtdNecessario]
            mov ax, [bp+.varProcesso]
            .registrar:
                stosw
                inc ah
                loop .registrar
            mov ax, [bp+.varEndereco]
            mov es, ax
            xor di, di
            stc
            jmp .fim
        .preenchido:
            mov word [bp+.varEndereco], 0
            mov word [bp+.varEnderecoSI], 0
            xor bx, bx
        .continua:
        add dx, 16
        loop .busca
    clc
    .fim:
    mov sp, bp
    pop bp
    pop dx
    pop cx
    pop bx
    pop ax
    pop ds
    pop si
    retf

; Libera um espaco na memoria anteriormente alocado
; al = Processo
; es = Segmento alocado
; ret: cf = 1=Ok | 0=Parametro invalido
_memoriaLiberaBloco:
    push es
    push di
    push ax
    push cx
    push dx
    mov dx, ax
    xor dh, dh
    mov ax, es
    shr ax, 1
    shr ax, 1
    shr ax, 1
    shr ax, 1
    shl ax, 1
    mov di, ax
    cs push word [Memoria.Mapa]
    pop es
    xor cx, cx
    .libera:
        es cmp [di], dx
        jne .encerra
        es mov word [di], 0
        inc dh
        inc di
        inc di
        inc cx
        jmp .libera
    .encerra:
        cmp cx, 0
        jne .ok
        clc
        jmp .fim
    .ok:
        stc
    .fim:
    pop dx
    pop cx
    pop ax
    pop di
    pop es
    retf

; Aloca um espaco na memoria (Sera alocado conjuntos de 256 Bytes)
; al = Processo
; cx = Espaco em bytes
; ret: cf = 1=Ok | 0=Sem espaco livre OU Processo invalido
;      es = Segmento alocado
;      di = 0
_memoriaAloca:
    push cx
    ; Converte Bytes em Blocos
    ; (256 / 256 = 1)
    ; (257 / 256 = 1 + 1(Bloco parcial))
    xchg cl, ch
    ; Inverte byte alto com byte baixo (Dividindo por 256 mantendo resto em ch)
    ; Verifica se o resto eh diferente de zero
    cmp ch, 0
    je .naoIncrementa
        ; sendo diferente de zero, incrementa um bloco pois eh parcial
        inc cl
    .naoIncrementa:
    ; Limpa resto mantendo apenas o tamanho em blocos
    xor ch, ch
    ; Usando a quantidade em blocos, chama a rotina de alocar blocos
    cs call far [Memoria.AlocaBloco]
    pop cx
    retf;

; Libera um espaco na memoria anteriormente alocado
; al = Processo
; es = Segmento alocado
; ret: cf = 1=Ok | 0=Parametro invalido
_memoriaLibera:
    ; O algoritmo eh o mesmo que LiberaBloco
    cs call far [Memoria.LiberaBloco]
    retf