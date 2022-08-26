
Video: dw ._Fim
    db 'Video',0
    db 'Video',0
    .Pixel: dw 1, 0
        ; ax = X
        ; bx = Y
        ; si = Cor
        ; ret: cf = 1=Ok | 0=Falha
    .Fundo: dw 1, 0
        ; ax = X1
        ; bx = Y1
        ; cx = X2
        ; dx = Y2
        ; di = Cor de Fundo
        ; ret: cf = 1=Ok | 0=Falha
    .Borda: dw 1, 0
        ; ax = X1
        ; bx = Y1
        ; cx = X2
        ; dx = Y2
        ; si = Cor da Borda
        ; ret: cf = 1=Ok | 0=Falha
    .Caixa: dw 1, 0
        ; ax = X1
        ; bx = Y1
        ; cx = X2
        ; dx = Y2
        ; si = Cor da Borda
        ; di = Cor de Fundo
        ; ret: cf = 1=Ok | 0=Falha
    .Linha: dw 1, 0
        ; ax = X1
        ; bx = Y1
        ; cx = X2
        ; dx = Y2
        ; si = Cor da Linha
        ; ret: cf = 1=Ok | 0=Falha
    .LimpaTela: dw 1,0
        ; di = Cor de Fundo
        ; ret: cf = 1=Ok | 0=Falha
    .ImagemLocal: dw 1,0
        ; ax = X1
        ; bx = Y1
        ; cx = X2
        ; dx = Y2
        ; ds:si = Imagem
        ; ret: cf = 1=Ok | 0=Falha
    .RegistraVideo: dw 1,0
        ; cs:si = DesenhaPixel
        ; ax = Cores Simultaneas
        ; cx = Largura
        ; dx = Altura
        ; ret: cf = 1=Ok | 0=Falha
    ._Fim: