modulos:
    dw Memoria
    dw Terminal
    dw Disco
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

    call far [Memoria]
    call far [Terminal]
    
    call far [Terminal.Escreva]
    db 'HUSIS\n\n',0

    call far [Terminal.Escreva]
    db ' Controlador de disco',0
    call far [Disco]
    call far [Terminal.Escreva]
    db ' . [ OK ]\n',0
    
    call far [Terminal.Escreva]
    db ' Disco Inicial ',0
    cs mov bx, [.constDiscoBios]
    call far [Disco.BuscaPorId]
    jc .discoInicialOk
        call far [Terminal.Escreva]
        db ' [ NENHUM DISCO INICIAL ENCONTRADO ]',0
        jmp .fim
    .discoInicialOk:
    push bx
    mov ax, bx
    cs mov [.constDisco], ax
    call far [Terminal.EscrevaNum]
    pop bx
    call far [Terminal.Escreva]
    db ': ', 0
    mov ax, cx
    call far [Terminal.EscrevaNum]
    call far [Terminal.Escreva]
    db ' Cilindros, ', 0
    xor ax, ax
    mov al, dh
    call far [Terminal.EscrevaNum]
    call far [Terminal.Escreva]
    db ' Cabecas, ', 0
    mov al, dl
    call far [Terminal.EscrevaNum]
    call far [Terminal.Escreva]
    db ' Setores\n', 0

    
    .fim:
    retf
    .constDiscoBios: dw 0
    .constDisco: dw 0