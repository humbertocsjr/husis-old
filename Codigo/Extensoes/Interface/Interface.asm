; =========================
;  Interface com o Usuario
; =========================
;
; Prototipo........: 28/08/2022
; Versao Inicial...: 28/08/2022
; Autor............: Humberto Costa dos Santos Junior
;
; Funcao...........: Gerencia a Interface com o Usuario
;
; Limitacoes.......: 
;
; Historico........:
;
; - 28/08/2022 - Humberto - Prototipo inicial
; - 01/09/2022 - Humberto - Implementacao do teclado, eventos e Campo de texto
%include '../../Incluir/Prog.asm'

nome: db 'Interface',0
versao: dw 0,1,1
tipo: dw TipoProg.Executavel
modulos:
    dw Interface
    dw VideoTexto
    dw Teclado
    dw 0
    %include 'VideoTexto.asm'
    %include 'VideoTextoCGA.asm'
    %include 'VideoTextoEGA.asm'
    %include 'VideoTextoVGA.asm'
    %include 'Teclado.asm'
    %include 'CtlTela.asm'
    %include 'CtlJanela.asm'
    %include 'CtlRotulo.asm'
    %include 'CtlCampo.asm'
    %include 'CtlBotao.asm'
    %include 'CtlLista.asm'
importar:
    %include '../../Incluir/Texto.asm'
    %include '../../Incluir/Memoria.asm'
    %include '../../Incluir/HUSIS.asm'
    %include '../../Incluir/ObjControle.asm'
    %include '../../Incluir/Semaforo.asm'
    %include '../../Incluir/Listas.asm'
    dw 0
exportar:
    dw Interface
    db 'Interface',0
    dw 0

_interfaceRetNao:
    clc
    retf

_interfaceRetSim:
    stc
    retf

; es:di = ObjControle
__interfaceIniciaObj:
    push ax
    mov ax, cs
    es mov      [di+ObjControle.FuncRenderiza + 2], ax
    es mov word [di+ObjControle.FuncRenderiza], _interfaceRetNao
    es mov      [di+ObjControle.FuncAcao + 2], ax
    es mov word [di+ObjControle.FuncAcao], _interfaceRetSim
    es mov      [di+ObjControle.FuncAcaoAux + 2], ax
    es mov word [di+ObjControle.FuncAcaoAux], _interfaceRetSim
    es mov      [di+ObjControle.FuncAcaoFoco + 2], ax
    es mov word [di+ObjControle.FuncAcaoFoco], _interfaceRetSim
    es mov      [di+ObjControle.FuncAcaoSemFoco + 2], ax
    es mov word [di+ObjControle.FuncAcaoSemFoco], _interfaceRetSim
    es mov      [di+ObjControle.FuncProcessaMouse + 2], ax
    es mov word [di+ObjControle.FuncProcessaMouse], _interfaceRetSim
    es mov      [di+ObjControle.FuncProcessaTecla + 2], ax
    es mov word [di+ObjControle.FuncProcessaTecla], _interfaceRetSim
    es mov      [di+ObjControle.FuncEntraNoFoco + 2], ax
    es mov word [di+ObjControle.FuncEntraNoFoco], _interfaceRetSim
    es mov      [di+ObjControle.FuncSaiDoFoco + 2], ax
    es mov word [di+ObjControle.FuncSaiDoFoco], _interfaceRetSim

    pop ax
    ret

Interface: dw _interface,0
    .Aloca: dw _interfaceAloca,0
        ; cx = Quantidade de itens
        ; ret: cf = 1=Ok | 0=Sem memoria
        ;      es:0 = Bloco de Controles Alocado
        ;      es:di = Controle 0
    .Item: dw _interfaceItem,0
        ; es:0 = Bloco de Controles Alocado
        ; cx = Item
        ; ret: cf = 1=Ok | 0=Estouro da Lista
        ;      es:di = Controle
    .CriaItem: dw _interfaceCriaItem,0
        ; Deve ser usado a partir do segundo item da lista
        ; es:0 = Bloco de Controles Alocado
        ; es:di = ObjControle Atual/Acima
        ; ret: cf = 1=Ok | 0=Estouro da Lista
        ;      cx = Posicao
        ;      es:di = Novo item da lista
    .CriaItemRaiz: dw _interfaceCriaItemRaiz,0
        ; Cria um item na tela
        ; es:0 = Bloco de Controles Alocado
        ; ret: cf = 1=Ok | 0=Estouro da Lista
        ;      cx = Posicao
        ;      es:di = Novo item da lista
    .ConfigTela: dw _tela,0
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
    .ConfigJanela: dw _janela,0
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
        ; Valores:
        ; - Principal = Ponteiro para o Titulo da Janela ASCIZ
    .ConfigRotulo: dw _rotulo,0
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
        ; Valores:
        ; - Principal = Ponteiro para o Conteudo ASCIZ
    .ConfigCampo: dw _campo,0
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
    .ConfigBotao: dw _botao,0
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
        ; Valores:
        ; - Principal = Ponteiro para o Texto ASCIZ
        ; Eventos:
        ; - Acao = Ao pressionar o botao
    .ConfigLista: dw _lista,0
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
        ; Valores:
        ; - Principal = Ponteiro para a Lista
        ;               Formato em bytes:
        ;                0 ate 3 = Ignorado
        ;                4 em diante = Rotulo
        ; - ValorPosicao = Posicao na Lista
        ; - ValorA = Posicao dentro do item onde comeca o texto ASCIZ
        ; Eventos:
        ; - Acao = Ao ativar um item
        ; - AcaoAux = Ao mudar de item
    .Renderiza: dw _interfaceRenderiza,0
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraPosicao: dw _interfaceAlteraPosicao,0
        ; es:di = ObjControle
        ; ax = X1
        ; bx = Y1
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraPosicao2: dw _interfaceAlteraPosicao2,0
        ; es:di = ObjControle
        ; ax = X2
        ; bx = Y2
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraTamanho: dw _interfaceAlteraTamanho,0
        ; es:di = ObjControle
        ; ax = Largura (Altera X2)
        ; bx = Altura (Altera Y2)
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraLargura: dw _interfaceAlteraLargura,0
        ; es:di = ObjControle
        ; ax = Largura (Altera X2)
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraAltura: dw _interfaceAlteraAltura,0
        ; es:di = ObjControle
        ; bx = Altura (Altera Y2)
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraPrincipal: dw _interfaceAlteraPrincipal,0
        ; es:di = ObjControle
        ; ds:si = Ponteiro
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraAuxiliar: dw _interfaceAlteraAuxiliar,0
        ; es:di = ObjControle
        ; ds:si = Ponteiro
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraPrincipalTrad: dw _interfaceAlteraPrincipalTrad,0
        ; es:di = ObjControle
        ; cs:si = Ponteiro Traducao
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraAuxiliarTrad: dw _interfaceAlteraAuxiliarTrad,0
        ; es:di = ObjControle
        ; cs:si = Ponteiro Traducao
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraPrincipalConst: dw _interfaceAlteraPrincipalConst,0
        ; es:di = ObjControle
        ; cs:si = Ponteiro Constante
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraAuxiliarConst: dw _interfaceAlteraAuxiliarConst,0
        ; es:di = ObjControle
        ; cs:si = Ponteiro Constante
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraAcao: dw _interfaceAlteraAcao,0
        ; es:di = ObjControle
        ; cs:si = Ponteiro
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraAcaoAux: dw _interfaceAlteraAcaoAux,0
        ; es:di = ObjControle
        ; cs:si = Ponteiro
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraAcaoFoco: dw _interfaceAlteraAcaoFoco,0
        ; es:di = ObjControle
        ; cs:si = Ponteiro
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraAcaoSemFoco: dw _interfaceAlteraAcaoSemFoco,0
        ; es:di = ObjControle
        ; cs:si = Ponteiro
        ; ret: cf = 1=Ok | 0=Falha
    .Exibe: dw _interfaceExibe,0
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
    .Oculta: dw _interfaceOculta,0
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
    .CarregaAcima: dw _interfaceAcima,0
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
        ;      es:di = ObjControle Acima
    .CarregaJanela: dw _interfaceJanela,0
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
        ;      es:di = ObjControle Janela Acima
    .CarregaTela: dw _interfaceTela,0
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
        ;      es:di = ObjControle Tela Acima
    .CarregaSubControle: dw _interfaceSubControle,0
        ; es:di = ObjControle
        ; cx = Posicao
        ; ret: cf = 1=Ok | 0=Nao existe
        ;      es:di = ObjControle Abaixo
    .EntraEmFoco: dw _interfaceEntraEmFoco,0
        ; es:di = ObjControle
    .LimpaFoco: dw _interfaceLimpaFoco,0
    .ProcessaTecla: dw _interfaceProcessaTecla, 0
        ; es:di = ObjControle
        ; ax = X do ObjControle
        ; bx = Y do ObjControle
        ; cx = Scroll indo de -128 a +128
        ; dx = TipoBotaoMouse (Contem mais de uma em paralelo)
        ; ret: cf = 1=Renderiza | 0=Ignora
    .ProcessaMouse: dw _interfaceProcessaMouse, 0
        ; es:di = ObjControle
        ; ax = X do ObjControle
        ; bx = Y do ObjControle
        ; cx = Scroll indo de -128 a +128
        ; dx = TipoBotaoMouse (Contem mais de uma em paralelo)
        ; ret: cf = 1=Renderiza | 0=Ignora
    dw 0
    .Solicitacoes: dw 0
    .SemaforoFoco: dw 0
    .ObjEmFoco: dw 0, 0
    .Tela: times ObjControle._Tam db 0
    .TemaCorFrente: dw TipoCor.Ciano | TipoCorFundo.Preto
    .TemaCorDestaque: dw TipoCor.CianoClaro | TipoCorFundo.Preto
    .TemaCorBotaoFechar: dw TipoCor.VermelhoClaro | TipoCorFundo.Preto
    .TemaCorBorda: dw TipoCor.Ciano | TipoCorFundo.Preto
    .TemaCorFundo: dw TipoCor.Ciano | TipoCorFundo.Preto
    .TemaCorJanelaTitulo: dw TipoCor.CianoClaro | TipoCorFundo.Preto
    .TemaCorJanelaBorda: dw TipoCor.Ciano | TipoCorFundo.Preto
    .TemaCorTela: dw TipoCor.Preto | TipoCorFundo.Ciano
    .TemaCaractereTela: dw 177


_interface:
    push ax
    push di
    mov ax, cs
    mov es, ax
    mov di, Interface.Tela
    cs call far [Interface.ConfigTela]
    es call far [di+ObjControle.FuncRenderiza]
    cs call far [VideoTexto.Atualiza]
    mov si, Interface.SemaforoFoco
    cs call far [Semaforo.Cria]
    pop di
    pop ax
    retf

_interfaceAloca:
    push ax
    push bx
    push cx
    push dx
    cmp cx, 0xfff0 / ObjControle._Tam
    jb .ok
        clc
        jmp .fim
    .ok:
    mov ax, ObjControle._Tam
    mov bx, cx
    mul cx
    mov cx, ax
    add cx, 2
    cs call far [HUSIS.ProcessoAtual]
    cs call far [Memoria.AlocaRemoto]
    jnc .fim
        es mov word [0], bx
        mov di, 2
        stc
    .fim:
    pop dx
    pop cx
    pop bx
    pop ax
    retf

_interfaceItem:
    push ax
    push cx
    push dx
    es cmp cx, [0]
    jb .ok
        clc
        jmp .fim
    .ok:
    mov ax, ObjControle._Tam
    mul cx
    add ax, 2
    mov di, ax
    stc
    .fim:
    pop dx
    pop cx
    pop ax
    retf

_interfaceAlteraPosicao:
    es mov [di+ObjControle.X1], ax
    es mov [di+ObjControle.Y1], bx
    stc
    retf

_interfaceAlteraPosicao2:
    es mov [di+ObjControle.X2], ax
    es mov [di+ObjControle.Y2], bx
    stc
    retf

_interfaceAlteraTamanho:
    push ax
    push bx
    es add ax, [di+ObjControle.X1]
    es add bx, [di+ObjControle.Y1]
    es mov [di+ObjControle.X2], ax
    es mov [di+ObjControle.Y2], bx
    pop bx
    pop ax
    stc
    retf

_interfaceAlteraLargura:
    push ax
    es add ax, [di+ObjControle.X1]
    es mov [di+ObjControle.X2], ax
    pop ax
    stc
    retf

_interfaceAlteraAltura:
    push bx
    es add bx, [di+ObjControle.Y1]
    es mov [di+ObjControle.Y2], bx
    pop bx
    stc
    retf

_interfaceAlteraPrincipal:
    push ds
    es pop word [di+ObjControle.PtrConteudo + 2]
    es mov [di+ObjControle.PtrConteudo], si
    stc
    retf

_interfaceAlteraAuxiliar:
    push ds
    es pop word [di+ObjControle.PtrAuxiliar + 2]
    es mov [di+ObjControle.PtrAuxiliar], si
    stc
    retf

_interfaceAlteraPrincipalTrad:
    push bp
    mov bp, sp
    push ax
    push ds
    mov ax, [bp+4]
    mov ds, ax
    es mov [di+ObjControle.PtrConteudo + 2], ax
    mov ax, [si]
    add ax, [Prog.Traducao]
    es mov [di+ObjControle.PtrConteudo], ax
    stc
    pop ds
    pop ax
    pop bp
    retf

