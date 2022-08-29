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
    .Itens: equ 94
    ._CapacidadeItens: equ 32
    ._Tam: equ .Itens + (._CapacidadeItens * 4)

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
