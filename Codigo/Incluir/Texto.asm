
Texto: dw ._Fim
    db 'HUSIS',0
    db 'Texto',0
    .LocalParaNumero: dw 1, 0
        ; Converte texto para numero
        ; ds:si = Texto (Altera SI para apos o numero)
        ; ret: cf = 1=Sucesso | 0=Insucesso
        ;      ax = Valor (Caso de insucesso retorna 0)
    .LocalParaHexadecimal: dw 1, 0
        ; Converte texto hexadecimal em numero
        ; ds:si = Texto (Altera SI para apos o numero)
        ; ret: cf = 1=Sucesso | 0=Insucesso
        ;      ax = Valor (Caso de insucesso retorna 0)
    .RemotoParaNumero: dw 1, 0
        ; Converte texto para numero
        ; es:di = Texto (Altera SI para apos o numero)
        ; ret: cf = 1=Sucesso | 0=Insucesso
        ;      ax = Valor (Caso de insucesso retorna 0)
    .RemotoParaHexadecimal: dw 1, 0
        ; Converte texto hexadecimal em numero
        ; es:di = Texto (Altera SI para apos o numero)
        ; ret: cf = 1=Sucesso | 0=Insucesso
        ;      ax = Valor (Caso de insucesso retorna 0)
    .CopiaLocalRemoto: dw 1, 0
        ; Copia texto
        ; ds:si = Origem
        ; es:di = Destino
        ; cx = Capacidade destino
    .CopiaRemotoLocal: dw 1, 0
        ; Copia texto
        ; es:di = Origem
        ; ds:si = Destino
        ; cx = Capacidade destino
    .CopiaEstaticoRemoto: dw 1, 0
        ; Copia texto
        ; cs:si = Origem
        ; es:di = Destino
        ; cx = Capacidade destino
    .CopiaRemotoEstatico: dw 1, 0
        ; Copia texto
        ; es:di = Origem
        ; cs:si = Destino
        ; cx = Capacidade destino
    .CopiaLocalEstatico: dw 1, 0
        ; Copia texto
        ; ds:si = Origem
        ; cs:di = Destino
        ; cx = Capacidade destino
    .CopiaEstaticoLocal: dw 1, 0
        ; Copia texto
        ; cs:di = Origem
        ; ds:si = Destino
        ; cx = Capacidade destino
    .CalculaTamanhoLocal: dw 1, 0
        ; Calcula o tamanho de um texto
        ; ds:si = Texto
        ; ret: cx = Tamanho
    .CalculaTamanhoRemoto: dw 1, 0
        ; Calcula o tamanho de um texto
        ; es:di = Texto
        ; ret: cx = Tamanho
    .CalculaTamanhoEstatico: dw 1, 0
        ; Calcula o tamanho de um texto
        ; cs:si = Texto
        ; ret: cx = Tamanho
    .IgualLocalEstatico: dw 1, 0
        ; Compara se dois textos sao iguais
        ; ds:si = Texto 1
        ; cs:di = Texto 2
        ; ret: cf = 1=Igual | 0=Diferente
    .IgualLocalLocal: dw 1, 0
        ; Compara se dois textos sao iguais
        ; ds:si = Texto 1
        ; ds:di = Texto 2
        ; ret: cf = 1=Igual | 0=Diferente
    .IgualLocalRemoto: dw 1, 0
        ; Compara se dois textos sao iguais
        ; ds:si = Texto 1
        ; es:di = Texto 2
        ; ret: cf = 1=Igual | 0=Diferente
    .IgualRemotoEstatico: dw 1, 0
        ; Compara se dois textos sao iguais
        ; cs:si = Texto 1
        ; es:di = Texto 2
        ; ret: cf = 1=Igual | 0=Diferente
    .IgualRemotoRemoto: dw 1, 0
        ; Compara se dois textos sao iguais
        ; es:si = Texto 1
        ; es:di = Texto 2
        ; ret: cf = 1=Igual | 0=Diferente
    .IgualEstaticoEstatico: dw 1, 0
        ; Compara se dois textos sao iguais
        ; cs:si = Texto 1
        ; cs:di = Texto 2
        ; ret: cf = 1=Igual | 0=Diferente
    ._Fim: