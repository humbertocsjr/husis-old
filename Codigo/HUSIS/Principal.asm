; =================
;  Nucleo do HUSIS
; =================
;
; Prototipo........: 20/08/2022
; Versao Inicial...: 20/08/2022
; Autor............: Humberto Costa dos Santos Junior
;
; Funcao...........: Nucleo do HUSIS
;
; Limitacoes.......: 
;
; Historico........:
;
; - 20/08/2022 - Humberto - Prototipo inicial

%include '../Incluir/Prog.asm'

nome: db 'HUSIS',0
versao: dw 0,1,1,'Alpha',0
tipo: dw TipoProg.Nucleo
modulos:
    dw Memoria
    dw Terminal
    dw Caractere
    dw Texto
    dw Unidade
    dw Disco
    dw 0

%include 'Memoria.asm'
%include 'Terminal.asm'
%include 'Caractere.asm'
%include 'Texto.asm'
%include 'Unidade.asm'
%include 'Disco.asm'

importar:
    dw 0
exportar:
    dw 0

; Processa um modulo
; es:bx = Modulo
processaModulo:
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
processaModulos:
    push bx
    push si
    es mov si, [Prog.PtrModulos]
    .processa:
        es cmp word [si], 0
        je .fim
        es mov bx, [si]
        call processaModulo
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
    call processaModulos

    cs mov [.constCilindros], cx
    cs mov [.constCabecas], dh
    cs mov [.constDiscoBios], dl
    cs mov [.constSetores], bx

    cs call far [Terminal]

    cmp ax, 1989
    je .inicialOk
        cs call far [Terminal.Escreva]
        db ' -= SISTEMA PARALIZADO - SETOR INICIAL INCOMPATIVEL =-',0
        .infinito:
            hlt
            jmp .infinito
    .inicialOk:

    cs mov ax, [versao]
    cs mov bx, [versao+2]
    cs mov cx, [versao+4]
    cs mov cx, [versao+4]
    cs mov dx, versao+6
    cs call far [Terminal.Escreva]
    db 'HUSIS v%an.%bn.%cn %de\n\n',0

    cs mov ax, [Prog.Tamanho]
    cs call far [Terminal.Escreva]
    db ' - Memoria RAM [Tam. Nucleo: %an Bytes]',0
    cs call far [Memoria]
    cs call far [Terminal.EscrevaOk]

    cs mov ax, [.constDiscoBios]
    cs mov bx, [.constCilindros]
    cs mov cx, [.constCabecas]
    cs mov dx, [.constSetores]
    cs call far [Terminal.Escreva]
    db ' - Disco BIOS %an [Geometria: %bn:%cn:%dn]',0

    cs call far [Unidade]
    jc .unidadeOk
        cs call far [Terminal.Escreva]
        db ' [ Falha ao iniciar o controlador de unidades ]\n', 0
        jmp .fim
    .unidadeOk:

    cs call far [Disco]
    jc .discoOk
        cs call far [Terminal.Escreva]
        db ' [ Falha ao iniciar o controlador de disco base ]\n', 0
        jmp .fim
    .discoOk:

    cs mov ax, [.constDiscoBios]
    cs mov bx, [.constCilindros]
    cs mov cx, [.constCabecas]
    cs mov dx, [.constSetores]
    cs call far [Disco.RegistraManualmente]
    jc .discoRegOk
        cs call far [Terminal.Escreva]
        db ' [ Falha ao registrar o disco ]\n', 0
        jmp .fim
    .discoRegOk:

    cs call far [Terminal.EscrevaOk]

    .fim:
    retf
    .constDiscoBios: dw 0
    .constCilindros: dw 0
    .constCabecas: dw 0
    .constSetores: dw 0
    .constNumero: db '7c0',0

