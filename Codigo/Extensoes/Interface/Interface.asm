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

; Cabecalho do executavel
nome: db 'Interface',0
versao: dw 0,1,1
tipo: dw TipoProg.Executavel
modulos:
    dw Interface
    dw 0

; Inclusao dos demais arquivo do projeto

    %include '../../Incluir/ObjFonte.asm'
    %include '../../Incluir/ObjControle.asm'
    %include 'FontePipoca.asm'
    %include 'CtlJanela.asm'
    %include 'CtlRotulo.asm'

importar:
    %include '../../Incluir/Texto.asm'
    %include '../../Incluir/Memoria.asm'
    %include '../../Incluir/HUSIS.asm'
    %include '../../Incluir/Video.asm'
    dw 0
exportar:
    dw Interface
    db 'Interface',0
    dw 0

; Enumeradores usados pela biblioteca

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

; Descricao do Modulo exportado

Interface: dw _interface, 0
    .AlocaControleRemoto: dw _interfaceAlocaControleRemoto,0
        ; ret: cf = 1=Ok | 0=Falha
        ;      es:di = ObjControle
    .AlocaSubControleRemoto: dw _interfaceAlocaSubControleRemoto,0
        ; es:di = ObjControle Acima
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
    .AlteraConteudoTradRemoto: dw _interfaceAlteraConteudoTradRemoto, 0
        ; es:di = ObjControle
        ; ds:si = Traducao (ds=cs)
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraExtensaoRemoto: dw _interfaceAlteraExtensaoRemoto, 0
        ; es:di = ObjControle
        ; ds:si = Novo conteudo extendido
        ; ret: cf = 1=Ok | 0=Falha
    .AlteraExtensaoTradRemoto: dw _interfaceAlteraExtensaoTradRemoto, 0
        ; es:di = ObjControle
        ; ds:si = Traducao (ds=cs)
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
    .AdicionaJanelaRemota: dw _interfaceAdicionaJanRemota,0
        ; Adiciona uma janela a raiz
        ; es:di = ObjControle
        ; ret: cf = 1=Ok | 0=Falha
    .AdicionaRemota: dw _interfaceAdicionaRemota,0
        ; Adiciona um controle a um outro controle/janela
        ; es:di = ObjControle Acima
        ; ds:si = ObjControle Abaixo
        ; ret: cf = 1=Ok | 0=Falha
    .AdicionaLocal: dw _interfaceAdicionaLocal,0
        ; Adiciona um controle a um outro controle/janela
        ; es:di = ObjControle Abaixo
        ; ds:si = ObjControle Acima
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
    .IniciaRotuloTradRemoto: dw _interfaceIniciaRotuloTradRemoto,0
        ; es:di = ObjControle
        ; ds:si = Traducao (ds=cs)
        ; ret: cf = 1=Ok | 0=Falha
    .IniciaJanelaRemoto: dw _interfaceIniciaJanelaRemoto,0
        ; es:di = ObjControle
        ; ds:si = Texto
        ; ret: cf = 1=Ok | 0=Falha
    .IniciaJanelaTradRemoto: dw _interfaceIniciaJanelaTradRemoto,0
        ; es:di = ObjControle
        ; ds:si = Traducao (ds=cs)
        ; ret: cf = 1=Ok | 0=Falha
    dw 0
    .Largura: dw 0
    .Altura: dw 0
    .Cores: dw 0
    .PtrBuffer: dw 0
    ._CapacidadeFontes: equ 32
    .Fontes: times ._CapacidadeFontes dw 0,0
    ._CapacidadeJanelas: equ 32
    .Janelas: times ._CapacidadeJanelas dw 0,0
    .JanelaAtual: dw 0
    .TemaCorBorda: dw TipoCor.Ciano
    .TemaCorTitulo: dw TipoCor.CianoClaro

; Rotinas da Interface

_interface:
    push ax
    mov ax, cs
    cs mov [Interface.Fontes+2], ax
    cs mov word [Interface.Fontes], FontePipoca
    pop ax
    retf

