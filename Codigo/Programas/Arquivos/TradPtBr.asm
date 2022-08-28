%include 'Arquivos.asm'
Trad:
    .Titulo: dw _tradTitulo - Trad
    .Sobre: dw _tradSobre - Trad
    dw 0

_tradTitulo: db 'Gerenciador de Arquivos',0
_tradSobre: db 'Sobre o Gerenciador de Arquivos',0