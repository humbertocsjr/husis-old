; ========================
;  Gerenciador de Memoria
; ========================
;
; Prototipo........: 17/08/2022
; Versao Inicial...: --/08/2022
; Autor............: Humberto Costa dos Santos Junior
;
; Funcao...........: Gerencia a Memoria separando em blocos
;
; Limitacoes.......: 
;
; Historico........:
;
; - 17/08/2022 - Humberto - Prototipo inicial

Memoria: dw _memoria, 0
    .Aloca: dw _memoriaAlocar, 0
    dw 0

_memoria:
    retf

_memoriaAlocar:
    retf;