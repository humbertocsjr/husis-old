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
    .Ativo: equ 10
    .Suspenso: equ 20

Multitarefa: dw _multitarefa,0
    .Suspende: dw _multitarefaSuspende, 0
    .Reativa: dw _multitarefaReativa, 0
    dw 0
    .Simultaneos: dw 1
    .ProcessoAtual: dw 0
    .StatusGeral: dw 0
    .Int8: dw 0, 0
    .Contador: dw 0
    ._Capacidade: equ 128
    .Lista: times ObjProcesso._Tam * ._Capacidade db 0
    .FimLista:

_multitarefa:
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
    cs mov [Multitarefa.ProcessoAtual], si
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
    sti
    pop ds
    retf

_multitarefaSuspende:
    cs inc word [Multitarefa.StatusGeral]
    retf

_multitarefaReativa:
    cs cmp word [Multitarefa.StatusGeral], 0
    je .fim
        cs dec word [Multitarefa.StatusGeral]
    .fim:
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
            mov ax, ss
            mov bx, sp

            cs mov si, [Multitarefa.ProcessoAtual]
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

            cs mov [Multitarefa.ProcessoAtual], si
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