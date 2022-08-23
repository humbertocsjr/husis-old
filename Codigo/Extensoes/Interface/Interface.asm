; =========================
;  Interface com o usuario
; =========================
;
; Prototipo........: 22/08/2022
; Versao Inicial...: 23/08/2022
; Autor............: Humberto Costa dos Santos Junior
;
; Funcao...........: Interface com o usuario
;
; Limitacoes.......: 
;
; Historico........:
;
; - 22/08/2022 - Humberto - Prototipo inicial
; - 23/08/2022 - Humberto - Volta para interface de texto por limitacoes
;                           do hardware disponivel para teste
%include '../../Incluir/Prog.asm'

nome: db 'Interface',0
versao: dw 0,1,1
tipo: dw TipoProg.Executavel
modulos:
    dw Interface
    dw 0


; 23/08/2022 - Comentado na remocao do codigo da interface grafica
;    %include 'FontePipoca.asm'
    %include '../../Incluir/ObjFonte.asm'
    %include '../../Incluir/ObjControle.asm'
    %include 'CtlJanela.asm'
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

TipoBorda:
    .SupEsq: equ 218
    .InfDir: equ 217
    .SupDir: equ 191
    .InfEsq: equ 192
    .Horiz: equ 196
    .Vert: equ 179
    .HorizEsq: equ 195
    .HorizDir: equ 180
    .Central: equ 197
    .VertSup: equ 194
    .VertInf: equ 193

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
    .DesenhaCaixaRemoto: dw _interfaceDesenhaCaixaRemoto, 0
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
    .AlteraTamanhoRemoto: dw _interfaceAlteraTamanhoRemoto, 0
        ; es:di = ObjControle
        ; cx = Largura
        ; dx = Altura
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
    .AdicionarJanelaRemota: dw _interfaceAdicionarJanRemota,0
        ; Adiciona uma janela a raiz
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
    .AdicionarRemota: dw _interfaceAdicionarRemota,0
        ; Adiciona um controle a um outro controle/janela
        ; es:di = ObjControle Acima
        ; ds:si = ObjControle Abaixo
        ; ret: cf = 1=Ok | 0=Falha
    .CopiaPonteiroRemotoParaLocal: dw _interfaceCopiaPtr,0
        ; Copia es:di para ds:si de forma facil, ficando os dois identicos
        ; ret: cf = 1=Ok | 0=Falha
    .IniciaRemoto: dw _interfaceIniciaRemoto, 0
        ; Inicia um objeto em branco
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
    .IniciaRotuloRemoto: dw _interfaceIniciaRotuloRemoto,0
        ; es:di = ObjControle
        ; ds:si = Texto
        ; ret: cf = 1=Ok | 0=Falha
    .IniciaJanelaRemoto: dw _interfaceIniciaJanelaRemoto,0
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
    ; 23/08/2022 - Comentado na remocao do codigo da interface grafica
    ;._CapacidadeFontes: equ 32
    ;.Fontes: times ._CapacidadeFontes dw 0,0
    ._CapacidadeJanelas: equ 32
    .Janelas: times ._CapacidadeJanelas dw 0,0
    .JanelaAtual: dw 0
    .TemaCorBorda: dw TipoCor.Ciano
    .TemaCorTitulo: dw TipoCor.CianoClaro


_interfaceAdicionarRemota:
    push ax
    push bx
    es cmp word [di+ObjControle.PtrAbaixo],0
    je .abaixoOk
        mov ax, [di+ObjControle.PtrAbaixo+2]
        mov bx, [di+ObjControle.PtrAbaixo]
        mov es, ax
        mov di, bx
        es cmp word [di+ObjControle.PtrProximo],0
        je .proximoOk
            .buscaProximo:
                mov ax, [di+ObjControle.PtrProximo+2]
                mov bx, [di+ObjControle.PtrProximo]
                mov es, ax
                mov di, bx
                es cmp word [di+ObjControle.PtrProximo],0
                je .proximoOk
                jmp .buscaProximo
        .proximoOk:
            mov ax, ds
            es mov [di+ObjControle.PtrProximo+2], ax
            es mov [di+ObjControle.PtrProximo], si
            stc
            jmp .fim
    .abaixoOk:
        mov ax, ds
        es mov [di+ObjControle.PtrAbaixo+2], ax
        es mov [di+ObjControle.PtrAbaixo], si
        stc
    .fim:
    pop bx
    pop ax
    retf

_interfaceCopiaPtr:
    push es
    pop ds
    mov si, di
    stc
    retf

; es:di = ObjControle
; bx = Janela
__interfaceAplicarJanela:
    push ax
    push bx
    es mov [di+ObjControle.Janela], bx
    es cmp word [di+ObjControle.PtrAcima],0
    je .ignoraAcima
        push es
        push di
        mov ax, [di+ObjControle.PtrAcima+2]
        mov bx, [di+ObjControle.PtrAcima]
        mov es, ax
        mov di, bx
        call __interfaceAplicarJanela
        pop di
        pop es
    .ignoraAcima:
    es cmp word [di+ObjControle.PtrAbaixo],0
    je .ignoraAbaixo
        push es
        push di
        mov ax, [di+ObjControle.PtrAbaixo+2]
        mov bx, [di+ObjControle.PtrAbaixo]
        mov es, ax
        mov di, bx
        call __interfaceAplicarJanela
        pop di
        pop es
    .ignoraAbaixo:
    es cmp word [di+ObjControle.PtrProximo],0
    je .ignoraProximo
        push es
        push di
        mov ax, [di+ObjControle.PtrProximo+2]
        mov bx, [di+ObjControle.PtrProximo]
        mov es, ax
        mov di, bx
        call __interfaceAplicarJanela
        pop di
        pop es
    .ignoraProximo:
    pop bx
    pop ax
    ret

_interfaceAdicionarJanRemota:
    push si
    push bx
    push ax
    mov si, Interface.Janelas
    mov cx, Interface._CapacidadeJanelas
    xor bx, bx
    .busca:
        cs cmp word [si], 0
        jne .continua
            mov ax, es
            cs mov [si+2], ax
            cs mov [si], di
            es cmp word [di+ObjControle.Visivel], 0
            je .ignoraAtiva
                cs mov [Interface.JanelaAtual], bx
            .ignoraAtiva:
            call __interfaceAplicarJanela
            stc
            jmp .fim
        .continua:
        add si, 4
        inc bx
        loop .busca
    clc
    .fim:
    pop ax
    pop bx
    pop si
    retf


_interfaceDesenhaCaixaRemoto:
    push ax
    push bx
    push cx
    push dx
    cs call far [Interface.DesenhaFundoRemoto]
    cs mov ah, [Interface.TemaCorBorda]
    es mov cx, [di+ObjControle.X1]
    es mov dx, [di+ObjControle.Y1]
    mov al, TipoBorda.SupEsq
    cs call far [Interface.DesenhaCaractere]
    es mov cx, [di+ObjControle.X2]
    es mov dx, [di+ObjControle.Y2]
    mov al, TipoBorda.InfDir
    cs call far [Interface.DesenhaCaractere]
    es mov cx, [di+ObjControle.X2]
    es mov dx, [di+ObjControle.Y1]
    mov al, TipoBorda.SupDir
    cs call far [Interface.DesenhaCaractere]
    es mov cx, [di+ObjControle.X1]
    es mov dx, [di+ObjControle.Y2]
    mov al, TipoBorda.InfEsq
    cs call far [Interface.DesenhaCaractere]

    es mov cx, [di+ObjControle.X1]
    inc cx
    mov al, TipoBorda.Horiz
    .horizontal:
        es cmp cx, [di+ObjControle.X2]
        jb .contHorizontal
        jmp .fimHorizontal
        .contHorizontal:
        es mov dx, [di+ObjControle.Y1]
        cs call far [Interface.DesenhaCaractere]
        es mov dx, [di+ObjControle.Y2]
        cs call far [Interface.DesenhaCaractere]
        inc cx
        jmp .horizontal
    .fimHorizontal:

    es mov dx, [di+ObjControle.Y1]
    inc dx
    mov al, TipoBorda.Vert
    .vertical:
        es cmp dx, [di+ObjControle.Y2]
        jb .contVertical
        jmp .fimVertical
        .contVertical:    
        es mov cx, [di+ObjControle.X1]
        cs call far [Interface.DesenhaCaractere]
        es mov cx, [di+ObjControle.X2]
        cs call far [Interface.DesenhaCaractere]
        inc dx
        jmp .vertical
    .fimVertical:
    pop dx
    pop cx
    pop bx
    pop ax
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
    es mov word [di+ObjControle.PtrFonte], 0
    mov ax, cs
    es mov [di+ObjControle.PtrFonte+2], ax
    es mov word [di+ObjControle.X1], 0
    es mov word [di+ObjControle.Y1], 0
    es mov word [di+ObjControle.X2], 0
    es mov word [di+ObjControle.Y2], 0
    es mov word [di+ObjControle.MargemX1], 0
    es mov word [di+ObjControle.MargemY1], 0
    es mov word [di+ObjControle.MargemX2], 0
    es mov word [di+ObjControle.MargemY2], 0
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

_interfaceAlteraTamanhoRemoto:
    push cx
    push dx
    es add cx, [di+ObjControle.X1]
    es add dx, [di+ObjControle.Y1]
    es mov [di+ObjControle.X2], cx
    es mov [di+ObjControle.Y2], dx
    pop dx
    pop cx
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
    call __interfaceCalcularCoordenadas
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

; es:di = ObjControle
__interfaceCalcularCoordenadas:
    push ds
    push si
    push ax
    cs call far [Interface.CopiaPonteiroRemotoParaLocal]
    ds mov ax, [si+ObjControle.X1]
    ds mov [si+ObjControle.CalcX1], ax
    ds mov ax, [si+ObjControle.Y1]
    ds mov [si+ObjControle.CalcY1], ax
    ds mov ax, [si+ObjControle.X2]
    ds mov [si+ObjControle.CalcX2], ax
    ds mov ax, [si+ObjControle.Y2]
    ds mov [si+ObjControle.CalcY2], ax
    ds cmp word [si+ObjControle.PtrAcima], 0
    je .fim
        ds mov ax, [si+ObjControle.PtrAcima+2]
        mov es, ax
        ds mov di, [si+ObjControle.PtrAcima]
        es mov ax, [di+ObjControle.CalcX1]
        es add ax, [di+ObjControle.MargemX1]
        ds add [si+ObjControle.CalcX1], ax
        ds add [si+ObjControle.CalcX2], ax
        es mov ax, [di+ObjControle.CalcY1]
        es add ax, [di+ObjControle.MargemY1]
        ds add [si+ObjControle.CalcY1], ax
        ds add [si+ObjControle.CalcY2], ax
        es mov ax, [di+ObjControle.CalcX2]
        es sub ax, [di+ObjControle.MargemX2]
        ds cmp ax, [si+ObjControle.CalcX2]
        jae .ignoraX2
            ds mov [si+ObjControle.CalcX2], ax
        .ignoraX2:
        es mov ax, [di+ObjControle.CalcY2]
        es sub ax, [di+ObjControle.MargemY2]
        ds cmp ax, [si+ObjControle.CalcY2]
        jae .ignoraY2
            ds mov [si+ObjControle.CalcY2], ax
        .ignoraY2:

    .fim:
    pop ax
    pop si
    pop ds
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
    cs call far [Interface.IniciaJanelaRemoto]
    mov cx, 10
    mov dx, 10
    cs call far [Interface.AlteraPosInicialRemoto]
    mov cx, 40
    mov dx, 10
    cs call far [Interface.AlteraTamanhoRemoto]
    cs call far [Interface.ExibeRemoto]
    cs call far [Interface.AdicionarJanelaRemota]
    cs call far [Interface.RenderizaRemoto]
    .processa:
        cs call far [HUSIS.ProximaTarefa]
        jmp .processa
    retf
    .teste: db 'Oieeee',0

Trad: dw 0