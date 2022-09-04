ListaLocal: dw _listaL, 0
    .Cria: dw _listaLCria, 0
        ; Cria e inicializa uma lista
        ; cx = Capacidade Inicial
        ; ax = Tamanho de um item
        ; ret: cf = 1=Ok | 0=Sem memoria ou ultrapassa o tamanho maximo
        ;      ds = Lista
    .Destroi: dw _listaLDestroi, 0
        ; Destroi a lista e libera a memoria
        ; ds = Lista
        ; ret: cf = 1=Ok | 0=Falha
    .Adiciona: dw _listaLAdiciona, 0
        ; Adiciona um item a lista
        ; ds = Lista
        ; ret: cf = 1=Ok | 0=Falha
        ;      ds:si = Item em branco
    .Remove: dw _listaLRemove, 0
        ; Remove um item da lista
        ; ds:si = Item da Lista
        ; ret: cf = 1=Ok | 0=Falha
    .NavInicio: dw _listaLNavInicio, 0
        ; Vai para o inicio da lista
        ; ds = Lista
        ; ret: cf = 1=Ok | 0=Sem itens
        ;      ds:si = Primeiro item
    .NavProximo: dw _listaLNavProximo, 0
        ; Avanca um item
        ; ds:si = Item atual na Lista
        ; ret: cf = 1=Ok | 0=Fim da lista
        ;      ds:si = Proximo Item
    .NavAnterior: dw _listaLNavAnterior, 0
        ; Volta um item
        ; ds:si = Item atual na Lista
        ; ret: cf = 1=Ok | 0=Inicio da lista
        ;      ds:si = Item anterior
    dw 0

ObjLista:
    ._Assinatura: equ 1989
    .Assinatura: equ 0
    .TamanhoItem: equ 2
    .CapacidadeGeral: equ 4
    .CapacidadeLocal: equ 6
    .SegConjInicio: equ 10
    .SegConjAnterior: equ 12
    .SegConjProximo: equ 14
    .PtrPrimeiroItem: equ 16
    .Conteudo: equ 20
    ._Tam: equ 20

ObjListaItem:
    .Status: equ 0
    .PtrAnterior: equ 1
    .PtrProximo: equ 5
    .Dados: equ 9
    ._Tam: equ 9

TipoListaStatus:
    .Vazio: equ 0
    .Ocupado: equ 1

_listaL:
    retf

_listaLCria:
    push ax
    push bx
    push cx
    push dx
    add ax, ObjListaItem._Tam
    mov bx, ax
    mul cx
    add ax, ObjLista._Tam
    adc dx, 0
    cmp dx, 0
    je .okTam
        clc
        jmp .fim
    .okTam:
    push cx
    push bx
    mov cx, ax
    cs call far [HUSIS.ProcessoAtual]
    cs call far [Memoria.AlocaLocal]
    pop bx
    pop cx
    jnc .fim
    mov word [ObjLista.Assinatura], ObjLista._Assinatura
    mov ax, ds
    mov [ObjLista.SegConjInicio], ax
    mov [ObjLista.CapacidadeGeral], cx
    mov [ObjLista.CapacidadeLocal], cx
    mov [ObjLista.TamanhoItem], bx
    mov si, ObjLista.Conteudo
    .inicia:
        mov byte [si], TipoListaStatus.Vazio
        add si, [ObjLista.TamanhoItem]
        loop .inicia
    xor si, si
    stc
    .fim:
    pop dx
    pop cx
    pop bx
    pop ax
    retf

_listaLDestroi:
    push ds
    push si
    call __listaLVerificaAssinatura
    jnc .fim
    call __ListaLCarregaInicio
    call __listaLSubDestroi
    .fim:
    pop si
    pop ds
    retf

__listaLSubDestroi:
    call __listaLVerificaAssinatura
    jnc .fim
    push ax
    push ds
    cmp word [ObjLista.SegConjProximo], 0
    je .ok
        mov ax, [ObjLista.SegConjProximo]
        mov ds, ax
        call __listaLSubDestroi
    .ok:
    pop ds
    cs call far [Memoria.LiberaLocal]
    .fim:
    pop ax
    ret

