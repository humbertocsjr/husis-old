%include '../../Incluir/Prog.asm'

nome: db 'Interface',0
versao: dw 0,1,1
tipo: dw TipoProg.Executavel
modulos:
    dw 0
importar:
    dw 0
exportar:
    dw 0

inicial:
    .loop:
        mov ax, 0xe0a
        int 0x10
        mov ax, 0xe0d
        int 0x10
        hlt
        jmp .loop
    retf

Trad: dw 0