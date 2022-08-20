; =========
;  MinixFS
; =========
;
; Prototipo........: 18/08/2022
; Versao Inicial...: --/08/2022
; Autor............: Humberto Costa dos Santos Junior
;
; Funcao...........: Implementa o MinixFS
;
; Limitacoes.......: 
;
; Historico........:
;
; - 18/08/2022 - Humberto - Prototipo inicial

MinixFS: dw _minixfs, 0
    .Verifica: dw _minixfsVerifica, 0
    .Monta: dw _minixfsMonta, 0
    dw 0


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
    ._Tam: equ .PosNoBuffer + 2

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
    ._Tam: equ .FimItens + 2

_minixfs:
    retf


; Verifica se uma particao está formatada com MinixFS
; bx = Unidade
; ret: cf = 1=Ok | 0=Incompativel
_minixfsVerifica:
    push es
    push di
    push ax
    push dx
    cs mov al, [Prog.Processo]
    mov ax, 1024
    cs call far [Memoria.Aloca]
    jc .alocado
        clc
        jmp .fim
    .alocado:
    mov ax, 1
    xor di, di
    xor dx, dx
    cs call far [Unidade.Leia]
    jnc .falha
    es cmp word [ObjMinixFSIndice.Assinatura], 0x138f
    je .ok
    jmp .falha
    .ok:
        cs call far [Memoria.Libera]
        stc
        jmp .fim
    .falha:
        cs call far [Memoria.Libera]
        clc
    .fim:
    pop dx
    pop ax
    pop di
    pop es
    retf

; Monta uma unidade com MinixFS
; bx = Unidade
; ret: cf = 1=Ok | 0=Incompativel
_minixfsMonta:
    push es
    push di
    push ax
    push dx
    cs mov al, [Prog.Processo]
    mov ax, ObjSisArqMinixFSRaiz._Tam
    cs call far [Memoria.Aloca]
    jc .alocado
        clc
        jmp .fim
    .alocado:
    mov ax, 1
    mov di, ObjSisArqMinixFS.Buffer
    xor dx, dx
    cs call far [Unidade.Leia]
    jnc .falha
    es cmp word [di + ObjMinixFSIndice.Assinatura], 0x138f
    je .ok
    jmp .falha
    .ok:
        ; Guarda id da unidade
        push bx

        ; Id do item Raiz
        es mov word [ObjSisArq.Id], 1

        ; Bloco Buffer
        es mov word [ObjSisArqMinixFS.BlocoBuffer], 0

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
        ; Grava a unidade
        es mov [ObjSisArq.Unidade], bx
        ; Le o primeiro bloco da lista de itens
        cs call far [Unidade.Leia]
        jnc .falha
        ; Registra o sistema de arquivos na unidade
        cs call far [SisArq.RegistraUnidade]
        jnc .falha
        jmp .fim
    .falha:
        cs call far [Memoria.Libera]
        clc
    .fim:
    pop dx
    pop ax
    pop di
    pop es
    retf

; Carrega um bloco na lista de itens do ObjSisArqMinixFSRaiz
; es = ObjSisArqMinixFSRaiz
; ax = Endereco do bloco
; ret: cf = 1=Ok | 0=Falha ao ler
; OBS: Carrega apenas se o bloco nao tiver sido carregado anteriormente
__minixfsCarregaListaDeItens:
    push ax
    push dx
    push bx
    es add ax, [ObjSisArqMinixFSRaiz.InicioItens]
    es cmp ax, [ObjSisArqMinixFSRaiz.BlocoItens]
    jne .carrega
;        stc
;        jmp .fim
    .carrega:
    xor dx, dx
    es mov bx, [ObjSisArq.Unidade]
    mov di, ObjSisArqMinixFSRaiz.Itens
    cs call far [Unidade.Leia]
    .fim:
    pop bx
    pop dx
    pop ax
    ret

; Carrega um bloco no buffer do ObjSisArqMinixFS
; es = ObjSisArqMinixFS
; ax = Endereco do bloco
; ret: cf = 1=Ok | 0=Falha ao ler
; OBS: Carrega apenas se o bloco nao tiver sido carregado anteriormente
__minixfsCarregaUmBlocoDireto:
    push ax
    push dx
    push bx
    es cmp ax, [ObjSisArqMinixFS.BlocoBuffer]
    je .carrega
