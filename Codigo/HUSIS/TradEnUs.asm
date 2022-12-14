%include 'Principal.asm'

Trad:
    .EnderecoConfig: dw _tradEnderecoConfig - Trad
    .EnderecoDirSis: dw _tradEnderecoDirSis - Trad
    .EnderecoDirExt: dw _tradEnderecoDirExt - Trad
    .SetorInicialIncompativel: dw _tradSetorInicialIncompativel - Trad
    .MemoriaRAM: dw _tradMemoriaRAM - Trad
    .TamNucleo: dw _tradTamNucleo - Trad
    .DiscoBIOS: dw _tradDiscoBIOS - Trad
    .Geometria: dw _tradGeometria - Trad
    .FalhaUnidades: dw _tradFalhaUnidades - Trad
    .FalhaDisco: dw _tradFalhaDisco - Trad
    .FalhaDiscoReg: dw _tradFalhaDiscoReg - Trad
    .FalhaMontagem: dw _tradFalhaMontagem - Trad
    .FalhaEncontrarConfig: dw _tradFalhaEncontrarConfig - Trad
    .FalhaEncontrar: dw _tradFalhaEncontrar - Trad
    dw 0

_tradEnderecoConfig: db '/System/Config.cfg',0
_tradEnderecoDirSis: db '/System/',0
_tradEnderecoDirExt: db '/System/Extensions/',0
_tradSetorInicialIncompativel: db 'SYSTEM STOPPED - INCOMPATIBLE BOOT SECTOR',0
_tradMemoriaRAM: db 'Memory RAM',0
_tradTamNucleo: db 'Kernel Size',0
_tradDiscoBIOS: db 'BIOS Disk',0
_tradGeometria: db 'Geometry',0
_tradFalhaUnidades: db 'Failed to start the unit controller',0
_tradFalhaDisco: db 'Failed to start the base disk controller',0
_tradFalhaDiscoReg: db 'Failed to register disk',0
_tradFalhaMontagem: db 'Failed to mount main unit',0
_tradFalhaEncontrarConfig: db 'Config file not found',0
_tradFalhaEncontrar: db 'Binary file not found',0