; Rotina que desenha um caractere na tela usando uma fonte
; es:di = ObjControle
;         Usa coordenadas Internas
; al    = Caractere
; ret: Incrementa ObjControle.InternoX1
__interfaceDesenhaCaractere:
    push ax
    push bx
    push cx
    push dx
    push ds
    push si
    push es
    push di
    push bp
    mov bp, sp
    ; Cria as variaveis locais
    xor ah, ah
    push ax
    .varCaractere: equ -2

    es push word [di+ObjControle.InternoX1]
    .varX: equ -4

    es push word [di+ObjControle.InternoY1]
    .varY: equ -6

    xor ax, ax
    push ax
    .varLargura: equ -8

    push ax
    .varAltura: equ -10

    push ax
    .varX2: equ -12

    push ax
    .varY2: equ -14

    ; Carrega a fonte da lista de fontes
    es mov bx, [di+ObjControle.Fonte]
    shl bx, 1
    shl bx, 1
    add bx, Interface.Fontes
    cs mov si, [bx]
    cs mov ax, [bx+2]
    mov ds, ax
    ; Le parametros da fonte

    ; Ignora os caracteres invisiveis, desenhando apenas se for visivel
    mov ax, [si+ObjFonte.PrimeiroCaractere]
    cmp [bp+.varCaractere], ax
    jb .fim
        ; Usa o caractere como indice para apontar na fonte
        ; Para isso subtrai do indice os caracteres invisiveis
        sub [bp+.varCaractere], ax
        ; Le a altura da fonte
        mov ax, [si+ObjFonte.Altura]
        mov [bp+.varAltura], ax
        ; Le o caractere/indice para ler na fonte
        mov ax, [bp+.varCaractere]
        ; Multiplica o indice pelo tamanho em bytes de cada desenho de um
        ; caractere
        mov cx, [si+ObjFonte.BytesPorCaractere]
        mul cx
        ; Agora tendo um ponteiro para a lista de caracteres, soma ao ponteiro
        ; que direciona para o inicio da lista
        mov si, [si+ObjFonte.PtrLocalInicio]
        add si, ax
        ; Carrega o primeiro byte do ponteiro do caractere 
        ; (Largura do caractere)
        xor ax, ax
        lodsb
        mov [bp+.varLargura], ax
        
        ; Valida altura e largura com espaco disponivel

        ; Largura > X2-X1 ?
        es mov ax, [di+ObjControle.InternoX2]
        es sub ax, [di+ObjControle.InternoX1]
        cmp [bp+.varLargura], ax
        jb .larguraOk
            ; Se largura atual for maior que o espaco disponivel usa o espaco
            mov [bp+.varLargura], ax
        .larguraOk:

        ; Altura > Y2-Y1 ?
        es mov ax, [di+ObjControle.InternoY2]
        es sub ax, [di+ObjControle.InternoY1]
        cmp [bp+.varAltura], ax
        jb .alturaOk
            ; Se altura atual for maior que o espaco disponivel usa o espaco
            mov [bp+.varAltura], ax
        .alturaOk:

        ; Calcula o X2
        ; X2 = X1+Largura
        es mov ax, [di+ObjControle.InternoX1]
        add ax, [bp+.varLargura]
        mov [bp+.varX2], ax

        ; Calcula o Y2
        ; Y2 = Y1+Altura
        es mov ax, [di+ObjControle.InternoY1]
        add ax, [bp+.varAltura]
        mov [bp+.varY2], ax

        ; Desenha o caractere
        mov bx, [bp+.varY]
        .vert:
            ; Verifica se chegou ao fim vertical
            cmp bx, [bp+.varY2]
            jae .fimVert
            ; Le byte da fonte
            push ax
            lodsb
            mov dx, ax
            pop ax
            ; Desenha uma linha da fonte
            ; Redefine X para o inicio da proxima linha do desenho
            mov ax, [bp+.varX]
            .horiz:
                ; Verifica se chegou ao fim da linha (horizontal)
                cmp ax, [bp+.varX2]
                ja .fimHoriz
                ; O pixel é armazenado em um bit
                ; Faz uma operação de descarte do bit mais a esquerda
                shl dl, 1
                push si
                ; Se o bit descartado for 0, nao desenha
                jnc .pula
                    ; Se for 1, desenha
                    es mov si, [di+ObjControle.InternoCor]
                    ; Desenha o pixel
                    cs call far [Video.Pixel]
                .pula:
                pop si
                ; Incrementa X
                inc ax
                jmp .horiz
            .fimHoriz:
            ; Incrementa Y
            inc bx
            jmp .vert
        .fimVert:

    .fim:
    mov ax, [bp+.varLargura]
    es add [di+ObjControle.InternoX1], ax
    mov sp, bp
    pop bp
    pop di
    pop es
    pop si
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax
    ret

_interfaceAdicionaRemota:
    push ax
    push bx
    push es
    push di
    mov es, ax
    mov [si+ObjControle.PtrAcima+2], ax
    mov [si+ObjControle.PtrAcima], di
    es cmp word [di+ObjControle.PtrAbaixo+2],0
    je .abaixoOk
        es mov ax, [di+ObjControle.PtrAbaixo+2]
        es mov bx, [di+ObjControle.PtrAbaixo]
        mov es, ax
        mov di, bx
        es cmp word [di+ObjControle.PtrProximo+2],0
        je .proximoOk
            .buscaProximo:
                es mov ax, [di+ObjControle.PtrProximo+2]
                es mov bx, [di+ObjControle.PtrProximo]
                mov es, ax
                mov di, bx
                es cmp word [di+ObjControle.PtrProximo+2],0
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
    pop di
    pop es
    retf

_interfaceAdicionaLocal:
    push ds
    push si
    push ax
    push bx
    mov ds, ax
    es mov [di+ObjControle.PtrAcima+2], ax
    es mov [di+ObjControle.PtrAcima], si
    cmp word [si+ObjControle.PtrAbaixo+2],0
    je .abaixoOk
        mov ax, [si+ObjControle.PtrAbaixo+2]
        mov bx, [si+ObjControle.PtrAbaixo]
        mov ds, ax
        mov si, bx
        cmp word [si+ObjControle.PtrProximo+2],0
        je .proximoOk
            .buscaProximo:
                mov ax, [si+ObjControle.PtrProximo+2]
                mov bx, [si+ObjControle.PtrProximo]
                mov ds, ax
                mov si, bx
                cmp word [si+ObjControle.PtrProximo+2],0
                je .proximoOk
                jmp .buscaProximo
        .proximoOk:
            mov ax, es
            mov [si+ObjControle.PtrProximo+2], ax
            mov [si+ObjControle.PtrProximo], di
            stc
            jmp .fim
    .abaixoOk:
        mov ax, es
        mov [si+ObjControle.PtrAbaixo+2], ax
        mov [si+ObjControle.PtrAbaixo], di
        stc
    .fim:
    pop bx
    pop ax
    pop si
    pop ds
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
    es cmp word [di+ObjControle.PtrAcima+2],0
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
    es cmp word [di+ObjControle.PtrAbaixo+2],0
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
    es cmp word [di+ObjControle.PtrProximo+2],0
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

_interfaceAdicionaJanRemota:
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
            es mov [di+ObjControle.Janela], bx
            es cmp word [di+ObjControle.Visivel], 0
            je .ignoraAtiva
                cs mov [Interface.JanelaAtual], bx
                cs call far [Interface.RenderizaRemoto]
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

_interfaceExibeRemoto:
    es mov word [di+ObjControle.Visivel], 1
    cs call far [Interface.RenderizaRemoto]
    retf

_interfaceOcultaRemoto:
    es mov word [di+ObjControle.Visivel], 0
    retf

