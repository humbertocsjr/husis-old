%include '../../Incluir/Prog.asm'

nome: db 'Interface',0
versao: dw 0,1,1
tipo: dw TipoProg.Executavel
modulos:
    dw Caractere
    dw Terminal
    dw Interface
    dw 0

    %include '../../HUSIS/Caractere.asm'
    %include '../../HUSIS/Terminal.asm'

importar:
    %include '../../Incluir/Texto.asm'
    %include '../../Incluir/Memoria.asm'
    %include '../../Incluir/HUSIS.asm'
    dw 0
exportar:
    dw 0

Interface: dw _interface, 0
    .RegistraTela: dw _interfaceRegistraTela,0
        ; Registra a tela (Inicialmente apenas suporta uma)
        ; O Buffer eh opcional, neste caso a rotina dx deve apenas retornar 
        ; cf=1 apenas efetuando a limpeza via os parametros
        ; ax = Segmento das rotinas
        ; bx = Rotina de desenho um pixel no buffer
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
    .DesenhaPixel: dw _interfaceDesenhaPixel,0
        ; Desenha um pixel
        ; cx = X
        ; dx = Y
        ; ax = Cor
        ; ret: cf = 1=Ok | 0=Falha
    dw 0
    .PtrDesenhaPixel: dw 0, 0
    .PtrAtualizaTela: dw 0, 0
    .Largura: dw 0
    .Altura: dw 0
    .Cores: dw 0
    .PtrBuffer: dw 0

_interface:
    retf

_interfaceDesenhaPixel:
    clc
    retf
    times 50 nop
    .inicio:
    cs push word [Interface.PtrDesenhaPixel+2]
    cs push word [Interface.PtrDesenhaPixel]
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
    cs cmp word [Interface.PtrDesenhaPixel+2], ax
    cs cmp word [Interface.PtrDesenhaPixel], bx
    cs cmp word [Interface.PtrAtualizaTela+2], ax
    cs cmp word [Interface.PtrAtualizaTela], dx
    push cs
    pop ds
    push cs
    pop es
    mov si, _interfaceDesenhaPixel.inicio
    mov di, _interfaceDesenhaPixel
    mov cx, _interfaceDesenhaPixel.fim - _interfaceDesenhaPixel.inicio
    rep movsb
    stc
    pop cx
    pop di
    pop si
    pop es
    pop ds
    retf

inicial:
    cs call far [Interface]
    .aguardaTela:
        cs cmp word [Interface.PtrDesenhaPixel], 0
        je .continuaAguardando
        cs cmp word [Interface.PtrAtualizaTela], 0
        je .continuaAguardando
            mov ax, 1
            cs call far [Interface.PtrAtualizaTela]
            jmp .processa
        .continuaAguardando:
        cs call far [HUSIS.ProximaTarefa]
        jmp .aguardaTela
    .processa:
        cs call far [HUSIS.ProximaTarefa]
        jmp .processa
    retf

Trad: dw 0