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
    .CriarItem: dw _interfaceCriarItem,0
        ; Deve ser usado a partir do segundo item da lista
        ; es:0 = Bloco de Controles Alocado
        ; es:di = ObjControle Atual/Acima
        ; ret: cf = 1=Ok | 0=Estouro da Lista
        ;      es:di = Novo item da lista
    .ConfigJanela: dw _janela,0
    .ConfigRotulo: dw _rotulo,0
    .AlteraPosicao: dw _interfaceAlteraPosicao,0
    .AlteraPosicao2: dw _interfaceAlteraPosicao2,0
    .AlteraTamanho: dw _interfaceAlteraTamanho,0
    .AlteraLargura: dw _interfaceAlteraLargura,0
    .AlteraAltura: dw _interfaceAlteraAltura,0
    .AlteraPrincipal: dw _interfaceAlteraPrincipal,0
    .AlteraAuxiliar: dw _interfaceAlteraAuxiliar,0
    .AlteraPrincipalTrad: dw _interfaceAlteraPrincipalTrad,0
    .AlteraAuxiliarTrad: dw _interfaceAlteraAuxiliarTrad,0
    .AlteraPrincipalConst: dw _interfaceAlteraPrincipalConst,0
    .AlteraAuxiliarConst: dw _interfaceAlteraAuxiliarConst,0
    dw 0
    .Tela: times ObjControle._Tam db 0
    .TemaCorFrente: dw TipoCor.Ciano
    .TemaCorDestaque: dw TipoCor.CianoClaro
    .TemaCorBotaoFechar: dw TipoCor.VermelhoClaro
    .TemaCorBorda: dw TipoCor.Ciano
    .TemaCorFundo: dw TipoCor.Preto
    .TemaCorJanelaTitulo: dw TipoCor.CianoClaro
    .TemaCorJanelaBorda: dw TipoCor.CianoClaro
    .TemaCorTelaFundo: dw TipoCor.Preto
    .TemaCorTelaFrente: dw TipoCor.Ciano


_interface:
    push ax
    push di
    cs mov ah, [Interface.TemaCorTelaFundo]
    cs mov al, [Interface.TemaCorTelaFrente]
    mov di, ax
    cs call far [VideoTexto.LimpaTela]
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
_interfaceCriarItem:
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
    es mov [di+ObjControle.PtrAcima], ax
    es mov [di+ObjControle.PtrAcima], bx
    stc
    .fim:
    pop si
    pop bx
    pop ax
    retf

inicial:
    cs call far [VideoTexto]
    cs call far [Interface]

    mov cx, 10
    cs call far [Interface.Aloca]
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

    cs call far [Interface.CriarItem]
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

    mov di, 2
    es call far [di+ObjControle.PtrRenderiza]
    jnc .erro

    jmp .loop
    .erro:
    cs call far [HUSIS.Debug]
    .loop:
        cs call far [HUSIS.ProximaTarefa]
        jmp .loop
    retf
    .constTeste: db 'Teste 123 123 123 123 132 123 123 123 123',0

Trad: