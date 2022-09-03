%include 'Arquivos.asm'

Trad:
    .Titulo: dw _tradTitulo - Trad
    .SobreTitulo: dw _tradSobreTitulo - Trad
    .SobreBotaoFechar: dw _tradSobreBotaoFechar - Trad
    dw 0
_tradTitulo: db 'Gerenciador de Arquivos',0
_tradSobreTitulo: db 'Sobre',0
_tradSobreBotaoFechar: db  'Fechar',0