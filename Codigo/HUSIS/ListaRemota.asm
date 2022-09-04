ListaRemota: dw _listaR, 0
    .Cria: dw _listaRCria, 0
        ; Cria e inicializa uma lista
        ; cx = Capacidade Inicial
        ; ax = Tamanho de um item
        ; ret: cf = 1=Ok | 0=Sem memoria ou ultrapassa o tamanho maximo
        ;      es = Lista
    .Destroi: dw _listaRDestroi, 0
        ; Destroi a lista e libera a memoria
        ; es = Lista
        ; ret: cf = 1=Ok | 0=Falha
    .Adiciona: dw _listaRAdiciona, 0
        ; Adiciona um item a lista
        ; es = Lista
        ; ret: cf = 1=Ok | 0=Falha
        ;      es:di = Item em branco
    .Remove: dw _listaRRemove, 0
        ; Remove um item da lista
        ; ds:si = Item da Lista
        ; ret: cf = 1=Ok | 0=Falha
    .NavInicio: dw _listaRNavInicio, 0
        ; Vai para o inicio da lista
        ; es = Lista
        ; ret: cf = 1=Ok | 0=Sem itens
        ;      es:di = Primeiro item
    .NavProximo: dw _listaRNavProximo, 0
        ; Avanca um item
        ; es:di = Item atual na Lista
        ; ret: cf = 1=Ok | 0=Fim da lista
        ;      es:di = Proximo Item
    .NavAnterior: dw _listaRNavAnterior, 0
        ; Volta um item
        ; es:di = Item atual na Lista
        ; ret: cf = 1=Ok | 0=Inicio da lista
        ;      es:di = Item anterior
    .NavVaPara: dw _listaRNavVaPara, 0
        ; Vai para um item
        ; es = Lista
        ; cx = Posicao
        ; ret: cf = 1=Ok | 0=Fim da lista
        ;      es:di = Item
    .CalculaTamanho: dw _listaRCalculaTamanho, 0
        ; Calcula o tamanho de uma lista
        ; ds = Lista
        ; ret: cf = 1=Ok | 0=Fim da lista
        ;      cx = Tamanho
    dw 0

_listaR:
    retf


_listaRCria:
    push ds
    push si
    cs call far [ListaLocal.Cria]
    push ds
    pop es
    push si
    pop di
    pop si
    pop ds
    retf

_listaRDestroi:
    push ds
    push si
    push es
    pop ds
    push si
    pop di
    cs call far [ListaLocal.Destroi]
    push ds
    pop es
    push si
    pop di
    pop si
    pop ds
    retf

_listaRAdiciona:
    push ds
    push si
    push es
    pop ds
    push si
    pop di
    cs call far [ListaLocal.Adiciona]
    push ds
    pop es
    push si
    pop di
    pop si
    pop ds
    retf

_listaRRemove:
    push ds
    push si
    push es
    pop ds
    push si
    pop di
    cs call far [ListaLocal.Remove]
    push ds
    pop es
    push si
    pop di
    pop si
    pop ds
    retf

_listaRNavInicio:
    push ds
    push si
    push es
    pop ds
    push si
    pop di
    cs call far [ListaLocal.NavInicio]
    push ds
    pop es
    push si
    pop di
    pop si
    pop ds
    retf

_listaRNavProximo:
    push ds
    push si
    push es
    pop ds
    push si
    pop di
    cs call far [ListaLocal.NavProximo]
    push ds
    pop es
    push si
    pop di
    pop si
    pop ds
    retf

_listaRNavAnterior:
    push ds
    push si
    push es
    pop ds
    push si
    pop di
    cs call far [ListaLocal.NavAnterior]
    push ds
    pop es
    push si
    pop di
    pop si
    pop ds
    retf

; Vai para um item
; es = Lista
; cx = Posicao
; ret: cf = 1=Ok | 0=Fim da lista
;      es:di = Item
_listaRNavVaPara:
    push ax
    push bx
    push cx
    push dx
    cs call far [ListaRemota.NavInicio]
    jnc .fim
    cmp cx, 0
    je .ok
    .procura:
        cs call far [ListaRemota.NavProximo]
        jnc .fim
        loop .procura
    .ok:
    stc
    .fim:
    pop dx
    pop cx
    pop bx
    pop ax
    retf

; Calcula o tamanho de uma lista
; es = Lista
; ret: cf = 1=Ok | 0=Fim da lista
;      cx = Tamanho
_listaRCalculaTamanho:
    push ax
    push bx
    push dx
    push es
    push di
    xor cx, cx
    cs call far [ListaRemota.NavInicio]
    jnc .fim
    .procura:
        inc cx
        cs call far [ListaRemota.NavProximo]
        jnc .ok
        jmp .procura
    .ok:
    stc
    .fim:
    pop di
    pop es
    pop dx
    pop bx
    pop ax
    retf