_interfaceAlteraAuxiliarTrad:
    push bp
    mov bp, sp
    push ax
    push ds
    mov ax, [bp+4]
    mov ds, ax
    es mov [di+ObjControle.PtrAuxiliar + 2], ax
    mov ax, [si]
    add ax, [Prog.Traducao]
    es mov [di+ObjControle.PtrAuxiliar], ax
    stc
    pop ds
    pop ax
    pop bp
    retf

_interfaceAlteraPrincipalConst:
    push bp
    mov bp, sp
    push ax
    mov ax, [bp+4]
    es mov [di+ObjControle.PtrConteudo + 2], ax
    es mov [di+ObjControle.PtrConteudo], si
    stc
    pop ax
    pop bp
    retf

_interfaceAlteraAuxiliarConst:
    push bp
    mov bp, sp
    push ax
    mov ax, [bp+4]
    es mov [di+ObjControle.PtrAuxiliar + 2], ax
    es mov [di+ObjControle.PtrAuxiliar], si
    stc
    pop ax
    pop bp
    retf

_interfaceAlteraAcao:
    push bp
    mov bp, sp
    push ax
    mov ax, [bp+4]
    es mov [di+ObjControle.FuncAcao + 2], ax
    es mov [di+ObjControle.FuncAcao], si
    stc
    pop ax
    pop bp
    retf

_interfaceAlteraAcaoAux:
    push bp
    mov bp, sp
    push ax
    mov ax, [bp+4]
    es mov [di+ObjControle.FuncAcaoAux + 2], ax
    es mov [di+ObjControle.FuncAcaoAux], si
    stc
    pop ax
    pop bp
    retf

_interfaceAlteraAcaoFoco:
    push bp
    mov bp, sp
    push ax
    mov ax, [bp+4]
    es mov [di+ObjControle.FuncAcaoFoco + 2], ax
    es mov [di+ObjControle.FuncAcaoFoco], si
    stc
    pop ax
    pop bp
    retf

_interfaceAlteraAcaoSemFoco:
    push bp
    mov bp, sp
    push ax
    mov ax, [bp+4]
    es mov [di+ObjControle.FuncAcaoSemFoco + 2], ax
    es mov [di+ObjControle.FuncAcaoSemFoco], si
    stc
    pop ax
    pop bp
    retf

__interfaceSolicitaAtualizacao:
    cs inc word [Interface.Solicitacoes]
    ret

; di = Valor
; ret: di << 8
__interfaceShl8DI:
    pushf
    push cx
    mov cl, 8
    shl di, cl
    pop cx
    popf
    ret

; es:di = ObjControle
__interfaceCalcIguala:
    push ax
    es mov ax, [di+ObjControle.X1]
    es mov [di+ObjControle.CalcX1], ax
    es mov ax, [di+ObjControle.Y1]
    es mov [di+ObjControle.CalcY1], ax
    es mov ax, [di+ObjControle.X2]
    es mov [di+ObjControle.CalcX2], ax
    es mov ax, [di+ObjControle.Y2]
    es mov [di+ObjControle.CalcY2], ax
    stc
    pop ax
    ret

; ds:si = ObjControle Acima
; es:di = ObjControle Abaixo
__interfaceCalcAcimaAbaixo:
    push ax
    push bx
    mov ax, [si+ObjControle.CalcX1]
    add ax, [si+ObjControle.MargemX1]
    mov bx, ax
    es add ax, [di+ObjControle.X1]
    es mov [di+ObjControle.CalcX1], ax
    mov ax, [si+ObjControle.CalcX2]
    sub ax, [si+ObjControle.MargemX2]
    es add bx, [di+ObjControle.X2]
    cmp bx, ax
    jbe .xOk
        mov bx, ax
    .xOk:
    es mov [di+ObjControle.CalcX2], bx
    es cmp bx, [di+ObjControle.CalcX1]
    jae .limiteXOk
        clc
        jmp .fim
    .limiteXOk:
    mov ax, [si+ObjControle.CalcY1]
    add ax, [si+ObjControle.MargemY1]
    mov bx, ax
    es add ax, [di+ObjControle.Y1]
    es mov [di+ObjControle.CalcY1], ax
    mov ax, [si+ObjControle.CalcY2]
    sub ax, [si+ObjControle.MargemY2]
    es add bx, [di+ObjControle.Y2]
    cmp bx, ax
    jbe .yOk
        mov bx, ax
    .yOk:
    es mov [di+ObjControle.CalcY2], bx
    es cmp bx, [di+ObjControle.CalcY1]
    jae .limiteYOk
        clc
        jmp .fim
    .limiteYOk:
    stc
    .fim:
    pop bx
    pop ax
    ret

; es:0 = Bloco de Controles Alocado
; es:di = ObjControle Atual/Acima
; ret: cf = 1=Ok | 0=Estouro da Lista
;      es:di = Novo item da lista
_interfaceCriaItem:
    push ax
    push bx
    push si
    mov si, di
    es mov cx, [0]
    mov di, 2
    xor bx, bx
    .pesquisa:
        es mov ax, [di+ObjControle.Tipo]
        cmp ax, TipoControle.Indefinido
        je .encontrado
        add di, ObjControle._Tam
        inc bx
        loop .pesquisa
    clc
    jmp .fim
    .encontrado:
    mov cx, ObjControle._CapacidadeItens
    mov ax, si
    add si, ObjControle.Itens
    .pesquisaSub:
        es cmp word [si + 2], 0
        je .encontradoSub 
        add si, 4
        loop .pesquisaSub
    clc
    jmp .fim
    .encontradoSub:
    mov cx, bx
    mov bx, ax
    mov ax, es
    es mov [si+2], ax
    es mov [si], di
    mov si, bx
    es mov [di+ObjControle.PtrAcima+2], ax
    es mov [di+ObjControle.PtrAcima], bx
    es mov ax, [si+ObjControle.PtrTela+2]
    es mov bx, [si+ObjControle.PtrTela]
    es mov [di+ObjControle.PtrTela+2], ax
    es mov [di+ObjControle.PtrTela], bx
    es mov ax, [si+ObjControle.PtrJanela+2]
    es mov bx, [si+ObjControle.PtrJanela]
    es mov [di+ObjControle.PtrJanela+2], ax
    es mov [di+ObjControle.PtrJanela], bx
    es mov word [di+ObjControle.Visivel], 1
    stc
    .fim:
    pop si
    pop bx
    pop ax
    retf

; es:0 = Bloco de Controles Alocado
; ret: cf = 1=Ok | 0=Estouro da Lista
;      es:di = Novo item da lista
_interfaceCriaItemRaiz:
    push ax
    push bx
    push si
    push ds
    mov si, Interface.Tela
    push cs
    pop ds
    es mov cx, [0]
    mov di, 2
    xor bx, bx
    .pesquisa:
        es mov ax, [di+ObjControle.Tipo]
        cmp ax, TipoControle.Indefinido
        je .encontrado
        add di, ObjControle._Tam
        inc bx
        loop .pesquisa
    clc
    jmp .fim
    .encontrado:
    mov cx, ObjControle._CapacidadeItens
    mov ax, si
    add si, ObjControle.Itens
    .pesquisaSub:
        cmp word [si + 2], 0
        je .encontradoSub 
        add si, 4
        loop .pesquisaSub
    clc
    jmp .fim
    .encontradoSub:
    mov cx, bx
    mov bx, ax
    mov ax, es
    mov [si+2], ax
    mov [si], di
    es mov [di+ObjControle.PtrAcima+2], ax
    es mov [di+ObjControle.PtrAcima], bx
    es mov [di+ObjControle.PtrTela+2], ax
    es mov [di+ObjControle.PtrTela], bx
    es mov [di+ObjControle.PtrJanela+2], ax
    es mov [di+ObjControle.PtrJanela], di
    stc
    .fim:
    pop ds
    pop si
    pop bx
    pop ax
    retf

_interfaceRenderiza:
    push ax
    es cmp word [di+ObjControle.Visivel], 0
    je .fim
    es cmp word [di+ObjControle.FuncRenderiza + 2], 0
    je .fim
        es cmp word [di+ObjControle.Tipo], TipoControle.Tela
        je .ok
        es cmp word [di+ObjControle.Tipo], TipoControle.Janela
        je .ok
        push es
        push di
        cs call far [Interface.CarregaJanela]
        es mov ax, [di+ObjControle.Visivel]
        pop di
        pop es
        cmp ax, 0
        je .fim
        es cmp word [di+ObjControle.CalcX2], 0
        jne .ok
            push es
            push di
            cs call far [Interface.CarregaJanela]
            cs call far [Interface.Renderiza]
            pop di
            pop es
            jmp .fim
        .ok:
        es call far [di+ObjControle.FuncRenderiza]
        call __interfaceSolicitaAtualizacao
    .fim:
    stc
    pop ax
    retf

_interfaceExibe:
    push ax
    push bx
    es cmp word [di+ObjControle.Visivel], 0
    jne .jaVisivel
        es mov word [di+ObjControle.Visivel], 1
        es cmp word [di+ObjControle.Tipo], TipoControle.Janela
        jne .jaVisivel
            push es
            push di
            es mov ax, [di+ObjControle.PtrObjEmFoco + 2]
            cmp ax, 0
            je .ignoraFoco
                es mov bx, [di+ObjControle.PtrObjEmFoco]
                mov es, ax
                mov di, bx
                es cmp word [di+ObjControle.Visivel], 0
                je .ignoraFoco
                    cs call far [Interface.EntraEmFoco]
            .ignoraFoco:
            pop di
            pop es
    .jaVisivel:
        cs call far [Interface.Renderiza]
    .fim:
    pop bx
    pop ax
    retf

_interfaceOculta:
    push es
    push di
    push ax
    es mov word [di+ObjControle.Visivel], 0
    es mov ax, [di+ObjControle.PtrAcima+2]
    es mov di, [di+ObjControle.PtrAcima]
mov ax, cs
mov si, Interface.Tela

    mov es, ax
    cs call far [Interface.Renderiza]
    pop ax
    pop di
    pop es
    retf

_interfaceAcima:
    push ax
    es cmp word [di+ObjControle.PtrAcima+2], 0
    jne .ok
        clc
        jmp .fim
    .ok:
        es mov ax, [di+ObjControle.PtrAcima+2]
        es mov di, [di+ObjControle.PtrAcima]
        mov es, ax
        stc
    .fim:
    pop ax
    retf

_interfaceJanela:
    push ax
    es cmp word [di+ObjControle.PtrJanela+2], 0
    jne .ok
        clc
        jmp .fim
    .ok:
        es mov ax, [di+ObjControle.PtrJanela+2]
        es mov di, [di+ObjControle.PtrJanela]
        mov es, ax
        stc
    .fim:
    pop ax
    retf

_interfaceTela:
    push ax
    es cmp word [di+ObjControle.PtrTela+2], 0
    jne .ok
        clc
        jmp .fim
    .ok:
        es mov ax, [di+ObjControle.PtrTela+2]
        es mov di, [di+ObjControle.PtrTela]
        mov es, ax
        stc
    .fim:
    pop ax
    retf

; cx = Sub Controle
_interfaceSubControle:
    push ax
    push bx
    mov bx, cx
    shl bx, 1
    shl bx, 1
    es cmp word [di+bx+ObjControle.Itens], 0
    jne .ok
        clc
        jmp .fim
    .ok:
        es mov ax, [di+bx+ObjControle.Itens+2]
        es mov di, [di+bx+ObjControle.Itens]
        mov es, ax
        stc
    .fim:
    pop bx
    pop ax
    retf

; es:di = ObjControle
__interfaceRenderizaSubItens:
    push ds
    push si
    push es
    push di
    push ax 
    push bx
    push cx
    push dx


    push es
    pop bx
    push es
    pop ds
    mov si, di
    mov dx, si
    add si, ObjControle.Itens
    mov cx, ObjControle._CapacidadeItens
    .subItens:
        lodsw
        mov di, ax
        lodsw
        cmp ax, 0
        je .ignoraSubItem
        mov es, ax
        es cmp word [di+ObjControle.FuncRenderiza+2], 0
        je .ignoraSubItem
            push si
            push ds
            push bx
            pop ds
            mov si, dx
            es cmp word [di+ObjControle.Visivel],0
            je .foraDosParametros
            call __interfaceCalcAcimaAbaixo
            jnc .foraDosParametros
                es call far [di+ObjControle.FuncRenderiza]
            .foraDosParametros:
            pop ds
            pop si
        .ignoraSubItem:
        loop .subItens
    stc
    pop dx
    pop cx
    pop bx
    pop ax
    pop di
    pop es
    pop si
    pop ds
    ret



__interfaceExecutaAcao:
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    push ds
    push si
    es cmp word [di+ObjControle.FuncAcao + 2], 0
    je .fim
        es call far [di+ObjControle.FuncAcao]
    .fim:
    pop si
    pop ds
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    ret

__interfaceExecutaAcaoAux:
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    push ds
    push si
    es cmp word [di+ObjControle.FuncAcaoAux + 2], 0
    je .fim
        es call far [di+ObjControle.FuncAcaoAux]
    .fim:
    pop si
    pop ds
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    ret

__interfaceExecutaAcaoFoco:
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    push ds
    push si
    es cmp word [di+ObjControle.FuncAcaoFoco + 2], 0
    je .fim
        es call far [di+ObjControle.FuncAcaoFoco]
    .fim:
    pop si
    pop ds
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    ret

__interfaceExecutaAcaoSemFoco:
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    push ds
    push si
    es cmp word [di+ObjControle.FuncAcaoSemFoco + 2], 0
    je .fim
        es call far [di+ObjControle.FuncAcaoSemFoco]
    .fim:
    pop si
    pop ds
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    ret

_interfaceEntraEmFoco:
    push si
    push ax
    push bx
    push es
    push di
    mov si, Interface.SemaforoFoco
    cs call far [Semaforo.Solicita]
    mov ax, es
    mov bx, di
    push es
    push di
    cs call far [Interface.CarregaJanela]
    es mov [di+ObjControle.PtrObjEmFoco + 2], ax
    es mov [di+ObjControle.PtrObjEmFoco], bx
    pop di
    pop es
    es cmp word [di+ObjControle.Visivel], 0
    je .fim
        cs cmp word [Interface.ObjEmFoco + 2], 0
        je .ignoraRetirada
            push ax
            push bx
            push cx
            push dx
            push es
            push di
            mov cx, ax
            mov dx, bx
            cs mov ax, [Interface.ObjEmFoco + 2]
            cs mov bx, [Interface.ObjEmFoco]
            cs mov [Interface.ObjEmFoco + 2], cx
            cs mov [Interface.ObjEmFoco], dx
            mov es, ax
            mov di, bx
            mov si, Interface.SemaforoFoco
            cs call far [Semaforo.Libera]
            es cmp word [di+ObjControle.FuncSaiDoFoco + 2],0
            je .ignoraSaida
                es call far [di+ObjControle.FuncSaiDoFoco]
                jnc .ignoraRenderizaSaida
            .ignoraSaida:
            cs call far [Interface.Renderiza]
            .ignoraRenderizaSaida:
            mov si, Interface.SemaforoFoco
            cs call far [Semaforo.Solicita]
            pop di 
            pop es
            pop dx
            pop cx
            pop bx
            pop ax  
            cs cmp [Interface.ObjEmFoco + 2], ax
            jne .fim
            cs mov [Interface.ObjEmFoco], bx
            jne .fim
        .ignoraRetirada:
        cs mov [Interface.ObjEmFoco + 2], ax
        cs mov [Interface.ObjEmFoco], bx
        push es
        push di
        mov es, ax
        mov di, bx
        mov si, Interface.SemaforoFoco
        cs call far [Semaforo.Libera]
        es cmp word [di+ObjControle.FuncEntraNoFoco + 2], 0
        je .ignoraEntrada
            es call far [di+ObjControle.FuncEntraNoFoco]
            jnc .ignoraRenderizaEntrada
        .ignoraEntrada:
        mov si, Interface.SemaforoFoco
        cs call far [Semaforo.Solicita]
        cs call far [Interface.Renderiza]
        .ignoraRenderizaEntrada:
        pop di
        pop es
    .fim:
    mov si, Interface.SemaforoFoco
    cs call far [Semaforo.Libera]
    stc
    pop di
    pop es
    pop bx
    pop ax
    pop si
    retf

_interfaceLimpaFoco:
    push si
    mov si, Interface.SemaforoFoco
    cs call far [Semaforo.Solicita]
    cs mov word [Interface.ObjEmFoco + 2], 0
    cs mov word [Interface.ObjEmFoco], 0
    mov si, Interface.SemaforoFoco
    cs call far [Semaforo.Libera]
    pop si
    retf

_interfaceProcessaTecla:
    push ax
    push bx
    push cx
    push dx
    push ds
    push si
    push es
    push di
    push si
    mov si, Interface.SemaforoFoco
    cs call far [Semaforo.Solicita]
    pop si
    push ax
    cs mov ax, [Interface.ObjEmFoco + 2]
    mov es, ax
    pop ax
    cs mov di, [Interface.ObjEmFoco]
    es cmp word [di+ObjControle.FuncProcessaTecla], 0
    je .fim
        es call far [di+ObjControle.FuncProcessaTecla]
        jnc .fim
            cs call far [Interface.Renderiza]
    .fim:
    mov si, Interface.SemaforoFoco
    cs call far [Semaforo.Libera]
    pop di
    pop es
    pop si
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax
    retf

_interfaceProcessaMouse:
    cli
    retf

; es:di = ObjControle
__interfaceVerificaFoco:
    push ax
    mov ax, es
    cs cmp [Interface.ObjEmFoco + 2], ax
    jne .nao
    cs cmp [Interface.ObjEmFoco], di
    jne .nao
        stc
        jmp .fim
    .nao:
        clc
    .fim:
    pop ax
    ret

; es:di = ObjControle
; ret: cx = Posicao
__interfacePosicaoAtual:
    push ds
    push si
    push ax
    push bx
    push dx
    es mov ax, [di+ObjControle.PtrAcima + 2]
    mov ds, ax
    es mov si, [di+ObjControle.PtrAcima]
    add si, ObjControle.Itens
    mov cx, ObjControle._CapacidadeItens
    xor dx, dx
    .busca:
        lodsw
        mov bx, ax
        lodsw
        cmp bx, di
        jne .diferente
        mov bx, ax
        mov ax, es
        cmp ax, bx
        je .encontrado
        .diferente:        
        inc dx
        loop .busca
    xor cx, cx
    clc
    jmp .fim
    .encontrado:
    mov cx, dx
    stc
    .fim:
    pop dx
    pop bx
    pop ax
    pop si
    pop ds
    ret


