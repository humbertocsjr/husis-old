; =========
;  MinixFS
; =========
;
; Prototipo........: 21/08/2022
; Versao Inicial...: 21/08/2022
; Autor............: Humberto Costa dos Santos Junior
;
; Funcao...........: Implementa o MinixFS
;
; Limitacoes.......: 
;
; Historico........:
;
; - 21/08/2022 - Humberto - Prototipo inicial

ObjMinixFSIndice:
    .QtdItens: equ 0
    ; 1.44: 32
    .QtdBlocos: equ 0x2
    ; 1.44: 1440
    .BlocosMapaItens: equ 0x4
    ; 1.44: 1
    .BlocosMapaBlocos: equ 0x6
    ; 1.44: 1
    .PrimeiroBloco: equ 0x8
    ; 1.44: 5 (Posicao 0x1400)
    .TamanhoBloco: equ 0xa
    ; 1.44: 0
    .TamanhoMaxArq: equ 0xc
    ; 1.44: 268.966.912
    .Assinatura: equ 0x10
    ; 1.44: 0x7f13
    .EstadoMontagem: equ 0x12
    ; 1.44: 1

ObjMinixFSItem:
    .Modo: equ 0x0
    .UsuarioCod: equ 0x2
    .Tamanho: equ 0x4
    .DataHora: equ 0x8
    .GrupoCod: equ 0xc
    .Ligacoes: equ 0xd
    .Zonas: equ 0xe
    ._QtdZonas: equ 7
    .ZonaIndireta: equ 0x1c
    .ZonaDuplaIndireta: equ 0x1e
    ._Tam: equ 32
    ._QtdPorBloco: equ 32

ObjSisArqMinixFS:
    .BlocoBuffer: equ ObjSisArq._Tam
    .Buffer: equ .BlocoBuffer + 2
    .PosNoBuffer: equ .Buffer + 1024
    .PosNoItem: equ .PosNoBuffer + 2
    ._Tam: equ .PosNoItem + 2

ObjSisArqMinixFSRaiz:
    .Itens: equ ObjSisArqMinixFS._Tam
    .BlocoItens: equ .Itens + 1024
    .InicioMapaBlocos: equ .BlocoItens + 2
    .FimMapaBlocos: equ .InicioMapaBlocos + 2
    .InicioMapaItens: equ .FimMapaBlocos + 2
    .FimMapaItens: equ .InicioMapaItens + 2
    .CapacidadeItens: equ .FimMapaItens + 2
    .InicioItens: equ .CapacidadeItens + 2
    .FimItens: equ .InicioItens + 2
    .Contador: equ .FimItens + 2
    ._Tam: equ .Contador + 2
    

MinixFS: dw _minixfs,0
    .Verifica: dw _minixfsVerifica, 0
        ; Verifica uma unidade
        ; bx = Unidae
        ; ret: cf = 1=Ok | 0=Falha
    .Monta: dw _minixfsMonta, 0
        ; Monta uma unidade
        ; bx = Unidae
        ; ret: cf = 1=Ok | 0=Falha
    dw 0
    .Debug: dw 0
    .Trava: dw 0

_minixfs:
    cs mov word [MinixFS.Trava], 0
    retf

__minixfsTravaMultitarefa:
    pushf
    cli
    cs inc word [MinixFS.Trava]
    .aguarda:
        cs cmp word [MinixFS.Trava], 1
        je .fim
            hlt
            jmp .aguarda
    .fim:
    popf
    ret

__minixfsLiberaMultitarefa:
    pushf
    cs cmp word [MinixFS.Trava], 0
    je .fim
        cs dec word [MinixFS.Trava]
    .fim:
    popf
    ret

; ax = Bloco
; ds:si = ObjSisArqMinixFSRaiz
; ret: cf = 1=Ok | 0=Falha ao ler
__minixfsCarregaItensLocal:
    push dx
    push si
    push bx
    push ax
    ds add ax, [si+ObjSisArqMinixFSRaiz.InicioItens]
    ds cmp ax, [si+ObjSisArqMinixFSRaiz.BlocoItens]
    jne .leia
        stc
        jmp .fim
    .leia:
    cs cmp word [MinixFS.Debug], 0
    je .ignoraDebug
        cs call far [Terminal.Escreva]
        db '[ ITENS: %Lh:%an ]',0
    .ignoraDebug:
    xor dx, dx
    ds mov bx, [si+ObjSisArq.Unidade]
    push si
    add si, ObjSisArqMinixFSRaiz.Itens
    cs call far [Unidade.LeiaLocal]
    pop si
    jnc .fim
    ds mov [si+ObjSisArqMinixFSRaiz.BlocoItens], ax
    stc
    .fim:
    pop ax
    pop bx
    pop si
    pop dx
    ret

; ax = Bloco
; es:di = ObjSisArqMinixFS
; ret: cf = 1=Ok | 0=Falha ao ler
__minixfsCarregaBufferRemoto:
    push dx
    push bx
    es cmp ax, [di+ObjSisArqMinixFS.BlocoBuffer]
    jne .leia
        stc
        jmp .fim
    .leia:
    push ax
    cs cmp word [MinixFS.Debug], 0
    je .ignoraDebug
        cs call far [Terminal.Escreva]
        db '[ BUFFER R: %Rh:%an ]',0
    .ignoraDebug:
    xor dx, dx
    es mov bx, [di+ObjSisArq.Unidade]
    push di
    add di, ObjSisArqMinixFS.Buffer
    cs call far [Unidade.LeiaRemoto]
    pop di
    pop ax
    jnc .fim
    es mov [di+ObjSisArqMinixFS.BlocoBuffer], ax
    stc
    .fim:
    pop bx
    pop dx
    ret

; ax = Bloco
; ds:si = ObjSisArqMinixFS
; ret: cf = 1=Ok | 0=Falha ao ler
__minixfsCarregaBufferLocal:
    push dx
    push bx
    ds cmp ax, [si+ObjSisArqMinixFS.BlocoBuffer]
    jne .leia
        stc
        jmp .fim
    .leia:
    push ax
    cs cmp word [MinixFS.Debug], 0
    je .ignoraDebug
        cs call far [Terminal.Escreva]
        db '[ BUFFER L: %Lh:%an ]',0
    .ignoraDebug:
    xor dx, dx
    ds mov bx, [si+ObjSisArq.Unidade]
    push si
    add si, ObjSisArqMinixFS.Buffer
    cs call far [Unidade.LeiaLocal]
    pop si
    pop ax
    jnc .fim
    ds mov [si+ObjSisArqMinixFS.BlocoBuffer], ax
    stc
    .fim:
    pop bx
    pop dx
    ret

; es:di = ObjSisArqMinixFS
; cx = Posicao
; ret: cf = 1=Ok | 0=Falha ao ler
__minixfsCarregaDoItemRemoto:
    push es
    push di
    push ds
    push si
    push ax
    push bx
    push dx
    push cx
    ; Coloca raiz em local
    es mov ax, [di+ObjSisArq.Raiz]
    mov ds, ax
    xor si, si
    ; Carrega lista de itens em local
    es mov ax, [di+ObjSisArq.Id]
    dec ax
    mov bx, 32
    xor dx, dx
    div bx
    call __minixfsCarregaItensLocal
    mov ax, dx
    mov bx, 32
    mul bx
    cmp cx, 7
    jae .blocoIndireto
        add si, ObjSisArqMinixFSRaiz.Itens
        mov bx, cx
        shl bx, 1
        add bx, ax
        ds mov ax, [si+bx+ObjMinixFSItem.Zonas]
        cmp ax, 0
        je .falha
        call __minixfsCarregaBufferRemoto
        jmp .fim
    .blocoIndireto:
        cmp cx, 7+256
        jae .blocoDuploIndireto
        push si
        add si, ObjSisArqMinixFSRaiz.Itens
        mov bx, cx
        shl bx, 1
        add bx, ax
        ds mov ax, [si+bx+ObjMinixFSItem.Zonas]
        cs cmp word [MinixFS.Debug], 0
        je .ignoraDebug
            cs call far [Terminal.Escreva]
            db '[ INDIRETA: %Lh:%an POS: %cn ]',0
        .ignoraDebug:
        pop si
        cmp ax, 0
        je .falha
        call __minixfsCarregaBufferLocal
        add si, ObjSisArqMinixFS.Buffer
        mov bx, cx
        sub bx, 7
        shl bx, 1
        ds mov ax, [si+bx]
        cmp ax, 0
        je .falha
        call __minixfsCarregaBufferRemoto
        jmp .fim
    .blocoDuploIndireto:
    .falha:
        clc
    .fim:
    pop cx
    pop dx
    pop bx
    pop ax
    pop si
    pop ds
    pop di
    pop es
    ret

; Verifica uma unidade
; bx = Unidae
; ret: cf = 1=Ok | 0=Falha
_minixfsVerifica:
    push ds
    push si
    push ax
    push bx
    push dx
    push cx
    cs mov al, [Prog.Processo]
    mov cx, 1024
    cs call far [Memoria.AlocaLocal]
    jnc .fim
    xor si, si
    xor dx, dx
    mov ax, 1
    cs call far [Unidade.LeiaLocal]
    ds mov ax, [si+ObjMinixFSIndice.Assinatura]
    cmp ax, 0x138f
    je .ok
        cs call far [Memoria.LiberaLocal]
        clc
        jmp .fim
    .ok:
        cs call far [Memoria.LiberaLocal]
        stc
    .fim:
    pop cx
    pop dx
    pop bx
    pop ax
    pop si
    pop ds
    retf

; Monta uma unidade
; bx = Unidae
; ret: cf = 1=Ok | 0=Falha
_minixfsMonta:
    push es
    push di
    push ds
    push si
    push ax
    push bx
    push dx
    push cx
    cs call far [MinixFS.Verifica]
    jnc .fim
    cs mov al, [Prog.Processo]
    mov cx, ObjSisArqMinixFSRaiz._Tam
    cs call far [Memoria.AlocaRemoto]
    jnc .fim
    cs call far [Unidade.BuscaLocal]
    es mov word [ObjSisArqMinixFS.BlocoBuffer], 0
    mov ax, 1
    xor di, di
    ; Grava a unidade
    es mov [ObjSisArq.Unidade], bx
    ; Carrega buffer
    call __minixfsCarregaBufferRemoto
    jnc .fimRemoto
    mov di, ObjSisArqMinixFS.Buffer
    ; Calcula posicoes
    ; Guarda id da unidade
    push bx

    ; Id do item Raiz
    es mov word [ObjSisArq.Id], 1

    ; Ponteiro para Raiz
    mov ax, es
    es mov word [ObjSisArq.Raiz], ax

    ; Grava dados do indice para o ObjSisArqMinixFSRaiz
    es mov ax, [di + ObjMinixFSIndice.QtdItens]
    es mov [ObjSisArqMinixFSRaiz.CapacidadeItens], ax
    ; Calcula posicoes, ignorando as duas primeiras (Setor Inicial e Indice)
    mov ax, 2
    ; Inicio do mapa de itens
    es mov [ObjSisArqMinixFSRaiz.InicioMapaItens], ax
    es add ax, [di + ObjMinixFSIndice.BlocosMapaItens]
    ; Fim do mapa de itens
    es mov [ObjSisArqMinixFSRaiz.FimMapaBlocos], ax
    es dec word [ObjSisArqMinixFSRaiz.FimMapaBlocos]
    ; Inicio do mapa de blocos
    es mov [ObjSisArqMinixFSRaiz.InicioMapaBlocos], ax
    es add ax, [di + ObjMinixFSIndice.BlocosMapaItens]
    ; Fim do mapa de itens
    es mov [ObjSisArqMinixFSRaiz.FimMapaItens], ax
    es dec word [ObjSisArqMinixFSRaiz.FimMapaItens]
    ; Inicio da lista de itens
    es mov [ObjSisArqMinixFSRaiz.InicioItens], ax
    ; Fim da lista de itens
    es add ax, [di + ObjMinixFSIndice.PrimeiroBloco]
    dec ax
    es mov [ObjSisArqMinixFSRaiz.FimItens], ax
    ; Le o cs para gravar em todas as chamadas publicas
    mov ax, cs
    
    ; Grava o Ejeta
    es mov word [ObjSisArq.Ejeta], _minixfsEjeta
    es mov      [ObjSisArq.Ejeta + 2], ax
    
    ; Grava o SubItem
    es mov word [ObjSisArq.SubItem], _minixfsSubItem
    es mov      [ObjSisArq.SubItem + 2], ax
    
    ; Carrega primeiro bloco da lista de itens
    mov di, ObjSisArqMinixFSRaiz.Itens
    es mov ax, [ObjSisArqMinixFSRaiz.InicioItens]
    es mov [ObjSisArqMinixFSRaiz.BlocoItens], ax
    xor dx, dx
    ; Restaura id da unidade
    pop bx
    ; Le o primeiro bloco da lista de itens
    cs call far [Unidade.LeiaRemoto]
    jnc .fimRemoto

    ds mov [ObjUnidade.Raiz], es

    stc
    jmp .fim

    .fimRemoto:
    cs call far [Memoria.LiberaRemoto]
    .fim:
    pop cx
    pop dx
    pop bx
    pop ax
    pop si
    pop ds
    pop di
    pop es
    retf

