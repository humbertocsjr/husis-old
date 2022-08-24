; =============
;  Multitarefa
; =============
;
; Prototipo........: 21/08/2022
; Versao Inicial...: 21/08/2022
; Autor............: Humberto Costa dos Santos Junior
;
; Funcao...........: Implementa o Multitarefa
;
; Limitacoes.......: 
;
; Historico........:
;
; - 21/08/2022 - Humberto - Prototipo inicial

ObjProcesso:
    .Id: equ 0
    .Status: equ 2
    .Segmento: equ 4
    .Pilha: equ 6
    ._Tam: equ 10

StatusProcesso:
    .Vazio: equ 0
        ; Vazio
    .Ativo: equ 10
        ; Executando
    .Suspenso: equ 20
        ; Reservado porem nao executando
    .Encerrado: equ 30
        ; Vazio entre itens ativos
    .Biblioteca: equ 40
        ; Ativo porem nao tem uma rotina principal rodando

Multitarefa: dw _multitarefa,0
    .Suspende: dw _multitarefaSuspende, 0
    .Reativa: dw _multitarefaReativa, 0
    .ExecutaArquivo: dw _multitarefaExecutaArquivo, 0
    dw 0
    .Simultaneos: dw 1
    .ProcessoPonteiro: dw 0
        ; Ponteiro SI
    .Processo: dw 1
        ; Numero do Processo
    .StatusGeral: dw 0
    .Int8: dw 0, 0
    .Contador: dw 0
    ._Capacidade: equ 128
    .Lista: times ObjProcesso._Tam * ._Capacidade db 0
    .FimLista:

_multitarefa:
    cs mov word [Multitarefa.StatusGeral], 0
    push ds
    mov si, Multitarefa.Lista
    mov cx, Multitarefa._Capacidade
    .limpa:
        cs mov word [si + ObjProcesso.Status], StatusProcesso.Vazio
        add si, ObjProcesso._Tam
        loop .limpa
    mov si, Multitarefa.Lista
    cs mov ax, [Prog.Processo]
    cs mov [si + ObjProcesso.Id], ax
    cs mov word [si + ObjProcesso.Status], StatusProcesso.Ativo
    mov ax, cs
    cs mov [si + ObjProcesso.Segmento], ax
    cs mov [Multitarefa.ProcessoPonteiro], si
    cli
    mov ax, 0
    mov ds, ax
    mov ax, [8 * 4]
    mov bx, [8 * 4 + 2]
    cs mov [Multitarefa.Int8], ax
    cs mov [Multitarefa.Int8 + 2], bx

    mov bx, _multitarefaInt8
    mov ax, cs
    ds mov [8 * 4], bx
    ds mov [8 * 4 + 2], ax

    mov bx, _multitarefaInt8.proxTarefa
    ds mov [0x81 * 4], bx
    ds mov [0x81 * 4 + 2], ax

    sti
    pop ds
    retf

_multitarefaSuspende:
    cs inc word [Multitarefa.StatusGeral]
    retf

_multitarefaReativa:
    pushf
    cli
    cs cmp word [Multitarefa.StatusGeral], 0
    je .fim
        cs dec word [Multitarefa.StatusGeral]
    .fim:
    popf
    retf


_multitarefaInt8:
    pushf
    push cs
    cs push word [.constPtrContinua]
    cs push word [Multitarefa.Int8 + 2]
    cs push word [Multitarefa.Int8]
    retf
    .continua:
    cs cmp word [Multitarefa.StatusGeral], 0
    jne .fim
        cs inc word [Multitarefa.Contador]
        cs cmp word [Multitarefa.Simultaneos], 2
        jb .fim
            .proxTarefa:
            push ax
            push bx
            push cx
            push dx
            push ds
            push si
            push es
            push di
            push bp
            cli
            .trocaDeTarefas:
            mov ax, ss
            mov bx, sp

            cs mov si, [Multitarefa.ProcessoPonteiro]
            cs mov [si+ObjProcesso.Pilha], bx
            cs mov [si+ObjProcesso.Pilha+2], ax

            add si, ObjProcesso._Tam
            .buscaProximo:
                cmp si, Multitarefa.FimLista
                jae .fimLista
                cs cmp word [si+ObjProcesso.Status], StatusProcesso.Vazio
                je .fimLista
                cs cmp word [si+ObjProcesso.Status], StatusProcesso.Ativo
                je .encontrado
                add si, ObjProcesso._Tam
                jmp .buscaProximo
                .fimLista:
                    mov si, Multitarefa.Lista
                    jmp .buscaProximo
            .encontrado:

            cs mov [Multitarefa.ProcessoPonteiro], si
            cs mov ax, [si+ObjProcesso.Id]
            cs mov [Multitarefa.Processo], ax
            cs mov bx, [si+ObjProcesso.Pilha]
            cs mov ax, [si+ObjProcesso.Pilha+2]

            mov sp, bx
            mov ss, ax
            sti
            pop bp
            pop di
            pop es
            pop si
            pop ds
            pop dx
            pop cx
            pop bx
            pop ax
    .fim:
    iret
    .constPtrContinua: dw .continua

; ret: cf = 1=Encontrado | 0=Sem espaco
;      al = Processo
__multitarefaReserva:
    push si
    push cx
    ; Busca vazio
    mov si, Multitarefa.Lista
    mov cx, Multitarefa._Capacidade
    mov ax, 1
    .busca:
        ; Para multitarefas e impede interrupcoes
        pushf
        cli
        cs cmp word [si+ObjProcesso.Status], StatusProcesso.Ativo
        je .proximo
        cs cmp word [si+ObjProcesso.Status], StatusProcesso.Suspenso
        je .proximo
            cs mov [si+ObjProcesso.Id], ax
            cs mov word [si+ObjProcesso.Status], StatusProcesso.Suspenso
            jmp .encontrado
        .proximo:
        ; Retorna ao estado anterior das interrupcoes
        popf
        inc ax
        add si, ObjProcesso._Tam
        loop .busca
    clc
    xor ax, ax
    jmp .fim
    .encontrado:
    popf
    stc
    .fim:
    pop cx
    pop si
    ret

__multitarefaPonteiro:
    pushf
    push ax
    push dx
    push bx
    dec ax
    mov bx, ObjProcesso._Tam
    mul bx
    mov si, Multitarefa.Lista
    add si, ax
    pop bx
    pop dx
    pop ax
    popf
    ret

; ds:si = Endereco do arquivo
; ret: cf = 1=Ok | 0=Falha
;      ax = Numero do Processo
_multitarefaExecutaArquivo:
    push es
    push ds
    push si
    push di
    push BX
    push cx
    push dx
    ; Reserva numero do processo
    call __multitarefaReserva
    jnc .fim
    mov cx, 1024
    ; Guarda ds
    push ds
    pop dx
    push si
    cs call far [Memoria.AlocaLocal]
    pop si
    jc .okProcesso
        .falhaProcesso:
            call __multitarefaPonteiro
            cs mov word [si+ObjProcesso.Status], StatusProcesso.Encerrado
            clc
            jmp .fim
    .okProcesso:
    ; Guarda o numero do processo para uso futuro
    mov bx, ax
    ; Grava a pilha nova
    push si
    call __multitarefaPonteiro
    mov ax, ds
    cs mov [si+ObjProcesso.Pilha + 2], ax
    mov ax, 1024
    cs mov [si+ObjProcesso.Pilha], ax
    pop si
    ; Restaura ds
    push dx
    pop ds
    ; Carrega o arquivo
    cs call far [SisArq.AbreEnderecoRemoto]
    jnc .falhaProcesso
    es cmp word [di+ObjSisArq.Tipo], TipoSisArq.Arquivo
    je .ok
        .falhaArquivo:
        cs call far [SisArq.FechaRemoto]
        jmp .falhaProcesso
    .ok:
    cs call far [SisArq.CalculaTamanhoRemoto]
    jnc .falhaArquivo
    mov cx, ax
    mov ax, bx
    cs call far [Memoria.AlocaLocal]
    jnc .falhaArquivo
    xor si, si
    cs call far [SisArq.LeiaLocal]
    jnc .falhaArquivo
    cmp word [Prog.Assinatura], 1989
    jne .falhaArquivo
    cmp word [Prog.Compatibilidade], Prog._CompatibilidadeNivel
    ja .falhaArquivo
    mov [Prog.Processo], bx
    mov ax, ds
    mov es, ax
    call processaModulos
    jnc .falhaArquivo
    ; Para multitarefas e impede interrupcoes
    sti
    pushf
    pop dx
    push dx
    cli
    ; Guarda pilha atual
    mov ax, bx
    call __multitarefaPonteiro
    mov ax, ds
    cs mov [si+ObjProcesso.Segmento], ax
    mov ax, ss
    cs mov [.constSSNucleo], ax
    cs mov [.constSPNucleo], sp
    ; Abre nova pilha
    cs mov ax, [si+ObjProcesso.Pilha+2]
    mov ss, ax
    cs mov sp, [si+ObjProcesso.Pilha]
    ; Empilha RETF final
    push cs
    cs push word [.constPonteiroVolta]
    ; Empilha o IRET da multitarefa
    push dx
    push ds
    mov ax, [Prog.PtrInicial]
    push ax
    ; Empilha os registradores
    xor ax, ax
    push ax
    push ax
    push ax
    push ax
    push ds
    push ax
    push ds
    push ax
    push ax
    cs inc word [Multitarefa.Simultaneos]

    mov ax, bx
    call __multitarefaPonteiro
    
    cs mov word [si+ObjProcesso.Status], StatusProcesso.Ativo
    cs mov word [si+ObjProcesso.Pilha], sp

    ; Restaura pilha atual
    cs mov ax, [.constSSNucleo]
    cs mov sp, [.constSPNucleo]
    mov ss, ax
    ; Retorna ao estado anterior das interrupcoes
    popf
    stc
    .fim:
    pop dx
    pop cx
    pop bx
    pop di
    pop si
    pop ds
    pop es
    retf
    .constSSNucleo: dw 0
    .constSPNucleo: dw 0
    .constPonteiroVolta: dw __multitarefaVolta

__multitarefaVolta:
    push si
    push ax
    pushf
    cli
    cs mov ax, [Multitarefa.Processo]
    cs call far [Memoria.ExcluiProcesso]
    cs mov ax, [Multitarefa.Processo]
    call __multitarefaPonteiro
    cs mov word [si+ObjProcesso.Status], StatusProcesso.Encerrado
    cs dec word [Multitarefa.Simultaneos]
    popf
    pop ax
    pop si
    int 0x81
