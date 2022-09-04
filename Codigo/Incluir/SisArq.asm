SisArq: dw ._Fim
    db 'HUSIS',0
    db 'SisArq',0
    .SubItem: dw 1, 0
        ; Lista um sub item do diretorio
        ; es = ObjSisArq
        ; cx = Posicao
        ; ret: cf = 1=Existe | 0=Nao Existe
        ;      es = ObjSisArqItem
    .AbreEnderecoRemoto: dw 1,0
        ; Abre um item via endereco
        ; ds:si = Endereco
        ; ref: cf = 1=Ok | 0=Falha
        ;      es:di = ObjSisArq
    .LeiaLocal: dw 1, 0
        ; es:di = ObjSisArq
        ; ds:si = Destino
        ; cx = Qtd de Bytes
        ; ret: cf = 1=Lido | 0=Nao lido
        ;      cx = Qtd de Bytes lidos
    .LeiaLinhaLocal: dw 1, 0
        ; es:di = ObjSisArq
        ; ds:si = Destino
        ; cx = Qtd de Bytes
        ; ret: cf = 1=Lido | 0=Nao lido
        ;      cx = Qtd de Bytes lidos
    .CalculaTamanhoRemoto: dw 1, 0
        ; es:di = ObjSisArq
        ; ret: cf = 1=Lido | 0=Nao lido
        ;      dx:ax = Tamanho
    .FechaRemoto: dw 1, 0
        ; es:di = ObjSisArq
        ; ret: cf = 1=Lido | 0=Nao lido
        ;      dx:ax = Tamanho
    .CalculaQtdItens: dw 1, 0
        ; es:di = ObjSisArq
        ; ret: cf = 1=Lido | 0=Nao lido
        ;      cx = Qtd de itens no diretorio
    .GeraLista: dw 1,0
        ; es:di = ObjSisArq
        ; ret: cf = 1=Ok | 0=Falha
        ;      ds = Lista de Arquivos (Registro de tamanho 39)
        ;           Formato:
        ;           | Pos | Tam | Descricao                    |
        ;           |-----|-----|------------------------------|
        ;           | 000 | 008 | Id do Item                   |
        ;           | 008 | 004 | ObjSisArq                    |
        ;           | 012 | 004 | Funcao Abre                  |
        ;           | 016 | 037 | Nome do arquivo              |
        ;           | 038 | 001 | Sempre Zero                  |
    .GeraListaDoEndereco: dw 1, 0
        ; ds:si = Endereco do arquivo
        ; ret: cf = 1=Ok | 0=Falha
        ;      ds = Lista de Arquivos (Registro de tamanho 39)
        ;           Formato:
        ;           | Pos | Tam | Descricao                    |
        ;           |-----|-----|------------------------------|
        ;           | 000 | 008 | Id do Item                   |
        ;           | 008 | 004 | ObjSisArq                    |
        ;           | 012 | 004 | Funcao Abre                  |
        ;           | 016 | 037 | Nome do arquivo              |
        ;           | 038 | 001 | Sempre Zero                  |
    ._Fim: