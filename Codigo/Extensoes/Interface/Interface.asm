; ====================
;  Interface com o Usuario
; ====================
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
%include '../../Incluir/Prog.asm'

nome: db 'Interface',0
versao: dw 0,1,1
tipo: dw TipoProg.Executavel
modulos:
    dw Interface
    dw VideoTexto
    dw 0
    %include 'VideoTexto.asm'
    %include 'VideoTextoCGA.asm'
    %include 'CtlTela.asm'
    %include 'CtlJanela.asm'
    %include 'CtlRotulo.asm'
importar:
    %include '../../Incluir/Texto.asm'
    %include '../../Incluir/Memoria.asm'
    %include '../../Incluir/HUSIS.asm'
    %include '../../Incluir/ObjControle.asm'
    dw 0
exportar:
    dw 0


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
        ;      es:di = Novo item da lista
    .CriaItemRaiz: dw _interfaceCriaItemRaiz,0
        ; Cria um item na tela
        ; es:0 = Bloco de Controles Alocado
        ; ret: cf = 1=Ok | 0=Estouro da Lista
        ;      es:di = Novo item da lista
    .ConfigTela: dw _tela,0
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
    .ConfigJanela: dw _janela,0
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
    .ConfigRotulo: dw _rotulo,0
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
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
    dw 0
    .Solicitacoes: dw 0
    .Tela: times ObjControle._Tam db 0
    .TemaCorFrente: dw TipoCor.Ciano | TipoCorFundo.Preto
    .TemaCorDestaque: dw TipoCor.Branco | TipoCorFundo.Preto
    .TemaCorBotaoFechar: dw TipoCor.VermelhoClaro | TipoCorFundo.Preto
    .TemaCorBorda: dw TipoCor.Cinza | TipoCorFundo.Preto
    .TemaCorFundo: dw TipoCor.Cinza | TipoCorFundo.Preto
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
    es call far [di+ObjControle.PtrRenderiza]
    cs call far [VideoTexto.Atualiza]
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
    mov ax, si
    add ax, [Prog.Traducao]
    es mov [di+ObjControle.PtrConteudo], ax
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
    mov ax, si
    add ax, [Prog.Traducao]
    es mov [di+ObjControle.PtrAuxiliar], ax
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
    es cmp word [di+ObjControle.Visivel], 0
    je .fim
    es cmp word [di+ObjControle.PtrRenderiza + 2], 0
    je .fim
        es call far [di+ObjControle.PtrRenderiza]
    .fim:
    stc
    retf

_interfaceExibe:
    es mov word [di+ObjControle.Visivel], 1
    cs call far [Interface.Renderiza]
    retf

_interfaceOculta:
    push es
    push di
    push ax
    es mov word [di+ObjControle.Visivel], 0
    es mov ax, [di+ObjControle.PtrAcima+2]
    es mov di, [di+ObjControle.PtrAcima]
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
        es cmp word [di+ObjControle.PtrRenderiza+2], 0
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
                es call far [di+ObjControle.PtrRenderiza]
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

inicial:
    cs call far [VideoTexto]
    cs call far [Interface]

    mov cx, 10
    cs call far [Interface.Aloca]
    jnc .erro
    cs call far [Interface.CriaItemRaiz]
    jnc .erro
    cs call far [Interface.ConfigJanela]
    jnc .erro
    mov ax, 10
    mov bx, 10
    cs call far [Interface.AlteraPosicao]
    jnc .erro
    mov ax, 40
    mov bx, 20
    cs call far [Interface.AlteraPosicao2]
    jnc .erro
    mov si, .constTeste
    cs call far [Interface.AlteraPrincipalConst]
    jnc .erro

    cs call far [Interface.CriaItem]
    jnc .erro

    cs call far [Interface.ConfigRotulo]
    mov ax, 0
    mov bx, 0
    cs call far [Interface.AlteraPosicao]
    jnc .erro
    mov ax, 5
    mov bx, 5
    cs call far [Interface.AlteraTamanho]
    jnc .erro
    mov si, .constTeste
    cs call far [Interface.AlteraPrincipalConst]
    jnc .erro

    cs call far [Interface.CarregaJanela]
    jnc .erro
    cs call far [Interface.Exibe]
    jnc .erro
    mov cx, 0
    cs call far [Interface.CarregaSubControle]
    jnc .erro
    ;cs call far [Interface.Oculta]
    ;jnc .erro

    jmp .loop
    .erro:
    cs call far [HUSIS.Debug]
    .loop:
        cs cmp word [Interface.Solicitacoes], 0
        je .ignora
            cs mov word [Interface.Solicitacoes], 0
            cs call far [VideoTexto.Atualiza]
        .ignora:
        cs call far [HUSIS.ProximaTarefa]
        jmp .loop
    retf
    .constTeste: db 'Teste 123 123 123 123 132 123 123 123 123',0

Trad: