; Arquivo de inclusao da interface grafica
Interface: dw ._Fim
    db 'Interface',0
    db 'Interface',0
    .Aloca: dw 1,0
        ; cx = Quantidade de itens
        ; ret: cf = 1=Ok | 0=Sem memoria
        ;      es:0 = Bloco de Controles Alocado
        ;      es:di = Controle 0
    .Item: dw 1,0
        ; es:0 = Bloco de Controles Alocado
        ; cx = Item
        ; ret: cf = 1=Ok | 0=Estouro da Lista
        ;      es:di = Controle
    .CriaItem: dw 1,0
        ; Deve ser usado a partir do segundo item da lista
        ; es:0 = Bloco de Controles Alocado
        ; es:di = ObjControle Atual/Acima
        ; ret: cf = 1=Ok | 0=Estouro da Lista
        ;      cx = Posicao
        ;      es:di = Novo item da lista
    .CriaItemRaiz: dw 1,0
        ; Cria um item na tela
        ; es:0 = Bloco de Controles Alocado
        ; ret: cf = 1=Ok | 0=Estouro da Lista
        ;      cx = Posicao
        ;      es:di = Novo item da lista
    .ConfigTela: dw 1,0
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
    .ConfigJanela: dw 1,0
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
        ; Valores:
        ; - Principal = Ponteiro para o Titulo da Janela ASCIZ
    .ConfigRotulo: dw 1,0
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
        ; Valores:
        ; - Principal = Ponteiro para o Conteudo ASCIZ
    .ConfigCampo: dw 1,0
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
        ; Valores:
        ; - Principal = Ponteiro para o Conteudo ASCIZ
        ; - ValorPosicao = Posicao no conteudo
        ; - ValorTamanho = Tamanho do campo (Se nao definido calcula pelo 
        ;                  tamanho do conteudo ate encontrar o fim do texto)
        ; Eventos:
        ; - Acao = Alterado o conteudo
        ; - AcaoAux = Alterada a posicao no conteudo
        ; - AcaoFoco = Quando entra em foco
        ; - AcaoSemFoco = Quando sai do foco
    .ConfigBotao: dw 1,0
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
        ; Valores:
        ; - Principal = Ponteiro para o Texto ASCIZ
        ; Eventos:
        ; - Acao = Ao pressionar o botao
    .ConfigLista: dw 1,0
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
        ; Valores:
        ; - Principal = Ponteiro para a Lista
        ;               Formato em bytes:
        ;                0 ate 3 = Ignorado
        ;                4 em diante = Rotulo
        ; - ValorPosicao = Posicao na Lista
        ; Eventos:
        ; - Acao = Ao ativar um item
        ; - AcaoAux = Ao mudar de item
    .Renderiza: dw 1,0
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraPosicao: dw 1,0
        ; es:di = ObjControle
        ; ax = X1
        ; bx = Y1
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraPosicao2: dw 1,0
        ; es:di = ObjControle
        ; ax = X2
        ; bx = Y2
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraTamanho: dw 1,0
        ; es:di = ObjControle
        ; ax = Largura (Altera X2)
        ; bx = Altura (Altera Y2)
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraLargura: dw 1,0
        ; es:di = ObjControle
        ; ax = Largura (Altera X2)
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraAltura: dw 1,0
        ; es:di = ObjControle
        ; bx = Altura (Altera Y2)
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraPrincipal: dw 1,0
        ; es:di = ObjControle
        ; ds:si = Ponteiro
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraAuxiliar: dw 1,0
        ; es:di = ObjControle
        ; ds:si = Ponteiro
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraPrincipalTrad: dw 1,0
        ; es:di = ObjControle
        ; cs:si = Ponteiro Traducao
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraAuxiliarTrad: dw 1,0
        ; es:di = ObjControle
        ; cs:si = Ponteiro Traducao
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraPrincipalConst: dw 1,0
        ; es:di = ObjControle
        ; cs:si = Ponteiro Constante
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraAuxiliarConst: dw 1,0
        ; es:di = ObjControle
        ; cs:si = Ponteiro Constante
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraAcao: dw 1,0
        ; es:di = ObjControle
        ; cs:si = Ponteiro
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraAcaoAux: dw 1,0
        ; es:di = ObjControle
        ; cs:si = Ponteiro
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraAcaoFoco: dw 1,0
        ; es:di = ObjControle
        ; cs:si = Ponteiro
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraAcaoSemFoco: dw 1,0
        ; es:di = ObjControle
        ; cs:si = Ponteiro
        ; ret: cf = 1=Ok | 0=Falha
    .Exibe: dw 1,0
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
    .Oculta: dw 1,0
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
    .CarregaAcima: dw 1,0
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
        ;      es:di = ObjControle Acima
    .CarregaJanela: dw 1,0
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
        ;      es:di = ObjControle Janela Acima
    .CarregaTela: dw 1,0
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
        ;      es:di = ObjControle Tela Acima
    .CarregaSubControle: dw 1,0
        ; es:di = ObjControle
        ; cx = Posicao
        ; ret: cf = 1=Ok | 0=Nao existe
        ;      es:di = ObjControle Abaixo
    .EntraEmFoco: dw 1,0
        ; es:di = ObjControle
    .LimpaFoco: dw 1,0
    .ProcessaTecla: dw 1, 0
        ; es:di = ObjControle
        ; ax = X do ObjControle
        ; bx = Y do ObjControle
        ; cx = Scroll indo de -128 a +128
        ; dx = TipoBotaoMouse (Contem mais de uma em paralelo)
        ; ret: cf = 1=Renderiza | 0=Ignora
    .ProcessaMouse: dw 1, 0
        ; es:di = ObjControle
        ; ax = X do ObjControle
        ; bx = Y do ObjControle
        ; cx = Scroll indo de -128 a +128
        ; dx = TipoBotaoMouse (Contem mais de uma em paralelo)
        ; ret: cf = 1=Renderiza | 0=Ignora
    ._Fim: