JanPrincipal: dw _janprincipal,0
    dw 0

_janprincipal:
    push ax
    push bx
    push cx
    push dx
    push ds
    push si
    push es
    push di
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
        mov ax, 1    ; X
        mov bx, 1    ; Y
        cs call far [Interface.AlteraPosicao]
        jnc .erro
        ; Define o tamanho
        mov ax, 77   ; Largura
        mov bx, 23   ; Altura
        cs call far [Interface.AlteraTamanho]
        jnc .erro
        ; Define o titulo da janela usando um item da lista de traducoes
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
        cs call far [Interface.ConfigLista]
        ; Altera posicao
        mov ax, 2
        mov bx, 2
        cs call far [Interface.AlteraPosicao]
        jnc .erro
        ; Altera o tamanho
        mov ax, 75
        mov bx, 21
        cs call far [Interface.AlteraTamanho]
        jnc .erro
        ; Define o conteudo como uma lista
        cs cmp byte [Prog.Argumentos], '/'
        je .dirInicialArg
        cs cmp byte [Prog.Argumentos], '['
        je .dirInicialArg
        .dirRaiz:
            mov si, .constRaiz
            cs call far [SisArq.GeraListaDoEndereco]
            jnc .erro
            jmp .fimDirInicial
        .dirInicialArg:
            mov si, Prog.Argumentos
            cs call far [SisArq.GeraListaDoEndereco]
            jnc .dirRaiz
        .fimDirInicial:
        mov byte [si+4], 'C'
        cs call far [Interface.AlteraPrincipal]
        jnc .erro
        es mov word [di+ObjControle.ValorA], 16
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
    pop di
    pop es
    pop si
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax
    retf
    .constRaiz: db '/',0

_janprincipalSobreClick:
    cs call far [JanSobre]
    ; Exibe a janela
    cs call far [Interface.EntraEmFoco]
    retf

_janprincipalFecharClick:
    ; Carrega a janela deste botao
    cs call far [Interface.CarregaJanela]
    ; Oculta a janela
    cs call far [Interface.Oculta]
    retf