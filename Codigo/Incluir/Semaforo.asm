
Semaforo: dw ._Fim
    db 'HUSIS',0
    db 'Semaforo',0
    ; Impede que dois processos acessem o mesmo recurso de uma biblioteca
    .Cria: dw 1,0
        ; cs:si = Ponteiro para uma variavel estatica de 2 Bytes de tamanho(dw)
        ;         que sera usado excluisivamente por essas funcoes
    .Solicita: dw 1,0
        ; Espera ate estar disponivel (Apenas deve ser usado uma vez por 
        ;  processo simultaneamente, usado em ambiente multitarefa)
        ; cs:si = Semaforo
    .Libera: dw 1,0
        ; Deve ser OBRIGATORIAMENTE usado ao final da funcao depois de uma
        ; solicitacao
        ; cs:si = Semaforo
    ._Fim: