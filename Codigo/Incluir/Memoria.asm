
Memoria:
    db 'HUSIS',0
    db 'Memoria',0
    .AlocaBlocoRemoto: dw 1, 0
        ; Aloca um espaco na memoria
        ; al = Processo
        ; cx = Espaco em Blocos de 256 Bytes
        ; ret: cf = 1=Ok | 0=Sem espaco livre OU Processo invalido
        ;      es = Segmento alocado
        ;      di = 0
    .LiberaBlocoRemoto: dw 1, 0
        ; Libera um espaco na memoria anteriormente alocado
        ; al = Processo
        ; es = Segmento alocado
        ; ret: cf = 1=Ok | 0=Parametro invalido
    .AlocaRemoto: dw 1, 0
        ; Aloca um espaco na memoria (Sera alocado conjuntos de 256 Bytes)
        ; al = Processo
        ; cx = Espaco em bytes
        ; ret: cf = 1=Ok | 0=Sem espaco livre OU Processo invalido
        ;      es = Segmento alocado
        ;      di = 0
    .LiberaRemoto: dw 1, 0
        ; Libera um espaco na memoria anteriormente alocado
        ; al = Processo
        ; ds = Segmento alocado
        ; ret: cf = 1=Ok | 0=Parametro invalido
    .AlocaBlocoLocal: dw 1, 0
        ; Aloca um espaco na memoria
        ; al = Processo
        ; cx = Espaco em Blocos de 256 Bytes
        ; ret: cf = 1=Ok | 0=Sem espaco livre OU Processo invalido
        ;      ds = Segmento alocado
        ;      si = 0
    .LiberaBlocoLocal: dw 1, 0
        ; Libera um espaco na memoria anteriormente alocado
        ; al = Processo
        ; ds = Segmento alocado
        ; ret: cf = 1=Ok | 0=Parametro invalido
    .AlocaLocal: dw 1, 0
        ; Aloca um espaco na memoria (Sera alocado conjuntos de 256 Bytes)
        ; al = Processo
        ; cx = Espaco em bytes
        ; ret: cf = 1=Ok | 0=Sem espaco livre OU Processo invalido
        ;      ds = Segmento alocado
        ;      si = 0
    .LiberaLocal: dw 1, 0
        ; Libera um espaco na memoria anteriormente alocado
        ; al = Processo
        ; ds = Segmento alocado
        ; ret: cf = 1=Ok | 0=Parametro invalido
    .Calcula: dw 1, 0
        ; Calcula memoria de um processo
        ; al = Processo
        ; ret: bx = Total em Blocos de 256 Bytes
        ;      dx = Total em Segmentos de 16 Bytes
        ;      ax = Total em KiB
    .CalculaLivre: dw 1, 0
        ; Calcula o espaco livre
        ; ret: bx = Total em Blocos de 256 Bytes
        ;      dx = Total em Segmentos de 16 Bytes
        ;      ax = Total em KiB
    .CopiaLocalRemoto: dw 1,0
        ; Copia um conjunto do local para o remoto
        ; ds:si = Local
        ; es:di = Remoto
        ; cx = Tamanho
    .CopiaRemotoLocal: dw 1,0
        ; Copia um conjunto do remoto para o local
        ; ds:si = Local
        ; es:di = Remoto
        ; cx = Tamanho
    .CopiaLocalEstatico: dw 1, 0
        ; Copia um conjunto do estatico para o local
        ; ds:si = Local
        ; cs:di = Estatico
        ; cx = Tamanho
    .CopiaEstaticoLocal: dw 1,0
        ; Copia um conjunto do local para o estatico
        ; ds:si = Local
        ; cs:di = Estatico
        ; cx = Tamanho
    .CopiaRemotoEstatico: dw 1,0
        ; Copia um conjunto do remoto para o estatico
        ; cs:si = Estatico
        ; es:di = Remoto
        ; cx = Tamanho
    .CopiaEstaticoRemoto: dw 1,0
        ; Copia um conjunto do estatico para o remoto
        ; cs:si = Estatico
        ; es:di = Remoto
        ; cx = Tamanho
    .ZeraRemoto: dw 1,0
        ; Zera um conjunto remoto
        ; es:di = Remoto
        ; cx = Tamanho
    .ZeraLocal: dw 1,0
        ; Zera um conjunto local
        ; ds:si = Remoto
        ; cx = Tamanho
    .ZeraEstatico: dw 1,0
        ; Zera um conjunto remoto
        ; cs:si = Remoto
        ; cx = Tamanho
    .ExcluiProcesso: dw 1,0
        ; al = Processo
    dw 0