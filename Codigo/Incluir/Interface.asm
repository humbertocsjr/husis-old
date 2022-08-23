
Interface: dw ._Fim
    db 'Interface',0
    db 'Interface',0
    .RegistraTela: dw 1,0
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
    .DesenhaPixel: dw 1,0
        ; Desenha um pixel
        ; cx = X
        ; dx = Y
        ; ax = Cor
        ; ret: cf = 1=Ok | 0=Falha
    ._Fim: