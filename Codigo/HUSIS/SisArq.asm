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

ObjSisArq:
    .Id: equ 0
    .Tipo: equ 4
    .Raiz: equ 6
    .Reservado: equ 8
    .SubItem: equ 10
        ; es:di = ObjSisArq
        ; cx = Posicao
        ; ret: cf = 1=Encontrado | 0=Nao encontrado OU fim da lista
        ;      ds:si = Aloca e retorna um objeto ObjSisArqItem
    .Fechar: equ 14
        ; Fecha um item ja aberto e libera a memoria do ObjSisArq
        ; es:di = ObjSisArq
        ; ret: cf = 1=Fechado | 0=Operacao invalida
    .Leia: equ 18
        ; es:di = ObjSisArq
        ; ds:si = Origem
        ; cx = Qtd de Bytes
        ; ret: cf = 1=Lido | 0=Nao lido
        ;      cx = Qtd de Bytes lidos
    .Escreva: equ 22
        ; es:di = ObjSisArq
        ; ds:si = Origem
        ; cx = Qtd de Bytes
        ; ret: cf = 1=Escrito | 0=Nao escrito
        ;      cx = Qtd de Bytes escritos
    .Exclui: equ 26
        ; es:di = ObjSisArq
        ; ret: cf = 1=Excluido | 0=Nao excluido
    .CriaDiretorio: equ 30
        ; es:di = ObjSisArq
        ; ds:si = Nome do novo diretorio
        ; ret: cf = 1=Criado | 0=Nao criado
    .CriaArquivo: equ 34
        ; es:di = ObjSisArq
        ; ds:si = Nome do novo arquivo
        ; ret: cf = 1=Criado | 0=Nao criado
    .Ejeta: equ 38
        ; OBS: Existe apenas na raiz
        ; bx = Unidade
        ; ret: cf = 1=Ejetado | 0=Nao ejetado
    .Unidade: equ 42
    .IdAcima: equ 44
    .Status: equ 48
        ; Codigo do erro do ultimo comando
    .LeiaLinha: equ 50
        ; es:di = ObjSisArq
        ; ds:si = Origem
        ; cx = Qtd de Bytes
        ; ret: cf = 1=Lido | 0=Nao lido
        ;      cx = Qtd de Bytes lidos
    .CalculaTamanho: equ 54
    ._Tam: equ 58

ObjSisArqItem:
    .Id: equ 0
        ; Identificador unico no sistema de arquivos (Ate 8 Bytes)
    .Acima: equ 8
        ; Segmento onde esta o ObjSisArq (Acima)
    .Abrir: equ 12
        ; Abre um item e cria um ObjSisArq para ele
        ; ds:si = ObjSisArqItem
        ; ret: cf = 1=Aberto | 0=Nao foi possivel abrir
        ;      es:di = ObjSisArq
    .Nome: equ 16
        ; Nome do arquivo
    .Zero: equ 255
    ._CapacidadeNome: equ .Zero - .Nome
    ._Tam: equ 256

TipoSisArq:
    .Desconhecido: equ 0
    .Arquivo: equ 0x10
    .Diretorio: equ 0x20

StatusSisArq:
    .Desconhecido: equ 0
    .NaoExiste: equ 0x10
    .SemEspaco: equ 0x20
    .ApenasLeitura: equ 0x30

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