__listaLVerificaAssinatura:
    cmp word [ObjLista.Assinatura], ObjLista._Assinatura
    je .ok
        clc
        jmp .fim
    .ok:
    stc
    .fim:
    ret

__ListaLCarregaInicio:
    push ax
    mov ax, [ObjLista.SegConjInicio]
    mov ds, ax
    pop ax
    ret

; ds = Lista
; ret: cf = 1=Ok | 0=Falha
;      ds:si = Item
__listaLReserva:
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    call __listaLVerificaAssinatura
    jnc .fim
    call __ListaLCarregaInicio
    .novaLista:
        mov si, ObjLista.Conteudo
        mov cx, [ObjLista.CapacidadeLocal]
        .busca:
            cmp byte [si+ObjListaItem.Status], TipoListaStatus.Vazio
            je .encontrado
            add si, [ObjLista.TamanhoItem]
            loop .busca
        cmp word [ObjLista.SegConjProximo], 0
        jne .proxConj
            mov cx, 10
            .tenta:
                mov ax, [ObjLista.TamanhoItem]
                mul cx
                cmp dx, 0
                je .okTam
                    mov cx, 1
                    jmp .tenta
                .okTam:
                mov cx, ax
                cs call far [HUSIS.ProcessoAtual]
                cs call far [Memoria.AlocaRemoto]
                jnc .fim
                push cx
                xor si, si
                xor di, di
                mov cx, ObjLista._Tam
                rep movsb
                pop cx
                es mov [ObjLista.CapacidadeLocal], cx
                mov di, ObjLista.Conteudo
                .inicia:
                    es mov byte [di], TipoListaStatus.Vazio
                    es add di, [ObjLista.TamanhoItem]
                    loop .inicia
                mov ax, es
                mov [ObjLista.SegConjProximo], ax
                call __ListaLCarregaInicio
                es mov cx, [ObjLista.CapacidadeLocal]
                add [ObjLista.CapacidadeGeral], cx
                push es
                pop ds
                jmp .fimProxConj
        .proxConj:
            mov ax, [ObjLista.SegConjProximo]
            mov ds, ax
        .fimProxConj:
        jmp .novaLista
    .encontrado:
    stc
    .fim:
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax    
    ret

_listaLAdiciona:
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    call __listaLVerificaAssinatura
    jnc .fim
    cmp word [ObjLista.PtrPrimeiroItem+2], 0
    jne .iniciaBusca
        mov ax, ds
        mov [ObjLista.PtrPrimeiroItem+2], ax
        mov si, ObjLista.Conteudo
        mov [ObjLista.PtrPrimeiroItem], si
        xor ax, ax
        mov es, ax
        mov di, ax
        jmp .encontrado
    .iniciaBusca:
        mov si, [ObjLista.PtrPrimeiroItem]
        mov ax, [ObjLista.PtrPrimeiroItem+2]
        mov ds, ax
        .busca:
            cmp word [si+ObjListaItem.PtrProximo + 2], 0
            je .encontradoUltimo
            mov ax, [si+ObjListaItem.PtrProximo+2]
            mov si, [si+ObjListaItem.PtrProximo]
            mov ds, ax
            jmp .busca
            .encontradoUltimo:
                push ds
                pop es
                mov di, si
                call __listaLReserva
                jnc .fim
                mov ax, ds
                es mov [di+ObjListaItem.PtrProximo + 2], ax
                es mov [di+ObjListaItem.PtrProximo], si
    .encontrado:
        mov byte [si], TipoListaStatus.Ocupado
        push si
        mov ax, es
        mov [si+ObjListaItem.PtrAnterior + 2], ax
        mov [si+ObjListaItem.PtrAnterior], di
        xor ax, ax
        mov [si+ObjListaItem.PtrProximo + 2], ax
        mov [si+ObjListaItem.PtrProximo], ax
        mov cx, [ObjLista.TamanhoItem]
        sub cx, ObjListaItem._Tam
        push ds
        pop es
        add si, ObjListaItem.Dados
        mov di, si
        xor ax, ax
        rep stosb
        pop si
        add si, ObjListaItem.Dados
        stc
    .fim:
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    retf

