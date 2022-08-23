%include '../../Incluir/Prog.asm'

nome: db 'Interface',0
versao: dw 0,1,1
tipo: dw TipoProg.Executavel
modulos:
    dw Interface
    dw 0



    %include 'FontePipoca.asm'
    %include '../../Incluir/ObjFonte.asm'
    %include '../../Incluir/ObjControle.asm'
    %include 'CtlRotulo.asm'

importar:
    %include '../../Incluir/Texto.asm'
    %include '../../Incluir/Memoria.asm'
    %include '../../Incluir/HUSIS.asm'
    dw 0
exportar:
    dw Interface
    db 'Interface',0
    dw 0

Interface: dw _interface, 0
    .RegistraTela: dw _interfaceRegistraTela,0
        ; Registra a tela (Inicialmente apenas suporta uma)
        ; O Buffer eh opcional, neste caso a rotina dx deve apenas retornar 
        ; cf=1 apenas efetuando a limpeza via os parametros
        ; ax = Segmento das rotinas
        ; bx = Rotina de desenho um caractere no buffer
        ;      cx = X
        ;      dx = Y
        ;      ax = Cor
        ;      ret: cf = 1=Ok | 0=Falha
        ; cx = Quantidade de cores
        ; dx = Rotina que atualiza a tela com o buffer / limpa tela
        ;      ax = Acao:
        ;           0 = Atualiza a tela com o buffer
        ;           1 = Limpa a tela e o buffer
        ;           2 = Limpa o buffer
        ;      ret: cf = 1=Ok | 0=Falha
        ; si = Largura em Pixels
        ; di = Altura em Pixels
        ; ret: cf = 1=Ok | 0=Falha
    .DesenhaCaractere: dw _interfaceDesenhaCaractere,0
        ; Desenha um caractere
        ; cx = X
        ; dx = Y
        ; ah = Cor
        ; al = Caractere
        ; ret: cf = 1=Ok | 0=Falha
    .DesenhaFundoRemoto: dw _interfaceDesenhaFundoRemoto, 0
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
    .AlocaControleRemoto: dw _interfaceAlocaControleRemoto,0
        ; ret: cf = 1=Ok | 0=Falha
        ;      es:di = ObjControle
    .LiberaControleRemoto: dw _interfaceLiberaControleRemoto,0
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraPosInicialRemoto: dw _interfaceAlteraPosInicialRemoto, 0
        ; es:di = ObjControle
        ; cx = X1
        ; dx = Y1
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraPosFinalRemoto: dw _interfaceAlteraPosFinalRemoto, 0
        ; es:di = ObjControle
        ; cx = X2
        ; dx = Y2
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraConteudoRemoto: dw _interfaceAlteraConteudoRemoto, 0
        ; es:di = ObjControle
        ; ds:si = Novo conteudo
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraValorARemoto: dw _interfaceAlteraValorARemoto, 0
        ; es:di = ObjControle
        ; ax = Valor A
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraValorBRemoto: dw _interfaceAlteraValorBRemoto, 0
        ; es:di = ObjControle
        ; bx = Valor B
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraValorCRemoto: dw _interfaceAlteraValorCRemoto, 0
        ; es:di = ObjControle
        ; cx = Valor C
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraValorDRemoto: dw _interfaceAlteraValorDRemoto, 0
        ; es:di = ObjControle
        ; dx = Valor D
        ; ret: cf = 1=Ok | 0=Falha
    .RenderizaRemoto: dw _interfaceRenderizaRemoto, 0
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
    .ExibeRemoto: dw _interfaceExibeRemoto, 0
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
    .OcultaRemoto: dw _interfaceOcultaRemoto, 0
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
    .IniciaRemoto: dw _interfaceIniciaRemoto, 0
        ; Inicia um objeto em branco
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
    .IniciaRotuloRemoto: dw _interfaceIniciaRotuloRemoto,0
        ; es:di = ObjControle
        ; ds:si = Texto
        ; ret: cf = 1=Ok | 0=Falha
    dw 0
    .PtrDesenhaCaractere: dw 0, 0
    .PtrAtualizaTela: dw 0, 0
    .Largura: dw 0
    .Altura: dw 0
    .Cores: dw 0
    .PtrBuffer: dw 0
    ._CapacidadeFontes: equ 32
    .Fontes: times ._CapacidadeFontes dw 0,0
    ._CapacidadeJanelas: equ 32
    .Janelas: times ._CapacidadeJanelas dw 0,0
    .JanelaAtual: dw 0