; es:di = ObjSisArq
; cx = Posicao
; ret: cf = 1=Encontrado | 0=Nao encontrado OU fim da lista
;      ds:si = Aloca e retorna um objeto ObjSisArqItem
_minixfsSubItem:
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    call __minixfsTravaMultitarefa
    mov ax, cx
    mov cx, 32
    xor dx, dx
    div cx
    mov cx, ax
    call __minixfsCarregaDoItemRemoto
    jnc .fim
    mov ax, dx
    mov cx, ObjMinixFSItem._Tam
    mul cx
    add di, ax
    add di, ObjSisArqMinixFS.Buffer
    es cmp word [di], 0
    jne .ok
        clc
        jmp .fim
    .ok:
    cs mov al, [Prog.Processo]
    mov cx, ObjSisArqItem._Tam
    cs call far [Memoria.AlocaLocal]
    jc .alocado
        clc
        jmp .fim
    .alocado:
    es mov ax, [di]
    ds mov [si+ObjSisArqItem.Id], ax
    mov ax, es
    ds mov [si+ObjSisArqItem.Acima], ax
    mov ax, cs
    ds mov [si+ObjSisArqItem.Abrir + 2], ax
    mov ax, _minixfsAbrir
    ds mov [si+ObjSisArqItem.Abrir], ax
    add di, 2
    add si, ObjSisArqItem.Nome
    mov cx, 30
    cs call far [Memoria.CopiaRemotoLocal]
    xor si, si
    stc
    .fim:
    call __minixfsLiberaMultitarefa
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    retf

; OBS: Existe apenas na raiz
; bx = Unidade
; ret: cf = 1=Ejetado | 0=Nao ejetado
_minixfsEjeta:
    push es
    push ds
    push si
    cs call far [Unidade.BuscaLocal]
    jnc .fim
    ds push word [si+ObjUnidade.Raiz]
    pop es
    es cmp word [ObjSisArqMinixFSRaiz.Contador], 0
    jne .falha
    cs call far [Memoria.LiberaRemoto]
    stc
    jmp .fim
    .falha:
    clc
    .fim:
    pop si
    pop ds
    pop es
    retf

