%include 'Principal.asm'

Trad:
    .SetorInicialIncompativel: dw _tradSetorInicialIncompativel - Trad
    .MemoriaRAM: dw _tradMemoriaRAM - Trad
    .TamNucleo: dw _tradTamNucleo - Trad
    .DiscoBIOS: dw _tradDiscoBIOS - Trad
    .Geometria: dw _tradGeometria - Trad
    .FalhaUnidades: dw _tradFalhaUnidades - Trad
    .FalhaDisco: dw _tradFalhaDisco - Trad
    .FalhaDiscoReg: dw _tradFalhaDiscoReg - Trad
    dw 0

_tradSetorInicialIncompativel: db 'SISTEMA PARALIZADO - SETOR INICIAL INCOMPATIVEL',0
_tradMemoriaRAM: db 'Memoria RAM',0
_tradTamNucleo: db 'Tam. Nucleo',0
_tradDiscoBIOS: db 'Disco BIOS',0
_tradGeometria: db 'Geometria',0
_tradFalhaUnidades: db 'Falha ao iniciar o controlador de unidades',0
_tradFalhaDisco: db 'Falha ao iniciar o controlador de disco base',0
_tradFalhaDiscoReg: db 'Falha ao registrar o disco',0