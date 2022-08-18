; =======================================
;  Cabecalho de um Programa para o HUSIS
; =======================================
;
; Prototipo........: 17/08/2022
; Versao Inicial...: 17/08/2022
; Autor............: Humberto Costa dos Santos Junior
;
; Funcao...........: Deve ir no inicio do binario de qualquer programa
;
; Limitacoes.......: 
;
; Historico........:
;
; - 17/08/2022 - Humberto - Prototipo inicial

Prog:
    dw 1989
    dw 1
    .PtrInicial: dw inicial
    .Tamanho: dw 0
    .PtrNome: dw nome
    .PtrVersao: dw versao
    .PtrModulos: dw modulos