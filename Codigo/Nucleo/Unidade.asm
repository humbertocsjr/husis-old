; =========================
;  Gerenciador de Unidades
; =========================
;
; Prototipo........: 18/08/2022
; Versao Inicial...: 18/08/2022
; Autor............: Humberto Costa dos Santos Junior
;
; Funcao...........: Gerencia Unidades de Armazenamento, usado como ponte entre Os tipos de Disco e o Sistema de Arquivos
;
; Limitacoes.......: 
;
; Historico........:
;
; - 18/08/2022 - Humberto - Prototipo inicial sem inteligencia apenas servindo como interface para o disco

Unidade: dw _unidade, 0
    .Info: dw _unidadeInfo, 0
    .Leia: dw _unidadeLeia, 0
    .Leia512: dw _unidadeLeia512, 0
    .Escreva: dw _unidadeEscreva, 0
    .Escreva512: dw _unidadeEscreva512, 0
    dw 0

_unidade:
    retf

_unidadeInfo:
    cs call far [Disco.Info]
    retf

_unidadeLeia512:
    cs call far [Disco.Leia512]
    retf

_unidadeLeia:
    push ax
    push dx
    push di
    shl ax, 1
    rcl dx, 1
    cs call far [Unidade.Leia512]
    jnc .fim
    add di, 512
    add ax, 1
    adc dx, 0
    cs call far [Unidade.Leia512]
    .fim:
    pop di
    pop dx
    pop ax
    retf

_unidadeEscreva512:
    cs call far [Disco.Escreva512]
    retf

_unidadeEscreva:
    push ax
    push dx
    push di
    shl ax, 1
    rcl dx, 1
    cs call far [Unidade.Escreva512]
    jnc .fim
    add di, 512
    add ax, 1
    adc dx, 0
    cs call far [Unidade.Escreva512]
    .fim:
    pop di
    pop dx
    pop ax
    retf