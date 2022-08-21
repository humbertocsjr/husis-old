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

cpu 8086
Prog:
    dw 1989
    dw 1
    .PtrInicial: dw inicial
    .Tamanho: dw 0
    .Processo: dw 0
    .Traducao: dw Trad
    .PtrTipo: dw tipo
    .PtrNome: dw nome
    .PtrVersao: dw versao
    .PtrModulos: dw modulos
    .PtrImportar: dw importar
    .PtrExportar: dw exportar

TipoProg:
    .Biblioteca: equ 0
    .Executavel: equ 10
    .Nucleo: equ 0xffff