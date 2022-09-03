ObjControle:
    .PtrAcima: equ 0
    .Janela: equ 4
    .Tipo: equ 6
    .X1: equ 8
    .Y1: equ 10
    .X2: equ 12
    .Y2: equ 14
    .PtrRenderiza: equ 16
    .PtrConteudo: equ 20
    .PtrAuxiliar: equ 24
    .ValorA: equ 28
    .ValorB: equ 32
    .ValorC: equ 36
    .ValorD: equ 40
    .CorFundo: equ 44
    .CorFrente: equ 46
    .CorBorda: equ 48
    .CorDestaque: equ 50
    .Visivel: equ 52
    .MargemX1: equ 54
    .MargemY1: equ 56
    .MargemX2: equ 58
    .MargemY2: equ 60
    .CalcX1: equ 62
    .CalcY1: equ 64
    .CalcX2: equ 66
    .CalcY2: equ 68
    .PtrAcao: equ 70
    .PtrAcaoAux: equ 74
    .PtrAcaoFoco: equ 78
    .PtrAcaoSemFoco: equ 82
    .PtrTela: equ 86
    .PtrJanela: equ 90
    .ValorPosicao: equ 94
    .ValorTamanho: equ 98
    .PtrProcessaTecla: equ 102
        ; es:di = ObjControle
        ; ax = ASCII
        ; bx = TipoTeclaEspecial
        ; cx = TipoTeclaAdicional (Contem mais de uma em paralelo)
        ; ret: cf = 1=Renderiza | 0=Ignora
    .PtrProcessaMouse: equ 106
        ; es:di = ObjControle
        ; ax = X do ObjControle
        ; bx = Y do ObjControle
        ; cx = Scroll indo de -128 a +128
        ; dx = TipoBotaoMouse (Contem mais de uma em paralelo)
        ; ret: cf = 1=Renderiza | 0=Ignora
    .PtrObjEmFoco: equ 110
        ; es:di = ObjControle
    .PtrEntraNoFoco: equ 114
        ; es:di = ObjControle
    .PtrSaiDoFoco: equ 118
    .Itens: equ 122
    ._CapacidadeItens: equ 32
    ._Tam: equ .Itens + (._CapacidadeItens * 4)

TipoBotaoMouse:
    .Nenhum: equ 0
    .Principal: equ 1
    .Secundario: equ 2
    .Terciario: equ 4

TipoTeclaEspecial:
    .Nenhuma: equ 0
    .F1: equ 1
    .F2: equ 2
    .F3: equ 3
    .F4: equ 4
    .F5: equ 5
    .F6: equ 6
    .F7: equ 7
    .F8: equ 8
    .F9: equ 9
    .F10: equ 10
    .F11: equ 11
    .F12: equ 12
    .SetaAcima: equ 13
    .SetaAbaixo: equ 14
    .SetaEsquerda: equ 15
    .SetaDireita: equ 16
    .CapsLock: equ 17
    .NumLock: equ 18
    .ScrollLock: equ 19
    .Esc: equ 20
    .BackSpace: equ 21
    .Delete: equ 22
    .Enter: equ 23
    .Home: equ 24
    .End: equ 25
    .Ins: equ 26
    .PageUp: equ 27
    .PageDown: equ 28
    .PrintScreen: equ 29
    .Tab: equ 30

TipoTeclaAdicional:
    .Nenhuma: equ 0
    .Ctrl: equ 1
    .Alt: equ 2
    .Shift: equ 4
    .CapsLock: equ 8
    .NumLock: equ 16
    .ScrollLock: equ 32
    .Fn: equ 64

TipoCor:
    .Preto: equ 0
    .Azul: equ 1
    .Verde: equ 2
    .Ciano: equ 3
    .Vermelho: equ 4
    .Magenta: equ 5
    .Marrom: equ 6
    .CinzaClaro: equ 7
    .Cinza: equ 8
    .AzulClaro: equ 9
    .VerdeClaro: equ 10
    .CianoClaro: equ 11
    .VermelhoClaro: equ 12
    .MagentaClaro: equ 13
    .Amarelo: equ 14
    .Branco: equ 15

TipoCorFundo:
    .Preto: equ 0x00
    .Azul: equ 0x10
    .Verde: equ 0x20
    .Ciano: equ 0x30
    .Vermelho: equ 0x40
    .Magenta: equ 0x50
    .Marrom: equ 0x60
    .CinzaClaro: equ 0x70
    .Cinza: equ 0x80
    .AzulClaro: equ 0x90
    .VerdeClaro: equ 0xa0
    .CianoClaro: equ 0xb0
    .VermelhoClaro: equ 0xc0
    .MagentaClaro: equ 0xd0
    .Amarelo: equ 0xe0
    .Branco: equ 0xf0


TipoControle:
    .Indefinido: equ 0
    .Tela: equ 1
    .Janela: equ 2
    .Rotulo: equ 3
    .Campo: equ 4
    .Botao: equ 5
