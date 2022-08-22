%include '../../Incluir/Prog.asm'

nome: db 'Interface',0
versao: dw 0,1,1
tipo: dw TipoProg.Executavel
modulos:
    dw 0
importar:
    %include '../../Incluir/Memoria.asm'
    %include '../../Incluir/Texto.asm'
    dw 0
exportar:
    dw 0

inicial:
    .loop:
        mov ah, 0xe
        mov al, 'A'
        int 0x10
        hlt
        jmp .loop
    retf

Trad: dw 0