;        stc
;        jmp .fim
    .carrega:
    xor dx, dx
    es mov bx, [ObjSisArq.Unidade]
    mov di, ObjSisArqMinixFS.Buffer
    cs call far [Unidade.Leia]
    jnc .fim
    es mov [ObjSisArqMinixFS.BlocoBuffer], ax
    .fim:
    pop bx
    pop dx
    pop ax
    ret

; Carrega um bloco de um arquivo/diretorio
; es = ObjSisArqMinixFS
; cx = Posicao do bloco dentro do arquivo/diretorio
; ret: cf = 1=Ok | 0=Falha ao ler
__minixfsCarregaUmBlocoDoObj:
    push ax
    push bx
    push cx
    push dx
    push es
    ; Carrega a raiz para iniciar a busca
    es mov bx, [ObjSisArq.Id]
    es mov ax, [ObjSisArq.Raiz]
    mov es, ax
    ; Calcula posicao na lista de itens
    mov ax, bx
    dec ax
    xor dx, dx
    mov bx, 32
    div bx
    push dx
    call __minixfsCarregaListaDeItens
    pop bx
    mov ax, 32
    mul bx
    mov bx, ax
    cmp cx, 7
    ja .blocoPosterior
        mov di, ObjSisArqMinixFSRaiz.Itens
        shl cx, 1
        add bx, cx
        es mov ax, [di+bx+ObjMinixFSItem.Zonas]
        cmp ax, 0
        je .falha
        xor dx, dx
        pop es
        push es
        call __minixfsCarregaUmBlocoDireto
        jmp .fim
    .blocoPosterior:
cs call far [Terminal.EscrevaDebugPara]
        ; TODO: Falta implementar blocos indiretos e duplamente indiretos
    .falha:
        clc
    .fim:
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; Desmonta uma unidade
; bx = Unidade
; ret: cf = 1=Ejetado | 0=Nao ejetado
_minixfsEjeta:
    push es
    push ax
    cs call far [SisArq.LeiaUnidade]
    jnc .fim
    xor ax, ax
    mov es, ax
    es mov bx, [ObjSisArq.Unidade]
    cs call far [SisArq.RegistraUnidade]
    stc
    .fim:
    pop ax
    pop es
    retf

; Lista um sub item
; es = ObjSisArq
; cx = Posicao
; ret: cf = 1=Encontrado | 0=Nao encontrado OU fim da lista
;      es = Aloca e retorna um objeto ObjSisArqItem
_minixfsSubItem:
    mov ax, cx
    xor dx, dx
    mov cx, 32
    div cx
    mov cx, ax
    call __minixfsCarregaUmBlocoDoObj
    jnc .fim
    mov ax, dx
    mov cx, ObjMinixFSItem._Tam
    mul cx
    mov si, ax
    add si, ObjSisArqMinixFS.Buffer
    es cmp word [si], 0
    jne .ok
        clc
        jmp .fim
    .ok:
    push es
    pop ds
    cs mov al, [Prog.Processo]
    cs mov cx, ObjSisArqItem._Tam
    cs call far [Memoria.Aloca]
    jc .alocado
        jmp .fim
    .alocado:
    mov di, ObjSisArqItem.Id
    movsw
    push si
    mov di, ObjSisArqItem.Acima
    mov ax, ds
    stosw
    mov di, ObjSisArqItem.Raiz
    mov si, ObjSisArq.Raiz
    stosw
    mov di, ObjSisArqItem.Abrir
    mov ax, _minixfsAbrir
    stosw
    mov ax, cs
    stosw
    pop si
    mov di, ObjSisArqItem.Nome
    mov cx, 30
;cs call far [Terminal.EscrevaDebugDSSI]
    rep movsw
    stc
    .fim:
    retf

_minixfsAbrir:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push ds

    mov ax, es
    mov ds, ax
    mov cx, ObjSisArqMinixFS._Tam
    cs mov al, [Prog.Processo]
    cs call far [Memoria.Aloca]
    jnc .falha

    ; Le o cs para gravar em todas as chamadas publicas
    mov ax, cs

    ; Grava Id
    mov si, ObjSisArqItem.Id
    mov di, ObjSisArq.Id
    movsw
    
    ; Grava Raiz
    mov si, ObjSisArqItem.Raiz
    mov di, ObjSisArq.Raiz
    movsw
    
    ; Grava o SubItem
    es mov word [ObjSisArq.SubItem], _minixfsSubItem
    es mov      [ObjSisArq.SubItem + 2], ax

    stc
    jmp .fim
    .falha:
    clc
    .fim:
    pop ds
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    retf