_interface:
    mov ax, FontePipoca
    cs mov [Interface.Fontes], ax
    mov ax, cs
    cs mov [Interface.Fontes+2], ax
    

    mov si, 80
    mov di, 25
    mov ax, cs
    mov bx, _interfaceTempDesenhaCaractere
    mov cx, 16
    mov dx, _interfaceTempAtualizaBuffer
    cs call far [Interface.RegistraTela]

    retf

_interfaceTempDesenhaCaractere:
    push ds
    push ax
    push bx
    push cx
    push dx

    push ax
    mov ax, 0xb800
    mov ds, ax
    mov ax, dx
    mov bx, 160
    mul bx
    add ax, cx
    add ax, cx
    mov bx, ax
    pop ax
    mov [bx], ax

    stc

    pop dx
    pop cx
    pop bx
    pop ax
    pop ds
    retf

_interfaceTempAtualizaBuffer:
    mov ax, 3
    int 0x10
    retf

_interfaceDesenhaFundoRemoto:
    push ax
    push bx
    push cx
    push dx
    es mov cx, [di+ObjControle.X1]
    es mov dx, [di+ObjControle.Y1]
    es mov ah, [di+ObjControle.CorFundo]
    mov al, ' '
    .vert:
        es cmp dx, [di+ObjControle.Y2]
        ja .fim
        es mov bx, [di+ObjControle.X2]
        .horiz:
            cmp cx, bx
            ja .continua
            cs call far [Interface.DesenhaCaractere]
            inc cx
            jmp .horiz
        .continua:
            inc dx
            jmp .vert
    .fim:
    pop dx
    pop cx
    pop bx
    pop ax
    retf

_interfaceExibeRemoto:
    es mov word [di+ObjControle.Visivel], 1
    cs call far [Interface.RenderizaRemoto]
    retf

_interfaceOcultaRemoto:
    es mov word [di+ObjControle.Visivel], 0
    retf

_interfaceIniciaRemoto:
    push ax
    es mov word [di+ObjControle.Janela], 0
    es mov word [di+ObjControle.PtrAcima], 0
    es mov word [di+ObjControle.PtrAcima+2], 0
    es mov word [di+ObjControle.PtrAbaixo], 0
    es mov word [di+ObjControle.PtrAbaixo+2], 0
    es mov word [di+ObjControle.PtrProximo], 0
    es mov word [di+ObjControle.PtrProximo+2], 0
    es mov word [di+ObjControle.PtrConteudo], 0
    es mov word [di+ObjControle.PtrConteudo+2], 0
    es mov word [di+ObjControle.PtrRenderiza], 0
    es mov word [di+ObjControle.PtrRenderiza+2], 0
    es mov word [di+ObjControle.PtrFonte], FontePipoca
    mov ax, cs
    es mov [di+ObjControle.PtrFonte+2], ax
    es mov word [di+ObjControle.ValorA], 0
    es mov word [di+ObjControle.ValorB], 0
    es mov word [di+ObjControle.ValorC], 0
    es mov word [di+ObjControle.ValorD], 0
    es mov word [di+ObjControle.Visivel], 0
    es mov word [di+ObjControle.CorFrente], TipoCor.Branco
    es mov word [di+ObjControle.CorFundo], TipoCor.Preto
    es mov word [di+ObjControle.Tipo], TipoControle.Indefinido
    stc
    pop ax
    retf

_interfaceAlteraValorARemoto:
    es mov [di+ObjControle.ValorA], ax
    cs call far [Interface.RenderizaRemoto]
    retf

_interfaceAlteraValorBRemoto:
    es mov [di+ObjControle.ValorB], bx
    cs call far [Interface.RenderizaRemoto]
    retf

_interfaceAlteraValorCRemoto:
    es mov [di+ObjControle.ValorC], cx
    cs call far [Interface.RenderizaRemoto]
    retf

_interfaceAlteraValorDRemoto:
    es mov [di+ObjControle.ValorD], dx
    cs call far [Interface.RenderizaRemoto]
    retf

_interfaceAlteraConteudoRemoto:
    push ax
    mov ax, ds
    es mov [di+ObjControle.PtrConteudo+2], ax
    es mov [di+ObjControle.PtrConteudo], si
    cs call far [Interface.RenderizaRemoto]
    pop ax
    stc
    retf

