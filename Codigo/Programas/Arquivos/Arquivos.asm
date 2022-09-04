; =========================
;  Gerenciador de Arquivos
; =========================
;
; Prototipo........: 01/09/2022
; Versao Inicial...: 01/09/2022
; Autor............: Humberto Costa dos Santos Junior
;
; Funcao...........: Aplicativo principal do sistema para gerenciamento de 
;                    arquivos
;
; Limitacoes.......: 
;
; Historico........:
;
; - 01/09/2022 - Humberto - Prototipo inicial
%include '../../Incluir/Prog.asm'

nome: db 'Arquivos',0
versao: dw 0,1,1
tipo: dw TipoProg.Executavel
modulos:
    dw JanSobre
    dw JanPrincipal
    dw 0
    %include 'JanPrincipal.asm'
    %include 'JanSobre.asm'
importar:
    %include '../../Incluir/Texto.asm'
    %include '../../Incluir/Memoria.asm'
    %include '../../Incluir/HUSIS.asm'
    %include '../../Incluir/ObjControle.asm'
    %include '../../Incluir/Interface.asm'
    %include '../../Incluir/Semaforo.asm'
    %include '../../Incluir/SisArq.asm'
    %include '../../Incluir/Listas.asm'
    dw 0
exportar:
    dw 0

Copyright: db 'Copyright (c) 2022, Humberto Costa dos Santos Junior',0


inicial:
    cs call far [JanPrincipal]
    .loop:
        cs call far [HUSIS.ProximaTarefa]
        jmp .loop
    retf
    .constTeste: db 'Teste 123 123 123 123 132 123 123 123 123',0
