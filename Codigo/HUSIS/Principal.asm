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
; - 22/08/2022 - Humberto - Separada as rotinas de tratamento de executaveis

%include '../Incluir/Prog.asm'

nome: db 'HUSIS',0
versao: dw 0,1,3,'Alpha',0
tipo: dw TipoProg.Nucleo
modulos:
    dw HUSIS
    dw Memoria
    dw Terminal
    dw Caractere
    dw Texto
    dw Unidade
    dw Disco
    dw SisArq
    dw MinixFS
    dw Multitarefa
    dw 0

%include 'Memoria.asm'
%include 'Terminal.asm'
%include 'Caractere.asm'
%include 'Texto.asm'
%include 'Unidade.asm'
%include 'Disco.asm'
%include 'SisArq.asm'
%include 'MinixFS.asm'
%include 'Multitarefa.asm'

importar:
    dw 0
exportar:
    dw HUSIS
    db 'HUSIS',0
    dw Memoria
    db 'Memoria',0
    dw Texto
    db 'Texto',0
    dw 0


HUSIS: dw _husis,0
    .ProcessoAtual: dw _husisProcessoAtual, 0
    .ProximaTarefa: dw _husisProximaTarefa, 0
    dw 0

_husis:
    retf

_husisProcessoAtual:
    cs mov ax, [Multitarefa.Processo]
    retf

_husisProximaTarefa:
    int 0x81
    retf


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
        db ' -= %at =-',0
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
    cs call far [Multitarefa]
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
    add si, Trad
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

    cs call far [Multitarefa.Suspende]

    .carregaArquivos:
        push cs
        pop ds
        mov si, .constLinhaComando
        mov cx, ._constLinhaComandoTam
        cs call far [SisArq.LeiaLinhaLocal]
        jnc .fimCarregaArquivos
        cs call far [Terminal.Escreva]
        db ' - %le',0
        cs call far [Terminal.EscrevaPonto]
        cs call far [Multitarefa.ExecutaArquivo]
        jc .arqEncontrado
            cs mov ax, [Trad.FalhaEncontrar]
            cs call far [Terminal.Escreva]
            db ' [ %at ]\n', 0
            jmp .fim
        .arqEncontrado:
        cs call far [Terminal.EscrevaPonto]
        cs call far [Terminal.EscrevaOk]
        jmp .carregaArquivos

    .fimCarregaArquivos:

    cs call far [Multitarefa.Reativa]
    .loop:
        cs mov ax, [Multitarefa.Contador]
        cs call far [Terminal.Escreva]
        db '\r %an',0
        cs call far [HUSIS.ProximaTarefa]
        jmp .loop


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
