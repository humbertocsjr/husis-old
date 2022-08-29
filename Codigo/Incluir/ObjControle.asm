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
    .InternoX1: equ 70
    .InternoY1: equ 72
    .InternoX2: equ 74
    .InternoY2: equ 76
    .InternoCor: equ 78
    .Itens: equ 80
    ._CapacidadeItens: equ 24
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
    .CinzaEscuro: equ 8
    .AzulClaro: equ 9
    .VerdeClaro: equ 10
    .CianoClaro: equ 11
    .VermelhoClaro: equ 12
    .MagentaClaro: equ 13
    .Amarelo: equ 14
    .Branco: equ 15

TipoControle:
    .Indefinido: equ 0
    .Tela: equ 1
    .Janela: equ 2
    .Rotulo: equ 3