_interfaceIniciaRemoto:
    push ax
    es mov word [di+ObjControle.PtrAbaixo], 0
    es mov word [di+ObjControle.PtrAbaixo+2], 0
    es mov word [di+ObjControle.PtrProximo], 0
    es mov word [di+ObjControle.PtrProximo+2], 0
    es mov word [di+ObjControle.PtrConteudo], 0
    es mov word [di+ObjControle.PtrConteudo+2], 0
    es mov word [di+ObjControle.PtrRenderiza], 0
    es mov word [di+ObjControle.PtrRenderiza+2], 0
    es mov word [di+ObjControle.PtrExtensao], 0
    es mov word [di+ObjControle.PtrExtensao+2], 0
    es mov word [di+ObjControle.Fonte], 0
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

_interfaceAlteraConteudoTradRemoto:
    push bp
    mov bp, sp
    push si
    push ax
    mov ax, ds
    mov si, [si]
    add si, [Prog.Traducao]
    es mov [di+ObjControle.PtrConteudo+2], ax
    es mov [di+ObjControle.PtrConteudo], si
    cs call far [Interface.RenderizaRemoto]
    pop ax
    pop si
    pop bp
    stc
    retf

_interfaceAlteraExtensaoRemoto:
    push ax
    mov ax, ds
    es mov [di+ObjControle.PtrExtensao+2], ax
    es mov [di+ObjControle.PtrExtensao], si
    cs call far [Interface.RenderizaRemoto]
    pop ax
    stc
    retf

_interfaceAlteraExtensaoTradRemoto:
    push bp
    mov bp, sp
    push si
    push ax
    mov ax, ds
    mov si, [si]
    add si, [Prog.Traducao]
    es mov [di+ObjControle.PtrExtensao+2], ax
    es mov [di+ObjControle.PtrExtensao], si
    cs call far [Interface.RenderizaRemoto]
    pop ax
    pop si
    pop bp
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
    cmp cx, 0
    je .ignoraCx
        dec cx
    .ignoraCx:
    cmp dx, 0
    je .ignoraDx
        dec dx
    .ignoraDx:
    es mov [di+ObjControle.X2], cx
    es mov [di+ObjControle.Y2], dx
    pop dx
    pop cx
    cs call far [Interface.RenderizaRemoto]
    retf

_interfaceRenderizaRemoto:
    push ax
    push bx
    es cmp word [di+ObjControle.PtrRenderiza+2], 0
    je .falha
    es cmp word [di+ObjControle.Visivel], 0
    je .ok
    es cmp word [di+ObjControle.PtrAcima+2],0
    je .semAcima
        push ds
        push si
        es push word [di+ObjControle.PtrAcima+2]
        pop ds
        es push word [di+ObjControle.PtrAcima]
        pop si
        mov ax, [si+ObjControle.Janela]
        es mov [di+ObjControle.Janela], ax
        pop si
        pop ds
    .semAcima:
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
    pop bx
    pop ax
    retf

_interfaceAlocaControleRemoto:
    push ax
    push cx
    cs call far [HUSIS.ProcessoAtual]
    mov cx, ObjControle._Tam
    cs call far [Memoria.AlocaRemoto]
    jnc .fim
        es mov word [di+ObjControle.Janela], 0xffff
        es mov word [di+ObjControle.PtrAcima], 0
        es mov word [di+ObjControle.PtrAcima+2], 0
    .fim:
    pop cx
    pop ax
    retf

_interfaceAlocaSubControleRemoto:
    push ds
    push si
    push ax
    cs call far [Interface.CopiaPonteiroRemotoParaLocal]
    cs call far [Interface.AlocaControleRemoto]
    jnc .fim
        cs call far [Interface.AdicionaLocal]
        mov ax, ds
        es mov word [di+ObjControle.PtrAcima], si
        es mov word [di+ObjControle.PtrAcima+2], ax
    .fim:
    pop ax
    pop si
    pop ds
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

; es:di = ObjControle
__interfaceCalcularCoordenadas:
    push ds
    push si
    push es
    push di
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
    ds cmp word [si+ObjControle.PtrAcima+2], 0
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
    pop di
    pop es
    pop si
    pop ds
    ret


; Rotina principal
inicial:
    ; Inicia o modulo Interface
    cs call far [Interface]
    .processa:
        ; Fica esperando eternamente
        cs call far [HUSIS.ProximaTarefa]
        jmp .processa
    retf

Trad: dw 0