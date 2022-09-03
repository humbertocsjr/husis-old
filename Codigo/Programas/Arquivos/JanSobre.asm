JanSobre: dw _jansobre,0
    dw 0

_jansobre:

    ; Aloca espaço na memoria pra 10 Controles da Interface
    mov cx, 10
    cs call far [Interface.Aloca]
    jnc .erro

    ; Cria o primeiro controle como um item da Raiz (TELA)
    cs call far [Interface.CriaItemRaiz]
    jnc .erro
        ; Define esse controle como uma Janela
        cs call far [Interface.ConfigJanela]
        jnc .erro
        ; Posiciona a Janela
        mov ax, 10   ; X
        mov bx, 5    ; Y
        cs call far [Interface.AlteraPosicao]
        jnc .erro
        ; Define o tamanho
        mov ax, 60   ; Largura
        mov bx, 10   ; Altura
        cs call far [Interface.AlteraTamanho]
        jnc .erro
        ; Define o titulo da janela usando um item da lista de traducoes
        mov si, Trad.SobreTitulo
        cs call far [Interface.AlteraPrincipalTrad]
        jnc .erro

    ; Cria um item dentro da Janela que ja esta carregada
    cs call far [Interface.CriaItem]
    jnc .erro
        ; Configura como um Rotulo
        cs call far [Interface.ConfigRotulo]
        ; Define a posicao dentro da janela
        mov ax, 1
        mov bx, 1
        cs call far [Interface.AlteraPosicao]
        jnc .erro
        ; Define o tamanho
        mov ax, 60
        mov bx, 1
        cs call far [Interface.AlteraTamanho]
        jnc .erro
        ; Define o conteudo do rotulo
        mov si, Trad.Titulo
        cs call far [Interface.AlteraPrincipalTrad]
        jnc .erro

    ; Carrega novamente a janela associada ao controle atual (o criado 
    ; anteriomente)
    cs call far [Interface.CarregaJanela]
    jnc .erro
    ; Cria um item dentro dela
    cs call far [Interface.CriaItem]
    jnc .erro
        ; Define como rotulo
        cs call far [Interface.ConfigRotulo]
        ; Altera posicao
        mov ax, 1
        mov bx, 3
        cs call far [Interface.AlteraPosicao]
        jnc .erro
        ; Altera o tamanho
        mov ax, 60
        mov bx, 1
        cs call far [Interface.AlteraTamanho]
        jnc .erro
        ; Define o conteudo como uma constante local
        mov si, Copyright
        cs call far [Interface.AlteraPrincipalConst]
        jnc .erro

    ; Carrega novamente a janela
    cs call far [Interface.CarregaJanela]
    jnc .erro
    ; Cria um novo item dentro dela
    cs call far [Interface.CriaItem]
    jnc .erro
        ; Define como botao
        cs call far [Interface.ConfigBotao]
        ; Define a posicao
        mov ax, 20
        mov bx, 7
        cs call far [Interface.AlteraPosicao]
        jnc .erro
        ; Define o tamanho
        mov ax, 20
        mov bx, 1
        cs call far [Interface.AlteraTamanho]
        jnc .erro
        ; Define o texto
        mov si, Trad.SobreBotaoFechar
        cs call far [Interface.AlteraPrincipalTrad]
        jnc .erro
        ; Associa o evento Click a uma rotina
        mov si, _jansobreFecharClick
        cs call far [Interface.AlteraAcao]
        jnc .erro
        ; Define como controle em foco inicial da janela
        cs call far [Interface.EntraEmFoco]
        jnc .erro

    ; Carrega novamente a janela
    cs call far [Interface.CarregaJanela]
    jnc .erro
    ; Exibe a janela
    cs call far [Interface.Exibe]
    jnc .erro
    .erro:
    retf

_jansobreFecharClick:
    ; Carrega a janela deste botao
    cs call far [Interface.CarregaJanela]
    ; Oculta a janela
    cs call far [Interface.Oculta]
    retf