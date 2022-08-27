; Arquivo de inclusao da interface grafica
Interface: dw ._Fim
    db 'Interface',0
    db 'Interface',0
    .AlocaControleRemoto: dw 1,0
        ; ret: cf = 1=Ok | 0=Falha
        ;      es:di = ObjControle
    .AlocaSubControleRemoto: dw 1,0
        ; es:di = ObjControle Acima
        ; ret: cf = 1=Ok | 0=Falha
        ;      es:di = ObjControle
    .LiberaControleRemoto: dw 1,0
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraPosInicialRemoto: dw 1, 0
        ; es:di = ObjControle
        ; cx = X1
        ; dx = Y1
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraPosFinalRemoto: dw 1, 0
        ; es:di = ObjControle
        ; cx = X2
        ; dx = Y2
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraTamanhoRemoto: dw 1, 0
        ; es:di = ObjControle
        ; cx = Largura
        ; dx = Altura
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraConteudoRemoto: dw 1, 0
        ; es:di = ObjControle
        ; ds:si = Novo conteudo
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraConteudoTradRemoto: dw 1, 0
        ; es:di = ObjControle
        ; ds:si = Traducao (ds=cs)
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraExtensaoRemoto: dw 1, 0
        ; es:di = ObjControle
        ; ds:si = Novo conteudo extendido
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraExtensaoTradRemoto: dw 1, 0
        ; es:di = ObjControle
        ; ds:si = Traducao (ds=cs)
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraValorARemoto: dw 1, 0
        ; es:di = ObjControle
        ; ax = Valor A
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraValorBRemoto: dw 1, 0
        ; es:di = ObjControle
        ; bx = Valor B
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraValorCRemoto: dw 1, 0
        ; es:di = ObjControle
        ; cx = Valor C
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraValorDRemoto: dw 1, 0
        ; es:di = ObjControle
        ; dx = Valor D
        ; ret: cf = 1=Ok | 0=Falha
    .RenderizaRemoto: dw 1, 0
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
    .ExibeRemoto: dw 1, 0
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
    .OcultaRemoto: dw 1, 0
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
    .AdicionaJanelaRemota: dw 1,0
        ; Adiciona uma janela a raiz
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
    .AdicionaRemota: dw 1,0
        ; Adiciona um controle a um outro controle/janela
        ; es:di = ObjControle Acima
        ; ds:si = ObjControle Abaixo
        ; ret: cf = 1=Ok | 0=Falha
    .AdicionaLocal: dw 1,0
        ; Adiciona um controle a um outro controle/janela
        ; es:di = ObjControle Abaixo
        ; ds:si = ObjControle Acima
        ; ret: cf = 1=Ok | 0=Falha
    .CopiaPonteiroRemotoParaLocal: dw 1,0
        ; Copia es:di para ds:si de forma facil, ficando os dois identicos
        ; ret: cf = 1=Ok | 0=Falha
    .IniciaRemoto: dw 1, 0
        ; Inicia um objeto em branco
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
    .IniciaRotuloRemoto: dw 1,0
        ; es:di = ObjControle
        ; ds:si = Texto
        ; ret: cf = 1=Ok | 0=Falha
    .IniciaRotuloTradRemoto: dw 1,0
        ; es:di = ObjControle
        ; ds:si = Traducao (ds=cs)
        ; ret: cf = 1=Ok | 0=Falha
    .IniciaJanelaRemoto: dw 1,0
        ; es:di = ObjControle
        ; ds:si = Texto
        ; ret: cf = 1=Ok | 0=Falha
    .IniciaJanelaTradRemoto: dw 1,0
        ; es:di = ObjControle
        ; ds:si = Traducao (ds=cs)
        ; ret: cf = 1=Ok | 0=Falha
    ._Fim: