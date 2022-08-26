; Arquivo de inclusao das funcoes do nucleo
HUSIS: dw ._Fim
    db 'HUSIS',0
    db 'HUSIS',0
    .ProcessoAtual: dw 1, 0
        ; ret: al = Processo atual
    .ProximaTarefa: dw 1, 0
        ; Executa proximo processo pendente, encerrando o tempo de execucao
        ; ate a proxima passagem do gestor de multitarefa (Yield)
    .EntraEmModoBiblioteca: dw 1, 0
        ; Encerra a execucao da rotina principal deste executavel, limitando
        ; seu uso atraves das rotinas dos modulos que exporta
    .Debug: dw 1,0
    ._Fim: