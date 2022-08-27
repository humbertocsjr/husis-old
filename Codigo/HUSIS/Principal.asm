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

; Cabecalho do executavel

nome: db 'HUSIS',0
versao: dw 0,2,1,'Alpha',0
tipo: dw TipoProg.Nucleo

; Modulos dentro deste executavel
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
    dw Semaforo
    dw DMA
    dw 0

; Inclusao dos arquivos que contem os modulos
%include 'TratamentoExecutavel.asm'
%include 'Memoria.asm'
%include 'Terminal.asm'
%include 'Caractere.asm'
%include 'Texto.asm'
%include 'Unidade.asm'
%include 'Disco.asm'
%include 'SisArq.asm'
%include 'MinixFS.asm'
%include 'Multitarefa.asm'
%include 'Semaforo.asm'
%include 'DMA.asm'

; Modulos importados de outros executaveis
importar:
    dw 0

; Modulos exportados para outros executaveis (Publicos)
exportar:
    dw HUSIS
    db 'HUSIS',0
    dw Memoria
    db 'Memoria',0
    dw Texto
    db 'Texto',0
    dw Semaforo
    db 'Semaforo',0
    dw 0

; Definicao do modulo HUSIS
HUSIS: dw _husis,0
    .ProcessoAtual: dw _husisProcessoAtual, 0
        ; ret: al = Processo atual
    .ProximaTarefa: dw _husisProximaTarefa, 0
        ; Executa proximo processo pendente, encerrando o tempo de execucao
        ; ate a proxima passagem do gestor de multitarefa (Yield)
    .EntraEmModoBiblioteca: dw _husisEntraEmModoBiblioteca, 0
        ; Encerra a execucao da rotina principal deste executavel, limitando
        ; seu uso atraves das rotinas dos modulos que exporta
    .Debug: dw _husisDebug,0
    dw 0

; Rotinas do modulo HUSIS
    _husis:
        retf

    _husisDebug:
        cs call far [Terminal.EscrevaDebugDSSI]
        retf

    _husisProcessoAtual:
        cs mov ax, [Multitarefa.Processo]
        retf

    _husisProximaTarefa:
        int 0x81
        retf

    _husisEntraEmModoBiblioteca:
        cs call far [HUSIS.ProcessoAtual]
        call __multitarefaPonteiro
        cs mov word [si+ObjProcesso.Status], StatusProcesso.Biblioteca
        .loop:
            int 0x81
            jmp .loop


; Rotina Principal
inicial:
    push cs
    pop ds
    push cs
    pop es
    ; Processa os proprios modulos, para poderem ser chamados
    call processaModulos

    ; Guarda os argumentos do Gestor de Boot
    cs mov [.constCilindros], cx
    cs mov [.constCabecas], dh
    cs mov [.constDiscoBios], dl
    cs mov [.constSetores], bx

    ; Inicia o Modulo de Terminal de Texto
    cs call far [Terminal]

    ; Compara a assinatura vinda do Gestor de Boot
    cmp ax, 1989
    je .inicialOk
        ; Se nao for a esperada informa o erro e encerra
        cs mov ax, [Trad.SetorInicialIncompativel]
        cs call far [Terminal.Escreva]
        db ' -= %at =-',0
        .infinito:
            hlt
            jmp .infinito
    .inicialOk:

    ; Exibe o nome do sistema e sua versao
    cs mov ax, [versao]
    cs mov bx, [versao+2]
    cs mov cx, [versao+4]
    cs mov cx, [versao+4]
    cs mov dx, versao+6
    cs call far [Terminal.Escreva]
    db 'HUSIS v%an.%bn.%cn %de\n\n',0

    ; Exibe os dados do tamanho do nucleo
    cs mov ax, [Trad.MemoriaRAM]
    cs mov bx, [Trad.TamNucleo]
    cs mov cx, [Prog.Tamanho]
    cs call far [Terminal.Escreva]
    db ' - %at [%bt: %cn Bytes]',0

    ; Inicia os modulos essenciais
    cs call far [Memoria]
    cs call far [Multitarefa]
    cs call far [Semaforo]
    cs call far [DMA]

    cs call far [Terminal.EscrevaOk]

    ; Exibe os dados do disco de boot
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

    ; Inicia o modulo que gerencia as Unidades (Discos/Particoes)
    cs call far [Unidade]
    jc .unidadeOk
        cs mov ax, [Trad.FalhaUnidades]
        cs call far [Terminal.Escreva]
        db ' [ %at ]\n', 0
        jmp .fim
    .unidadeOk:

    ; Inicia o Modulo que Gerencia os Sistemas de Arquivos e os Discos
    cs call far [SisArq]
    cs call far [Disco]
    jc .discoOk
    cs mov ax, [Trad.FalhaDisco]
        cs call far [Terminal.Escreva]
        db ' [ %at ]\n', 0
        jmp .fim
    .discoOk:

    ; Registra o Disco de boot como uma Unidade
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

    ; Grava como unidade principal
    cs mov word [Unidade.UnidadePrincipal], bx

    ; Monta o sistema de arquivos MinixFS
    cs call far [MinixFS.Monta]
    jc .montagemOk
    cs mov ax, [Trad.FalhaMontagem]
        cs call far [Terminal.Escreva]
        db ' [ %at ]\n', 0
        jmp .fim
    .montagemOk:

    cs call far [Terminal.EscrevaPonto]

    ; Le o diretorio raiz do disco
    cs mov bx, [Unidade.UnidadePrincipal]
    cs call far [Unidade.LeiaRaizRemoto]
    jc .montagem2Ok
    cs mov ax, [Trad.FalhaMontagem]
        cs call far [Terminal.Escreva]
        db ' [ %at ]\n', 0
        jmp .fim
    .montagem2Ok:

    cs call far [Terminal.EscrevaPonto]

    ; Le o arquivo de configuracao, que lista todos os executaveis que devem
    ; ser iniciados com o sistema operacional
    push cs
    pop ds
    cs mov si, [Trad.EnderecoConfig]
    add si, Trad
    cs call far [SisArq.AbreEnderecoRemoto]
    jc .encontradoConfig
        ; Caso nao encontre o arquivo de config. encerra.
        cs mov ax, [Trad.FalhaEncontrarConfig]
        cs call far [Terminal.Escreva]
        db ' [ %at ]\n', 0
        jmp .fim
    .encontradoConfig:

    mov ax, es
    cs mov [.constArqConf], ax

    cs call far [Terminal.EscrevaOk]

    ; Suspende a multitarefa, para que os programas iniciados aguardem o 
    ; termino de carregamento dos demais para a memoria
    cs call far [Multitarefa.Suspende]

    ; Carrega os arquivos que estao no Config.cfg
    .carregaArquivos:
        push cs
        pop ds
        ; Le uma linha do arquivo de config.
        mov si, .constLinhaComando
        mov cx, ._constLinhaComandoTam
        cs call far [SisArq.LeiaLinhaLocal]
        ; Caso tenha chegado ao fim da lista encerra
        jnc .fimCarregaArquivos
        ; Senao carrega o arquivo que esta nesta linha da lista
        cs call far [Terminal.Escreva]
        db ' - %le',0
        cs call far [Terminal.EscrevaPonto]
        ; Carrega e executa o arquivo
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

    ; Reativa a multitarefa permitindo que os executaveis comecem a rodar
    cs call far [Multitarefa.Reativa]
    .loop:
        ; Loop infinito usando hlt (Suspende temporariamente o processador)
        ; Evitando super aquecimento, equivalente ao Idle (Linux), que eh
        ; o processo que nao faz nada na maquina
        hlt
        jmp .loop


    .fim:
    retf
    ; Constantes usadas nesta rotina
    ; a constante iniciada com '_' é não mutável
    .constDiscoBios: dw 0
    .constCilindros: dw 0
    .constCabecas: dw 0
    .constSetores: dw 0
    .constArqConf: dw 0
    ._constLinhaComandoTam: equ 256
    .constLinhaComando: times ._constLinhaComandoTam db 0