; Abre um item e cria um ObjSisArq para ele
; ds:si = ObjSisArqItem
; ret: cf = 1=Aberto | 0=Nao foi possivel abrir
;      es:di = ObjSisArq
_minixfsAbrir:
    push ax
    push cx
    push dx
    call __minixfsTravaMultitarefa
    mov cx, ObjSisArqMinixFS._Tam
    cs mov al, [Prog.Processo]
    cs call far [Memoria.AlocaRemoto]
    jnc .fim
        ds mov ax, [si+ObjSisArqItem.Id]
        es mov [di+ObjSisArq.Id], ax
        cs cmp word [MinixFS.Debug], 0
        je .ignoraDebug
            cs call far [Terminal.Escreva]
            db '[ ABRE: %Rh:%an ]',0
        .ignoraDebug:
        
        es mov word [di+ObjSisArqMinixFS.PosNoBuffer], 0
        es mov word [di+ObjSisArqMinixFS.PosNoItem], 0
        es mov word [di+ObjSisArqMinixFS.BlocoBuffer], 0

        push ds
        push si
        ds mov ax, [si+ObjSisArqItem.Acima]
        mov ds, ax
        xor si, si
        ds mov ax, [si+ObjSisArq.Unidade]
        es mov [di+ObjSisArq.Unidade],ax
        ds mov ax, [si+ObjSisArq.Raiz]
        es mov [di+ObjSisArq.Raiz],ax
        ; Carrega raiz
        mov ds, ax
        xor si, si
        ; Carrega item atual
        es mov ax, [di+ObjSisArq.Id]
        dec ax
        mov cx, 32
        xor dx, dx
        div cx
        call __minixfsCarregaItensLocal
        mov ax, dx
        mul cx
        add si, ax
        add si, ObjSisArqMinixFSRaiz.Itens
        ds mov ax, [si+ObjMinixFSItem.Modo]
        and ax, 0x8000
        cmp ax, 0x8000
        je .naoDir
            es mov word [di+ObjSisArq.Tipo], TipoSisArq.Diretorio

            mov ax, cs

            es mov [di+ObjSisArq.SubItem+2], ax
            mov cx, _minixfsSubItem
            es mov [di+ObjSisArq.SubItem], cx

            es mov [di+ObjSisArq.CalculaQtdItens+2], ax
            mov cx, _minixfsQtdItens
            es mov [di+ObjSisArq.CalculaQtdItens], cx

            es mov [di+ObjSisArq.CalculaTamanho+2], ax
            mov cx, _minixfsCalculaTamanho
            es mov [di+ObjSisArq.CalculaTamanho], cx

            jmp .naoArq
        .naoDir:
            es mov word [di+ObjSisArq.Tipo], TipoSisArq.Arquivo

            mov ax, cs

            es mov [di+ObjSisArq.Leia+2], ax
            mov cx, _minixfsLeia
            es mov [di+ObjSisArq.Leia], cx

            es mov [di+ObjSisArq.LeiaLinha+2], ax
            mov cx, _minixfsLeiaLinha
            es mov [di+ObjSisArq.LeiaLinha], cx

            es mov [di+ObjSisArq.CalculaTamanho+2], ax
            mov cx, _minixfsCalculaTamanho
            es mov [di+ObjSisArq.CalculaTamanho], cx
        .naoArq:

        pop si
        pop ds

        stc
        jmp .fim

    .falha:
    cs call far [Memoria.LiberaRemoto]
    clc
    .fim:
    call __minixfsLiberaMultitarefa
    pop dx
    pop cx
    pop ax
    retf

; es:di = ObjSisArq
; ds:si = Destino
; cx = Qtd de Bytes
; ret: cf = 1=Lido | 0=Nao lido
;      cx = Qtd de Bytes lidos
_minixfsLeia:
    push si
    push dx
    push bx
    push ax
    call __minixfsTravaMultitarefa
    xor dx, dx
    .le:
        cmp cx, dx
        jbe .fim
        push cx
        es mov cx, [di+ObjSisArqMinixFS.PosNoItem]
        call __minixfsCarregaDoItemRemoto
        pop cx
        jnc .fim
        .copia:
            es mov bx, [di+ObjSisArqMinixFS.PosNoBuffer]
            cmp cx, dx
            jbe .fim
            cmp bx, 1024
            jb .continua
                es inc word [di+ObjSisArqMinixFS.PosNoItem]
                es mov word [di+ObjSisArqMinixFS.PosNoBuffer], 0
                jmp .le
            .continua:
            es mov al, [di+bx+ObjSisArqMinixFS.Buffer]
            ds mov [si], al
            es inc word [di+ObjSisArqMinixFS.PosNoBuffer]
            inc si
            inc dx
            jmp .copia
    .fim:
    cmp dx, 0
    je .naoLeu
        stc
        jmp .fimValida
    .naoLeu:
        clc
    .fimValida:
    mov cx, dx
    call __minixfsLiberaMultitarefa
    pop ax
    pop bx
    pop dx
    pop si
    retf

