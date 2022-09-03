; =====================
;  Sistema de Arquivos
; =====================
;
; Prototipo........: 21/08/2022
; Versao Inicial...: 21/08/2022
; Autor............: Humberto Costa dos Santos Junior
;
; Funcao...........: Gerencia o sistema de arquivos
;
; Limitacoes.......: 
;
; Historico........:
;
; - 21/08/2022 - Humberto - Prototipo inicial
;
; ----------------------------------------------------
;  Formato do Endereco de Itens (Arquivos/Diretorios)
; ----------------------------------------------------
;
; Um endereco eh feito de trechos que sao categorizados abaixo:
; 
;  - Unidade       : Define a qual unidade este item pertence
;  - SubItem       : Trecho do endereco que define o diretorio ou item final
;
; Os trechos devem ser separados por barra '/' e opcionalmente devem conter
; no inicio a unidade entre '[]', conforme exemplo abaixo:
;
; [0]/Sistema/Config.cfg
;
; Caso a unidade seja ocultada sera usada a unidade raiz (A que contem o 
; sistema operacional), conforme exemplo abaixo:
;
; /Sistema/Config.cfg
;


SisArq: dw _sisarq,0
    .SubItem: dw _sisarqSubItem, 0
        ; Lista um sub item do diretorio
        ; es = ObjSisArq
        ; cx = Posicao
        ; ret: cf = 1=Existe | 0=Nao Existe
        ;      es = ObjSisArqItem
    .AbreEnderecoRemoto: dw _sisarqAbreEnderecoRemoto,0
        ; Abre um item via endereco
        ; ds:si = Endereco
        ; ref: cf = 1=Ok | 0=Falha
        ;      es:di = ObjSisArq
    .LeiaLocal: dw _sisarqLeiaLocal, 0
        ; es:di = ObjSisArq
        ; ds:si = Destino
        ; cx = Qtd de Bytes
        ; ret: cf = 1=Lido | 0=Nao lido
        ;      cx = Qtd de Bytes lidos
    .LeiaLinhaLocal: dw _sisarqLeiaLinhaLocal, 0
        ; es:di = ObjSisArq
        ; ds:si = Destino
        ; cx = Qtd de Bytes
        ; ret: cf = 1=Lido | 0=Nao lido
        ;      cx = Qtd de Bytes lidos
    .CalculaTamanhoRemoto: dw _sisarqCalculaTamanhoRemoto, 0
        ; es:di = ObjSisArq
        ; ret: cf = 1=Lido | 0=Nao lido
        ;      dx:ax = Tamanho
    .FechaRemoto: dw _sisarqFechaRemoto, 0
        ; es:di = ObjSisArq
        ; ret: cf = 1=Lido | 0=Nao lido
        ;      dx:ax = Tamanho
    .CalculaQtdItens: dw _sisarqCalculaQtdItens, 0
        ; es:di = ObjSisArq
        ; ret: cf = 1=Lido | 0=Nao lido
        ;      cx = Qtd de itens no diretorio
    dw 0

_sisarq:
    retf

; Lista um sub item do diretorio
; es:di = ObjSisArq
; cx = Posicao
; ret: cf = 1=Existe | 0=Nao Existe
;      ds:si = ObjSisArqItem
_sisarqSubItem:
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    push di
    es mov word [ObjSisArq.Status], StatusSisArq.Desconhecido
    es cmp word [ObjSisArq.SubItem], 0
    jne .ok
        clc
        jmp .fim
    .ok:
    es call far [ObjSisArq.SubItem]
    .fim:
    pop di
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    retf

; Abre um item via endereco
; ds:si = Endereco
; ref: cf = 1=Ok | 0=Falha
;      es:di = ObjSisArq
_sisarqAbreEnderecoRemoto:
    push ax
    push bx
    push cx
    push dx
    push ds
    push si
    cs mov bx, [Unidade.UnidadePrincipal]

    cmp byte [si], '['
    jne .fimUnidade
        ; Ignora o '['
        lodsb
        cs call far [Texto.LocalParaNumero]
        jnc .falha
        mov bx, ax
        lodsb
        cmp al, ']'
        je .fimUnidade
        jmp .falha
    .fimUnidade:
    cs call far [Unidade.LeiaRaizRemoto]
    lodsb
    cmp al, '/'
    jne .falha
    xor cx, cx
    .buscaSubItem:
        cmp byte [si], '/'
        jne .continuaBusca
            inc si
        .continuaBusca:
        cmp byte [si], 0
        je .encerra
        push cx
        push es
        push si
        push di
        push ds
        push si
        cs call far [SisArq.SubItem]
        jc .subItemOk
            pop si
            pop ds
            pop di
            pop si
            pop es
            pop cx
            jmp .falha
        .subItemOk:
        push ds
        pop es
        mov di, si
        pop si
        pop ds
        add di, ObjSisArqItem.Nome
        .comparaNome:
            cmp byte [si], 0
            je .fimNome
            cmp byte [si], '/'
            je .fimNome
            cmpsb
            jne .proxItem
            jmp .comparaNome
            .encontradoNome:
                pop di
                push di
                es mov bx, [di+ObjSisArqItem.Abrir]
                cmp bx, 0
                je .falhaNome
                push ds
                push si
                push es
                pop ds
                push di
                pop si
                ds call far [si+ObjSisArqItem.Abrir]
                pop si
                pop ds
                jnc .falhaNome
                pop ax
                pop ax
                pop ax
                pop ax
                mov cx, 0
                jmp .buscaSubItem
            .falhaNome:
                pop di
                pop si
                pop es
                pop cx
                inc cx
                clc
                jmp .fim
            .fimNome:
                es cmp byte [di], 0
                je .encontradoNome
        .proxItem:
        pop di
        pop si
        pop es
        pop cx
        inc cx
        jmp .buscaSubItem
    .encerra:
    stc
    jmp .fim
    .falha:
        clc
        jmp .fim
    .fim:
    pop si
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax
    retf

; es:di = ObjSisArq
; ds:si = Destino
; cx = Qtd de Bytes
; ret: cf = 1=Lido | 0=Nao lido
;      cx = Qtd de Bytes lidos
_sisarqLeiaLocal:
    push ax
    push bx
    push dx
    push es
    push di
    es mov word [ObjSisArq.Status], StatusSisArq.Desconhecido
    es cmp word [ObjSisArq.Leia], 0
    jne .ok
        clc
        jmp .fim
    .ok:
    es call far [ObjSisArq.Leia]
    .fim:
    pop di
    pop es
    pop dx
    pop bx
    pop ax
    retf


; es:di = ObjSisArq
; ds:si = Destino
; cx = Qtd de Bytes
; ret: cf = 1=Lido | 0=Nao lido
;      cx = Qtd de Bytes lidos
_sisarqLeiaLinhaLocal:
    push ax
    push bx
    push dx
    push es
    push di
    es mov word [ObjSisArq.Status], StatusSisArq.Desconhecido
    es cmp word [ObjSisArq.LeiaLinha], 0
    jne .ok
        clc
        jmp .fim
    .ok:
    es call far [ObjSisArq.LeiaLinha]
    .fim:
    pop di
    pop es
    pop dx
    pop bx
    pop ax
    retf

; es:di = ObjSisArq
; ret: cf = 1=Lido | 0=Nao lido
;      dx:ax = Tamanho
_sisarqCalculaTamanhoRemoto:
    push bx
    push es
    push di
    es mov word [ObjSisArq.Status], StatusSisArq.Desconhecido
    es cmp word [ObjSisArq.CalculaTamanho], 0
    jne .ok
        clc
        jmp .fim
    .ok:
    es call far [ObjSisArq.CalculaTamanho]
    .fim:
    pop di
    pop es
    pop bx
    retf

; es:di = ObjSisArq
_sisarqFechaRemoto:
    cs call far [Memoria.LiberaRemoto]
    retf

; es:di = ObjSisArq
; ret: cf = 1=Lido | 0=Nao lido
;      cx = Qtd de itens no diretorio
_sisarqCalculaQtdItens:
    push bx
    push es
    push di
    es mov word [ObjSisArq.Status], StatusSisArq.Desconhecido
    es cmp word [ObjSisArq.CalculaQtdItens], 0
    jne .ok
        clc
        jmp .fim
    .ok:
    es call far [ObjSisArq.CalculaQtdItens]
    .fim:
    pop di
    pop es
    pop bx
    retf