_interfaceAlteraPosFinalRemoto:
    es mov [di+ObjControle.X2], cx
    es mov [di+ObjControle.Y2], dx
    cs call far [Interface.RenderizaRemoto]
    retf

_interfaceAlteraPosInicialRemoto:
    es mov [di+ObjControle.X1], cx
    es mov [di+ObjControle.Y1], dx
    cs call far [Interface.RenderizaRemoto]
    retf

_interfaceRenderizaRemoto:
    push ax
    es cmp word [di+ObjControle.PtrRenderiza], 0
    je .falha
    es cmp word [di+ObjControle.Visivel], 0
    je .ok
    cs mov ax, [Interface.JanelaAtual]
    es cmp ax, [di+ObjControle.Janela]
    jne .ok
    es mov ax, [di+ObjControle.X2]
    es cmp ax, [di+ObjControle.X1]
    jb .falha
    es mov ax, [di+ObjControle.Y2]
    es cmp ax, [di+ObjControle.Y1]
    jb .falha
    es call far [di+ObjControle.PtrRenderiza]
    .ok:
    stc
    jmp .fim
    .falha:
    clc
    .fim:
    pop ax
    retf

_interfaceDesenhaCaractere:
    clc
    retf
    times 50 nop
    .inicio:
    cs push word [Interface.PtrDesenhaCaractere+2]
    cs push word [Interface.PtrDesenhaCaractere]
    retf
    .fim:

_interfaceRegistraTela:
    push ds
    push es
    push si
    push di
    push cx
    cs mov [Interface.Cores], cx
    cs mov [Interface.Largura], si
    cs mov [Interface.Altura], di
    cs mov [Interface.PtrDesenhaCaractere+2], ax
    cs mov [Interface.PtrDesenhaCaractere], bx
    cs mov [Interface.PtrAtualizaTela+2], ax
    cs mov [Interface.PtrAtualizaTela], dx
    push cs
    pop ds
    push cs
    pop es
    mov si, _interfaceDesenhaCaractere.inicio
    mov di, _interfaceDesenhaCaractere
    mov cx, _interfaceDesenhaCaractere.fim - _interfaceDesenhaCaractere.inicio
    rep movsb
    stc
    pop cx
    pop di
    pop si
    pop es
    pop ds
    retf

_interfaceAlocaControleRemoto:
    push ax
    push cx
    cs call far [HUSIS.ProcessoAtual]
    mov cx, ObjControle._Tam
    cs call far [Memoria.AlocaRemoto]
    pop cx
    pop ax
    retf

_interfaceLiberaControleRemoto:
    cs call far [Memoria.LiberaRemoto]
    retf

__interfacePtrConteudoLocal:
    push ax
    es cmp word [di+ObjControle.PtrConteudo], 0
    je .fim
        es mov ax, [di+ObjControle.PtrConteudo+2]
        mov ds, ax
        es mov si, [di+ObjControle.PtrConteudo]
        stc
    .fim:
    pop ax
    ret

__interfacePtrFonteLocal:
    push ax
    es cmp word [di+ObjControle.PtrFonte], 0
    je .fim
        es mov ax, [di+ObjControle.PtrFonte+2]
        mov ds, ax
        es mov si, [di+ObjControle.PtrFonte]
        stc
    .fim:
    pop ax
    ret


inicial:
    cs call far [Interface]
    .aguardaTela:
        cs cmp word [Interface.PtrDesenhaCaractere], 0
        je .continuaAguardando
        cs cmp word [Interface.PtrAtualizaTela], 0
        je .continuaAguardando
            mov ax, 1
            cs call far [Interface.PtrAtualizaTela]
            jmp .fimAguarda
        .continuaAguardando:
        cs call far [HUSIS.ProximaTarefa]
        jmp .aguardaTela
    .fimAguarda:
    cs call far [Interface.AlocaControleRemoto]
    push cs
    pop ds
    mov si, .teste
    cs call far [Interface.IniciaRotuloRemoto]
    mov cx, 10
    mov dx, 10
    cs call far [Interface.AlteraPosInicialRemoto]
    mov cx, 20
    mov dx, 12
    cs call far [Interface.AlteraPosFinalRemoto]
    cs call far [Interface.ExibeRemoto]
    cs call far [Interface.RenderizaRemoto]
    .processa:
        cs call far [HUSIS.ProximaTarefa]
        jmp .processa
    retf
    .teste: db 'Oieeee 123 asdsdkkknncdisncdijscnsjcndsk',0

Trad: dw 0