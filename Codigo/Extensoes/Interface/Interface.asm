%include '../../Incluir/Prog.asm'

nome: db 'Interface',0
versao: dw 0,1,1
tipo: dw TipoProg.Executavel
modulos:
    dw Caractere
    dw Terminal
    dw Teste
    dw 0

    %include '../../HUSIS/Caractere.asm'
    %include '../../HUSIS/Terminal.asm'

importar:
    %include '../../Incluir/Memoria.asm'
    %include '../../Incluir/Texto.asm'
    dw 0
exportar:
    dw 0

Teste: dw _teste,0
    dw 0

_teste:
    push cs
    pop ds
    push cs
    pop es
    mov si, .tmp1
    mov di, .tmp2
    cs call far [Texto.IgualLocalRemoto]
    jnc .b
    mov ah, 0xe
    mov al, 'A'
    int 0x10
    jmp .fim
    .b:
    mov ah, 0xe
    mov al, 'B'
    int 0x10
    .fim:
    retf
    .tmp1: db 'OI',0
    .tmp2: db 'OI',0

inicial:
    cs mov ax, [Texto.IgualEstaticoEstatico]
    cs mov bx, [Texto.IgualEstaticoEstatico+2]
    cs call far [Terminal.Escreva]
    db ' ? %bh %an \n\n\n',0
    .loop:
        cs call far [Teste]
        hlt
        jmp .loop
    retf

Trad: dw 0