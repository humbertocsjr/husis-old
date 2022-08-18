modulos:
    dw Memoria
    dw Terminal
    dw Unidade
    dw Disco
    dw MinixFS
    dw 0

nome: db 'HUSIS',0

versao:
    dw 1
    dw 0
    dw 0

; Processa um modulo
; es:bx = Modulo
processarModulo:
    push si
    push bx
    push ax
    mov ax, es
    .processaFuncoes:
        es cmp word [bx], 0
        je .fim
        es mov [bx+2], ax
        add bx, 4
        jmp .processaFuncoes
    .fim:
    pop ax
    pop bx
    pop si
    ret

; Processa os modulos de um programa
; es = Programa
processarModulos:
    push bx
    push si
    es mov si, [Prog.PtrModulos]
    .processa:
        es cmp word [si], 0
        je .fim
        es mov bx, [si]
        call processarModulo
        add si, 2
        jmp .processa
    .fim:
    pop si
    pop bx
    ret

inicial:
    push cs
    pop ds
    push cs
    pop es
    cs mov [.constDiscoBios], dl

    call processarModulos
    

    cs call far [Memoria]
    cs call far [Terminal]
    
    cs call far [Terminal.Escreva]
    db 'HUSIS\n\n',0

    cs call far [Terminal.Escreva]
    db ' Tamanho do Nucleo: ',0
    cs mov ax, [Prog.Tamanho]
    cs call far [Terminal.EscrevaNum]
    cs call far [Terminal.Escreva]
    db ' Bytes\n',0

    cs call far [Terminal.Escreva]
    db ' Controlador de disco',0
    cs call far [Unidade]
    cs call far [Terminal.Escreva]
    db ' .',0
    cs call far [Disco]
    cs call far [Terminal.Escreva]
    db ' . [ OK ]\n',0
    
    cs call far [Terminal.Escreva]
    db ' Disco Inicial ',0
    cs mov bx, [.constDiscoBios]
    cs call far [Disco.BuscaPorId]
    jc .discoInicialOk
        cs call far [Terminal.Escreva]
        db ' [ NENHUM DISCO INICIAL ENCONTRADO ]',0
        jmp .fim
    .discoInicialOk:
    push bx
    mov ax, bx
    cs mov [.constDisco], ax
    cs call far [Terminal.EscrevaNum]
    pop bx
    cs call far [Terminal.Escreva]
    db ': ', 0
    mov ax, cx
    cs call far [Terminal.EscrevaNum]
    cs call far [Terminal.Escreva]
    db ' Cilindros, ', 0
    xor ax, ax
    mov al, dh
    cs call far [Terminal.EscrevaNum]
    cs call far [Terminal.Escreva]
    db ' Cabecas, ', 0
    mov al, dl
    cs call far [Terminal.EscrevaNum]
    cs call far [Terminal.Escreva]
    db ' Setores\n', 0

    cs call far [Terminal.Escreva]
    db ' Sistema de Arquivos',0
    cs call far [MinixFS]
    cs call far [Terminal.Escreva]
    db ' . [ OK ]\n',0
    



    cs call far [Terminal.Escreva]
    db '\n Memoria Livre: ',0
    cs call far [Memoria.CalculaLivre]
    cs call far [Terminal.EscrevaNum]
    cs call far [Terminal.Escreva]
    db ' KiB\n',0

    cs call far [Terminal.Escreva]
    db ' Memoria Reservada: ',0
    mov al, 0xff
    cs call far [Memoria.Calcula]
    cs call far [Terminal.EscrevaNum]
    cs call far [Terminal.Escreva]
    db ' KiB\n',0

    cs call far [Terminal.Escreva]
    db ' Memoria Nucleo: ',0
    cs mov al, [Prog.Processo]
    cs call far [Memoria.Calcula]
    cs call far [Terminal.EscrevaNum]
    cs call far [Terminal.Escreva]
    db ' KiB\n\n',0

    .fim:
    retf
    .constDiscoBios: dw 0
    .constDisco: dw 0