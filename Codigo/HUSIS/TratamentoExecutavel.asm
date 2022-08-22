; ============================================================
;  Nucleo do HUSIS - Ferramentas de Tratamento de Executaveis
; ============================================================
;
; Prototipo........: 20/08/2022
; Versao Inicial...: 20/08/2022
; Autor............: Humberto Costa dos Santos Junior
;
; Funcao...........: Nucleo do HUSIS
;
; Limitacoes.......: Aceita executaveis de ate 64 KiB
;
; Historico........:
;
; - 22/08/2022 - Humberto - Separada as rotinas do arquivo Principal
;                           Implementado a importacao de modulos do nucleo


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

; Importa um executavel
; es:di = Nome do executavel
; ret: cf = 1=Ok | 0=Nao encontrado
;      ds:si = Executavel
importaExecutavelLocal:
    push di
    push ax
    ; Define com nucleo para comparar
    push cs
    pop ds
    mov si, nome
    cs call far [Texto.IgualRemotoEstatico]
    jnc .naoNucleo
        stc
        jmp .fim
    .naoNucleo:
    clc
    .fim:
    pop ax
    pop di
    ret

; Processa uma importacao
; es:di = Registro de importacao
processaImportacao:
    push di
    push es
    push ds
    push si
    push bx
    push ax
    add di, 2
    ; Baseado no nome no registro de importacao, carrega o executavel
    call importaExecutavelLocal
    jnc .fim
    ; Pula o primeiro campo do registro
    cs call far [Texto.CalculaTamanhoRemoto]
    add di, cx
    inc di
    ; Cria um ponteiro para ler o executavel
    mov si, Prog.PtrExportar
    mov si, [si]
    .buscaModulo:
        ; Le o ponteiro no registro de exportacao
        lodsw
        cmp ax, 0
        je .falha
        ; Guarda o ponteiro de exportacao
        mov bx, ax
        ; Compara registro de exportacao com o de importacao
        cs call far [Texto.IgualLocalRemoto]
        jnc .continuaBuscando
            ; Pula o campo nome do registro de importacao
            cs call far [Texto.CalculaTamanhoRemoto]
            add di, cx
            inc di
            ; Arruma o ponteiro de exportacao para o modulo
            mov si, bx
            add si, 4
            .preenche:
                ; Verifica se eh um registro tipo 1 (Importacao)
                es cmp word [di], 1
                jne .ok
                ; Se for copia o ponteiro no registro do modulo exportado
                mov ax, [si]
                es mov [di], ax
                add di, 2
                add si, 2
                mov ax, [si]
                es mov [di], ax
                add di, 2
                add si, 2
                jmp .preenche
        .continuaBuscando:
        ; Pula o registro de exportacao caso nao seja
        cs call far [Texto.CalculaTamanhoLocal]
        add si, cx
        inc si
        jmp .buscaModulo
    .falha:
    clc
    jmp .fim
    .ok:
    stc
    .fim:
    pop ax
    pop bx
    pop si
    pop ds
    pop es
    pop di
    ret

; Processa os modulos de um programa
; es = Programa
processaModulos:
    push bx
    push di
    es mov di, [Prog.PtrModulos]
    .modulos:
        es cmp word [di], 0
        je .fimModulos
        es mov bx, [di]
        call processaModulo
        add di, 2
        jmp .modulos
    .fimModulos:
    es mov di, [Prog.PtrImportar]
    .importar:
        es cmp word [di], 0
        je .fimImportar
        es mov bx, [di]
        call processaImportacao
        jnc .fim
        mov di, bx
        jmp .importar
    .fimImportar:
    stc
    jmp .fim
    .fim:
    pop di
    pop bx
    ret