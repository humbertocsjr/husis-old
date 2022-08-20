; =====================
;  Sistema de Arquivos
; =====================
;
; Prototipo........: 18/08/2022
; Versao Inicial...: --/08/2022
; Autor............: Humberto Costa dos Santos Junior
;
; Funcao...........: Gerencia o sistema de arquivos
;
; Limitacoes.......: 
;
; Historico........:
;
; - 18/08/2022 - Humberto - Prototipo inicial
;
; ----------------------------------------------------
;  Formato do Endereco de Itens (Arquivos/Diretorios)
; ----------------------------------------------------
;
; Um endereco eh feito de trechos que sao categorizados abaixo:
; 
;  - Unidade       : Define a qual unidade este item pertence
;  - SubItem       : Trecho do endereco que define o diretorio ou item final
;
; Os trechos devem ser separados por barra '/' e opcionalmente devem conter
; no inicio a unidade entre '[]', conforme exemplo abaixo:
;
; [0]/Sistema/Config.cfg
;
; Caso a unidade seja ocultada sera usada a unidade raiz (A que contem o 
; sistema operacional), conforme exemplo abaixo:
;
; /Sistema/Config.cfg
;

ObjSisArq:
    .Id: equ 0
    .Tipo: equ 4
    .Raiz: equ 6
    .Reservado: equ 8
    .SubItem: equ 10
        ; es = ObjSisArq
        ; cx = Posicao
        ; ret: cf = 1=Encontrado | 0=Nao encontrado OU fim da lista
        ;      es = Aloca e retorna um objeto ObjSisArqItem
    .Fechar: equ 14
        ; Fecha um item ja aberto e libera a memoria do ObjSisArq
        ; es = ObjSisArq
        ; ret: cf = 1=Fechado | 0=Operacao invalida
    .Leia: equ 18
        ; es = ObjSisArq
        ; ds:si = Origem
        ; cx = Qtd de Bytes
        ; ret: cf = 1=Lido | 0=Nao lido
        ;      cx = Qtd de Bytes lidos
    .Escreva: equ 22
        ; es = ObjSisArq
        ; ds:si = Origem
        ; cx = Qtd de Bytes
        ; ret: cf = 1=Escrito | 0=Nao escrito
        ;      cx = Qtd de Bytes escritos
    .Exclui: equ 26
        ; es = ObjSisArq
        ; ret: cf = 1=Excluido | 0=Nao excluido
    .CriaDiretorio: equ 30
        ; es = ObjSisArq
        ; ds:si = Nome do novo diretorio
        ; ret: cf = 1=Criado | 0=Nao criado
    .CriaArquivo: equ 34
        ; es = ObjSisArq
        ; ds:si = Nome do novo arquivo
        ; ret: cf = 1=Criado | 0=Nao criado
    .Ejeta: equ 38
        ; OBS: Existe apenas na raiz
        ; bx = Unidade
        ; ret: cf = 1=Ejetado | 0=Nao ejetado
    .Unidade: equ 42
    .IdAcima: equ 44
    .Status: equ 48
        ; Codigo do erro do ultimo comando
    ._Tam: equ 50

ObjSisArqItem:
    .Id: equ 0
        ; Identificador unico no sistema de arquivos (Ate 8 Bytes)
    .Acima: equ 8
        ; Segmento onde esta o ObjSisArq (Acima)
    .Raiz: equ 12
        ; Segmento onde esta o ObjSisArq (Raiz)
    .Abrir: equ 16
        ; Abre um item e cria um ObjSisArq para ele
        ; es = ObjSisArqItem
        ; ret: cf = 1=Aberto | 0=Nao foi possivel abrir
        ;      es = ObjSisArq
    .Nome: equ 20
        ; Nome do arquivo
    .Zero: equ 255
    ._CapacidadeNome: equ .Zero - .Nome
    ._Tam: equ 256

TipoSisArq:
    .Desconhecido: equ 0
    .Arquivo: equ 10
    .Diretorio: equ 20

StatusSisArq:
    .Desconhecido: equ 0
    .NaoExiste: equ 10
    .SemEspaco: equ 20
    .ApenasLeitura: equ 30

SisArq: dw _sisarq,0
    .RegistraUnidade: dw _sisarqRegistraUnidade, 0
    .LeiaUnidade: dw _sisarqLeiaUnidade, 0
    .SubItem: dw _sisarqSubItem, 0
    .AbrirEndereco: dw _sisarqAbrirEndereco, 0
    .RegistraRaiz: dw _sisarqRegistraRaiz,0
    dw 0
    ._CapacidadeUnidades: equ 32
    .ListaUnidades: times ._CapacidadeUnidades dw 0
    .UnidadeRaiz: dw 0


_sisarq:
    retf


; Registra o sistema de arquivos de uma unidade
; bx = Unidade
; es = ObjSisArq
_sisarqRegistraUnidade:
    push ax
    push bx
    cmp bx, SisArq._CapacidadeUnidades
    jbe .ok
        clc
        jmp .fim
    .ok:
    shl bx, 1
    mov ax, es
    cs mov [bx+SisArq.ListaUnidades], ax
    stc
    .fim:
    pop bx
    pop ax
    retf

; Le o sistema de arquivos de uma unidade
; bx = Unidade
; ret: cf = 1=Existe | 0=Nao existe
;      es = ObjSisArq
_sisarqLeiaUnidade:
    push ax
    push bx
    cmp bx, SisArq._CapacidadeUnidades
    jbe .ok
        clc
        jmp .fim
    .ok:
    shl bx, 1
    cs mov ax, [bx+SisArq.ListaUnidades]
    mov es, ax
    stc
    .fim:
    pop bx
    pop ax
    retf

; Lista um sub item do diretorio
; es = ObjSisArq
; cx = Posicao
; ret: cf = 1=Existe | 0=Nao Existe
;      es = ObjSisArqItem
_sisarqSubItem:
    push ax
    push bx
    push cx
    push dx
    push ds
    push si
    push di
    es mov word [ObjSisArq.Status], StatusSisArq.Desconhecido
    es cmp word [ObjSisArq.SubItem], 0
    jne .ok
        clc
        jmp .fim
    .ok:
    es call far [ObjSisArq.SubItem]
    .fim:
    pop di
    pop si
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax
    retf

; Abre um arquivo/diretorio
; ds:si = Endereco
_sisarqAbrirEndereco:
    push ds
    push ax
    push bx
    push cx
    push dx
    push si
    es mov word [ObjSisArq.Status], StatusSisArq.Desconhecido
    cs mov bx, [SisArq.UnidadeRaiz]
    lodsb
    cmp al, 0
    je .naoEncontrado
    cmp al, '/'
    je .semUnidade
    cmp al, '['
    jne .fimUnidade
    .processaUnidade:
        lodsb
        cmp al, 0
        je .naoEncontradoSimples
        cmp al, ']'
        je .fimUnidade
        cs call far [Caractere.EhNumero]
        jnc .naoEncontradoSimples
        xor bx, bx
        mov bl, al
        sub bx, '0'
        lodsb
        cmp al, 0
        je .naoEncontradoSimples
        cmp al, ']'
        je .fimUnidade
    .naoEncontrado:
        mov ax, es
        cmp ax, bx
        je .naoEncontradoSimples
        cs call far [Memoria.Libera]
    .naoEncontradoSimples:
        clc
        jmp .fim
    .semUnidade:
    dec si
    .fimUnidade:
    cs call far [SisArq.LeiaUnidade]
    push es 
    pop bx
    lodsb
    cmp al, 0
    je .encontrado
    cmp al, '/'
    jne .naoEncontrado
    .processarCaminho:
        xor ax, ax
        lodsb
cs call far [Terminal.Escreva]
db '>>>>>>>>>>>>>>>',0
cs call far [Terminal.EscrevaDebug]
        cmp al, 0
        je .encontrado
        dec si
        xor cx, cx
        .comparaItem:
            push es
            push si
            push bx
            push cx
            cs call far [SisArq.SubItem]
cs call far [Terminal.EscrevaDebug]
            jnc .naoEncontradoItem
            mov di, ObjSisArqItem.Nome
cs call far [Terminal.EscrevaESDI]
            .comparaCaractere:
                cmp byte [si], 0
                je .fimTrecho
                cmp byte [si], '/'
                je .fimTrechoInc
                cmpsb
                je .comparaCaractere
                jmp .proximo
                .fimTrechoInc:
                    inc si
                .fimTrecho:
                    es cmp byte [di], 0
                    jne .proximo
                    es cmp word [ObjSisArqItem.Abrir], 0
                    je .naoEncontradoItem
                    es call far [ObjSisArqItem.Abrir]
                    jnc .naoEncontradoItem
                    ; Descarta si empilhado colocando em ax
                    pop cx
                    pop bx
                    pop ax
                    pop ax
                    jmp .processarCaminho
            .naoEncontradoItem:
                pop cx
                pop bx
                pop si
                pop es
                jmp .naoEncontrado
            .proximo:
            cs call far [Memoria.Libera]
            pop cx
            pop bx
            pop si
            pop es
            inc cx
            jmp .comparaItem
    .encontrado:
    stc
    .fim:
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    pop ds
    retf

; bx = Unidade Raiz
_sisarqRegistraRaiz:
    cs mov [SisArq.UnidadeRaiz], bx
    retf