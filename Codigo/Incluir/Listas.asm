ListaLocal: dw ._Fim
    db 'HUSIS',0
    db 'ListaLocal',0
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
    ._Fim:
ListaRemota: dw ._Fim
    db 'HUSIS',0
    db 'ListaRemota',0
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
    ._Fim: