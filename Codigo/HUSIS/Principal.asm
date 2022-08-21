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
; - 21/08/2022 - Humberto - Implementado traducao

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
    dw SisArq
    dw MinixFS
    dw 0

%include 'Memoria.asm'
%include 'Terminal.asm'
%include 'Caractere.asm'
%include 'Texto.asm'
%include 'Unidade.asm'
%include 'Disco.asm'
%include 'SisArq.asm'
%include 'MinixFS.asm'

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
        cs mov ax, [Trad.SetorInicialIncompativel]
        cs call far [Terminal.Escreva]
        db ' -= %ae =-',0
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

    cs mov ax, [Trad.MemoriaRAM]
    cs mov bx, [Trad.TamNucleo]
    cs mov cx, [Prog.Tamanho]
    cs call far [Terminal.Escreva]
    db ' - %at [%bt: %cn Bytes]',0
    cs call far [Memoria]
    cs call far [Terminal.EscrevaOk]

    cs mov ax, [Trad.DiscoBIOS]
    cs mov bx, [.constDiscoBios]
    cs call far [Terminal.Escreva]
    db ' - %at %bn',0
    cs mov ax, [Trad.Geometria]
    cs mov bx, [.constCilindros]
    cs mov cx, [.constCabecas]
    cs mov dx, [.constSetores]
    cs call far [Terminal.Escreva]
    db ' [%at: %bn:%cn:%dn]',0

    cs call far [Unidade]
    jc .unidadeOk
        cs mov ax, [Trad.FalhaUnidades]
        cs call far [Terminal.Escreva]
        db ' [ %at ]\n', 0
        jmp .fim
    .unidadeOk:

    cs call far [SisArq]
    cs call far [Disco]
    jc .discoOk
    cs mov ax, [Trad.FalhaDisco]
        cs call far [Terminal.Escreva]
        db ' [ %at ]\n', 0
        jmp .fim
    .discoOk:

    cs mov ax, [.constDiscoBios]
    cs mov bx, [.constCilindros]
    cs mov cx, [.constCabecas]
    cs mov dx, [.constSetores]
    cs call far [Disco.RegistraManualmente]
    jc .discoRegOk
    cs mov ax, [Trad.FalhaDiscoReg]
        cs call far [Terminal.Escreva]
        db ' [ %at ]\n', 0
        jmp .fim
    .discoRegOk:
    cs mov word [Unidade.UnidadePrincipal], bx

    cs call far [MinixFS.Monta]
    jc .montagemOk
    cs mov ax, [Trad.FalhaMontagem]
        cs call far [Terminal.Escreva]
        db ' [ %at ]\n', 0
        jmp .fim
    .montagemOk:

    cs call far [Terminal.EscrevaPonto]

    cs mov bx, [Unidade.UnidadePrincipal]
    cs call far [Unidade.LeiaRaizRemoto]
    jc .montagem2Ok
    cs mov ax, [Trad.FalhaMontagem]
        cs call far [Terminal.Escreva]
        db ' [ %at ]\n', 0
        jmp .fim
    .montagem2Ok:

    cs call far [Terminal.EscrevaPonto]

    push cs
    pop ds
    cs mov si, [Trad.EnderecoConfig]
    cs call far [SisArq.AbreEnderecoRemoto]
    jc .naoEncontradoConfig
    cs mov ax, [Trad.FalhaEncontrarConfig]
        cs call far [Terminal.Escreva]
        db ' [ %at ]\n', 0
        jmp .fim
    .naoEncontradoConfig:

    mov ax, es
    cs mov [.constArqConf], ax

    cs call far [Terminal.EscrevaOk]

    push cs
    pop ds
    mov si, .constLinhaComando
    mov cx, ._constLinhaComandoTam
    cs call far [SisArq.LeiaLinhaLocal]

    cs call far [Terminal.EscrevaLocal]



    
    .fim:
    retf
    .constDiscoBios: dw 0
    .constCilindros: dw 0
    .constCabecas: dw 0
    .constSetores: dw 0
    .constNumero: db '7c0',0
    .constArqConf: dw 0
    ._constLinhaComandoTam: equ 256
    .constLinhaComando: times ._constLinhaComandoTam db 0