; es:di = ObjSisArq
; ds:si = Destino
; cx = Qtd de Bytes
; ret: cf = 1=Lido | 0=Nao lido
;      cx = Qtd de Bytes lidos
_minixfsLeiaLinha:
    push si
    push dx
    push bx
    push ax
    call __minixfsTravaMultitarefa
    xor dx, dx
    .le:
        cmp cx, dx
        jbe .fim
        push cx
        es mov cx, [di+ObjSisArqMinixFS.PosNoItem]
        call __minixfsCarregaDoItemRemoto
        pop cx
        jnc .fim
        .copia:
            es mov bx, [di+ObjSisArqMinixFS.PosNoBuffer]
            cmp cx, dx
            jbe .fim
            cmp bx, 1024
            jb .continua
                es inc word [di+ObjSisArqMinixFS.PosNoItem]
                es mov word [di+ObjSisArqMinixFS.PosNoBuffer], 0
                jmp .le
            .continua:
            es mov al, [di+bx+ObjSisArqMinixFS.Buffer]
            cmp al, 0
            je .fimLinhaZero
            cmp al, 10
            je .fimLinha
            ds mov [si], al
            es inc word [di+ObjSisArqMinixFS.PosNoBuffer]
            inc si
            inc dx
            jmp .copia
            .fimLinha:
                es inc word [di+ObjSisArqMinixFS.PosNoBuffer]
            .fimLinhaZero:
                ds mov byte [si], 0
    .fim:
    cmp dx, 0
    je .naoLeu
        stc
        jmp .fimValida
    .naoLeu:
        clc
    .fimValida:
    mov dx, cx
    call __minixfsLiberaMultitarefa
    pop ax
    pop bx
    pop dx
    pop si
    retf

; es:di = ObjSisArq
; ret: cf = 1=Ok | 0=Falha
;      dx:ax = Tamanho
_minixfsCalculaTamanho:
    push cx
    push ds
    push si
    call __minixfsTravaMultitarefa
    ; Carrega a raiz
    es mov ax, [di+ObjSisArq.Raiz]
    mov ds, ax
    xor si, si
    ; Calcula bloco itens
    es mov ax, [di+ObjSisArq.Id]
    mov cx, 32
    xor dx,dx
    div cx
    ; Carrega bloco itens
    push dx
    call __minixfsCarregaItensLocal
    pop dx
    jc .ok
        xor ax, ax
        xor dx, dx
        clc
        jmp .fim
    .ok:
    mov si, ObjSisArqMinixFSRaiz.Itens
    ; Le o item
    mov ax, dx
    dec ax
    xor dx, dx
    mov cx, ObjMinixFSItem._Tam
    mul cx
    add si, ax
    mov ax, [si+ObjMinixFSItem.Tamanho]
    mov dx, [si+ObjMinixFSItem.Tamanho+2]
    stc
    .fim:
    call __minixfsLiberaMultitarefa
    pop si
    pop ds
    pop cx
    retf

; es:di = ObjSisArq
; ret: cf = 1=Ok | 0=Falha
;      cx = Quantidade de itens no diretorio
_minixfsQtdItens:
    push ax
    push bx
    push dx
    push es
    push di
    push si
    call __minixfsTravaMultitarefa
    xor ax, ax
    xor cx, cx
    xor dx, dx
    .carrega:
        call __minixfsCarregaDoItemRemoto
        jnc .fim
        mov si, ObjSisArqMinixFS.Buffer
        mov cx, ObjMinixFSItem._QtdPorBloco
        .calcula:
            es cmp word [si], 0
            je .fim
            add si, ObjMinixFSItem._Tam
            inc dx
            loop .calcula
        inc ax
        jmp .carrega
    .fim:
    mov cx, dx
    stc
    call __minixfsLiberaMultitarefa
    pop si
    pop di
    pop es
    pop dx
    pop bx
    pop ax
    retf