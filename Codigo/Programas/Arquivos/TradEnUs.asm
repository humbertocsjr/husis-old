%include 'Arquivos.asm'

Trad:
    .Titulo: dw _tradTitulo - Trad
    .SobreTitulo: dw _tradSobreTitulo - Trad
    .SobreBotaoFechar: dw _tradSobreBotaoFechar - Trad
    dw 0
_tradTitulo: db 'File Manager',0
_tradSobreTitulo: db 'About',0
_tradSobreBotaoFechar: db  'Close',0