%include 'Arquivos.asm'
Trad:
    .Titulo: dw _tradTitulo - Trad
    .Sobre: dw _tradSobre - Trad
    dw 0

_tradTitulo: db 'File Manager',0
_tradSobre: db 'About File Manager',0