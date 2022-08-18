; =========
;  MinixFS
; =========
;
; Prototipo........: 18/08/2022
; Versao Inicial...: --/08/2022
; Autor............: Humberto Costa dos Santos Junior
;
; Funcao...........: Implementa o MinixFS
;
; Limitacoes.......: 
;
; Historico........:
;
; - 18/08/2022 - Humberto - Prototipo inicial

MinixFS: dw _minixfs, 0
    .Verificar: dw _minixfsVerificar, 0
    dw 0

_minixfs:
    retf


; Verifica se uma particao está formatada com MinixFS
; bx = Unidade
; ret: cf = 1=Ok | 0=Incompativel
_minixfsVerificar:
    
    retf
