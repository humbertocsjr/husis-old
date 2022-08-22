%include '../../Incluir/Prog.asm'

nome: db 'CGA',0
versao: dw 0,1,1
tipo: dw TipoProg.Executavel
modulos:
    dw 0

importar:
    %include '../../Incluir/Memoria.asm'
    %include '../../Incluir/HUSIS.asm'
    dw 0
exportar:
    dw 0


inicial:
    cs call far [HUSIS.EntraEmModoBiblioteca]
    .infinito:
        hlt
        jmp .infinito
    retf

Trad: dw 0