; es:di = ObjControle
; ret: cx = Posicao do proximo item nesta hierarquia
__interfacePosicaoProx:
    push ds
    push si
    push ax
    push bx
    push dx
    es mov ax, [di+ObjControle.PtrAcima + 2]
    mov ds, ax
    es mov si, [di+ObjControle.PtrAcima]
    mov bx, si
    add si, ObjControle.Itens
    mov cx, ObjControle._CapacidadeItens
    xor dx, dx
    .busca:
        push bx
        lodsw
        mov bx, ax
        lodsw
        cmp ax, 0
        jne .diferente
        cmp bx, di
        jne .diferente
            mov bx, ax
            mov ax, es
            cmp ax, bx
            je .encontrado
        .diferente:     
        pop bx   
        inc dx
        loop .busca  
    .naoEncontrado:
    mov si, bx
    cmp word [si+ObjControle.Tipo], TipoControle.Janela
    jne .naoEncontradoFinal
        add si, ObjControle.Itens
        xor dx, dx
        lodsw
        mov bx, ax
        lodsw
        cmp ax, 0
        jne .encontradoFinal
    .naoEncontradoFinal:
    xor cx, cx
    clc
    jmp .fim
    .encontrado:
    pop cx
    lodsw
    mov bx, ax
    lodsw
    inc dx
    cmp ax, 0
    jne .encontradoFinal
        mov bx, cx
        jmp .naoEncontrado
    .encontradoFinal:
    mov es, ax
    mov di, bx
    mov cx, dx
    stc
    .fim:
    pop dx
    pop bx
    pop ax
    pop si
    pop ds
    ret

__interfacePosicaoProxAcima:
    push es
    push di
    push ax
    es mov ax, [di+ObjControle.PtrAcima + 2]
    mov es, ax
    es mov di, [di+ObjControle.PtrAcima]
    call __interfacePosicaoProx
    pop ax
    pop di
    pop es
    retf

__interfaceTab:
    push ax
    push cx
    push es
    push di
    cs cmp word [Interface.ObjEmFoco + 2], 0
    je .selecionaTela
    cs mov ax, [Interface.ObjEmFoco + 2]
    mov es, ax
    cs mov di, [Interface.ObjEmFoco]
    call __interfacePosicaoProx
    jc .ok
        .selecionaTela:
        push cs
        pop es
        mov di, Interface.Tela
        jmp .ok
    .ok:
    cs call far [Interface.EntraEmFoco]
    pop di
    pop es
    pop cx
    pop ax
    ret

_interfaceExclui:
    cs call far [Interface.Oculta]
    push ds
    push si
    push ax
    push bx
    push cx
    push dx
    es mov ax, [di+ObjControle.PtrAcima + 2]
    mov ds, ax
    es mov si, [di+ObjControle.PtrAcima]
    add si, ObjControle.Itens
    mov cx, ObjControle._CapacidadeItens
    .busca:
        lodsw
        mov bx, ax
        lodsw
        cmp bx, di
        jne .diferente
            mov bx, ax
            mov ax, es
            cmp ax, bx
            je .encontrado
        .diferente:
        loop .busca
    clc
    jmp .fim
    .encontrado:
    sub si, 4
    mov word [si], 0
    mov word [si + 2], 0
    stc
    .fim:
    pop dx
    pop cx
    pop bx
    pop ax
    pop si
    pop ds
    retf

inicial:
    cs call far [Teclado]
    cs call far [VideoTexto]
    cs call far [Interface]
    cs mov word [Interface.Solicitacoes], 0
    .loop:
        cs cmp word [Interface.Solicitacoes], 0
        je .ignora
            cs mov word [Interface.Solicitacoes], 0
            cs call far [VideoTexto.Atualiza]
        .ignora:
        cs call far [Teclado.Disponivel]
        jnc .ignoraTeclado
            cs call far [Teclado.Leia]
            jnc .ignoraTeclado
                cmp bx, TipoTeclaEspecial.Tab
                jne .naoTab
                    call __interfaceTab
                    jmp .ignoraTeclado
                .naoTab:
                cs call far [Interface.ProcessaTecla]
        .ignoraTeclado:
        cs call far [HUSIS.ProximaTarefa]
        jmp .loop
    retf

Trad: dw 0