_listaLRemove:
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    push ds
    push si
    call __listaLVerificaAssinatura
    jnc .fim
    sub si, ObjListaItem._Tam
    cmp byte [si+ObjListaItem.Status], TipoListaStatus.Ocupado
    je .ok
        clc
        jmp .fim
    .ok:
    cmp word [si+ObjListaItem.PtrProximo + 2], 0
    je .ignoraProximo
        mov ax, [si+ObjListaItem.PtrProximo + 2]
        mov di, [si+ObjListaItem.PtrProximo]
        mov es, ax
        mov ax, [si+ObjListaItem.PtrAnterior + 2]
        mov bx, [si+ObjListaItem.PtrAnterior]
        es mov [di+ObjListaItem.PtrAnterior + 2], ax
        es mov [di+ObjListaItem.PtrAnterior], bx
    .ignoraProximo:
    cmp word [si+ObjListaItem.PtrAnterior + 2], 0
    je .ignoraAnterior
        mov ax, [si+ObjListaItem.PtrAnterior + 2]
        mov di, [si+ObjListaItem.PtrAnterior]
        mov es, ax
        mov ax, [si+ObjListaItem.PtrProximo + 2]
        mov di, [si+ObjListaItem.PtrProximo]
        es mov [di+ObjListaItem.PtrProximo + 2], ax
        es mov [di+ObjListaItem.PtrProximo], si
    .ignoraAnterior:
    mov word [si+ObjListaItem.Status], TipoListaStatus.Vazio
    mov ax, ds
    mov es, ax
    mov di, si
    call __ListaLCarregaInicio
    cmp [ObjLista.PtrPrimeiroItem + 2], ax
    jne .ignoraPrimeiro
    cmp [ObjLista.PtrPrimeiroItem], di
    jne .ignoraPrimeiro
        es mov ax, [di+ObjListaItem.PtrProximo+2]
        mov [ObjLista.PtrPrimeiroItem+2], ax
        es mov ax, [di+ObjListaItem.PtrProximo]
        mov [ObjLista.PtrPrimeiroItem], ax
    .ignoraPrimeiro:
    stc
    .fim:
    pop si
    pop ds
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    retf

_listaLNavInicio:
    push ax
    call __listaLVerificaAssinatura
    jnc .fim
    call __ListaLCarregaInicio
    cmp word [ObjLista.PtrPrimeiroItem+2],0
    jne .ok
        clc
        jmp .fim
    .ok:
    mov ax, [ObjLista.PtrPrimeiroItem+2]
    mov si, [ObjLista.PtrPrimeiroItem]
    add si, ObjListaItem._Tam
    mov ds, ax
    stc
    .fim:
    pop ax
    retf

_listaLNavProximo:
    push ax
    call __listaLVerificaAssinatura
    jnc .fim
    sub si, ObjListaItem._Tam
    cmp word [si+ObjListaItem.PtrProximo+2],0
    jne .ok
        clc
        jmp .fim
    .ok:
    mov ax, [si+ObjListaItem.PtrProximo+2]
    mov si, [si+ObjListaItem.PtrProximo]
    add si, ObjListaItem._Tam
    mov ds, ax
    stc
    .fim:
    pop ax
    retf

_listaLNavAnterior:
    push ax
    call __listaLVerificaAssinatura
    jnc .fim
    sub si, ObjListaItem._Tam
    cmp word [si+ObjListaItem.PtrAnterior+2],0
    jne .ok
        clc
        jmp .fim
    .ok:
    mov ax, [si+ObjListaItem.PtrAnterior+2]
    mov si, [si+ObjListaItem.PtrAnterior]
    add si, ObjListaItem._Tam
    mov ds, ax
    stc
    .fim:
    pop ax
    retf