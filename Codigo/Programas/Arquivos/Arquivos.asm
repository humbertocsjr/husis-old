; ====================
;  Controlador Serial
; ====================
;
; Prototipo........: 23/08/2022
; Versao Inicial...: 23/08/2022
; Autor............: Humberto Costa dos Santos Junior
;
; Funcao...........: Controla os dispositivos Serial
;
; Limitacoes.......: 
;
; Historico........:
;
; - 23/08/2022 - Humberto - Prototipo inicial
%include '../../Incluir/Prog.asm'

nome: db 'Arquivos',0
versao: dw 0,1,1
tipo: dw TipoProg.Executavel
modulos:
    dw Arquivos
    dw 0
importar:
    %include '../../Incluir/Texto.asm'
    %include '../../Incluir/Memoria.asm'
    %include '../../Incluir/HUSIS.asm'
    %include '../../Incluir/Interface.asm'
    %include '../../Incluir/ObjControle.asm'
    dw 0
exportar:
    dw 0

Arquivos: dw _arquivos, 0
    dw 0
    .Copyright: db 'Copyright (c) 2022\nHumberto Costa dos Santos Junior\n(humbertocsjr)',0

icone:
    dw 0,16,16
    db 0b00000000,0b00000000
    db 0b00100000,0b00000000
    db 0b01110110,0b11101100
    db 0b00100000,0b00000000
    db 0b00000100,0b00000000
    db 0b00101110,0b11011100
    db 0b00000100,0b00000000
    db 0b00100000,0b00000000
    db 0b00000100,0b00000000
    db 0b00101110,0b11101100
    db 0b00000100,0b00000000
    db 0b00100000,0b00000000
    db 0b00000100,0b00000000
    db 0b00101110,0b10110100
    db 0b00000100,0b00000000
    db 0b00000000,0b00000000

_arquivos:
    cs call far [Interface.AlocaControleRemoto]
    mov si, Trad.Titulo
    cs call far [Interface.IniciaJanelaTradRemoto]
    push cs
    pop ds
    mov si, icone
    cs call far [Interface.AlteraExtensaoRemoto]
    mov cx, 10
    mov dx, 10
    cs call far [Interface.AlteraPosInicialRemoto]
    mov cx, 230
    mov dx, 70
    cs call far [Interface.AlteraTamanhoRemoto]
    cs call far [Interface.ExibeRemoto]
    cs call far [Interface.AdicionaJanelaRemota]
    push es
    push di

    ; Rotulo
    cs call far [Interface.AlocaSubControleRemoto]
    mov si, Trad.Titulo
    cs call far [Interface.IniciaRotuloTradRemoto]
    mov cx, 2
    mov dx, 2
    cs call far [Interface.AlteraPosInicialRemoto]
    mov cx, 220
    mov dx, 11
    cs call far [Interface.AlteraTamanhoRemoto]
    cs call far [Interface.ExibeRemoto]

    pop di
    pop es
    ; Rotulo
    cs call far [Interface.AlocaSubControleRemoto]
    mov si, Arquivos.Copyright
    cs call far [Interface.IniciaRotuloRemoto]
    mov cx, 2
    mov dx, 15
    cs call far [Interface.AlteraPosInicialRemoto]
    mov cx, 220
    mov dx, 40
    cs call far [Interface.AlteraTamanhoRemoto]
    cs call far [Interface.ExibeRemoto]
    retf

inicial:
    cs call far [Arquivos]
    .loop:
        cs call far [HUSIS.ProximaTarefa]
        jmp .loop
    retf