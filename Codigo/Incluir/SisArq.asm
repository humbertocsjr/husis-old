SisArq: dw ._Fim
    db 'HUSIS',0
    db 'SisArq',0
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
    ._Fim: