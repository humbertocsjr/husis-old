; =========
;  Semaforo
; =========
;
; Prototipo........: 24/08/2022
; Versao Inicial...: 24/08/2022
; Autor............: Humberto Costa dos Santos Junior
;
; Funcao...........: Implementa o Semaforo de Multitarefa
;
; Limitacoes.......: 
;
; Historico........:
;
; - 24/08/2022 - Humberto - Versao inicial

Semaforo: dw _semaforo, 0
    ; Impede que dois processos acessem o mesmo recurso de uma biblioteca
    .Cria: dw _semaforoCria,0
        ; cs:si = Ponteiro para uma variavel estatica de 2 Bytes de tamanho(dw)
        ;         que sera usado excluisivamente por essas funcoes
    .Solicita: dw _semaforoSolicita,0
        ; Espera ate estar disponivel (Apenas deve ser usado uma vez por 
        ;  processo simultaneamente, usado em ambiente multitarefa)
        ; cs:si = Semaforo
    .Libera: dw _semaforoLibera,0
        ; Deve ser OBRIGATORIAMENTE usado ao final da funcao depois de uma
        ; solicitacao
        ; cs:si = Semaforo
    dw 0

_semaforo:
    retf

_semaforoCria:
    push bp
    mov bp, sp
    push ax
    push ds
    mov ax, [bp+4]
    mov ds, ax
    cs mov word [si], 0
    pop ds
    pop ax
    pop bp
    retf

_semaforoSolicita:
    push bp
    mov bp, sp
    push ax
    push ds
    mov ax, [bp+4]
    mov ds, ax
    .tenta:
        pushf
        cli
        cs cmp word [si], 0
        je .fim
            popf
            cs call far [HUSIS.ProximaTarefa]
            jmp .tenta
    .fim:
    cs mov word [si], 1
    popf
    pop ds
    pop ax
    pop bp
    retf

_semaforoLibera:
    push bp
    mov bp, sp
    push ax
    push ds
    mov ax, [bp+4]
    mov ds, ax
    cs mov word [si], 0
    pop ds
    pop ax
    pop bp
    retf