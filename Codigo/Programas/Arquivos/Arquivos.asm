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
    %include '../../Incluir/Video.asm'
    %include '../../Incluir/Interface.asm'
    %include '../../Incluir/ObjControle.asm'
    dw 0
exportar:
    dw 0

Arquivos: dw _arquivos, 0
    dw 0
    .Copyright: db 'Copyright (c) 2022\nHumberto Costa dos Santos Junior\n(humbertocsjr)',0
    .JanelaPrincipal: dw 0,0

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
    mov ax, es
    cs mov [Arquivos.JanelaPrincipal+2], ax
    cs mov [Arquivos.JanelaPrincipal], di
    mov si, Trad.Sobre
    cs call far [Interface.IniciaJanelaTradRemoto]
    push cs
    pop ds
    mov si, icone
    cs call far [Interface.AlteraExtensaoRemoto]
    mov cx, 10
    mov dx, 10
    cs call far [Interface.AlteraPosInicialRemoto]
    mov cx, 230
    mov dx, 74
    cs call far [Interface.AlteraTamanhoRemoto]
    cs call far [Interface.AdicionaJanelaRemota]

    ; Rotulo
    cs call far [Interface.AlocaSubControleRemoto]
    jnc .fim
    mov si, Trad.Titulo
    cs call far [Interface.IniciaRotuloTradRemoto]
    mov cx, 2
    mov dx, 2
    cs call far [Interface.AlteraPosInicialRemoto]
    mov cx, 220
    mov dx, 11
    cs call far [Interface.AlteraTamanhoRemoto]
    cs call far [Interface.ExibeRemoto]
    
    cs mov ax, [Arquivos.JanelaPrincipal+2] 
    mov es, ax
    cs mov di, [Arquivos.JanelaPrincipal]

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
    
    cs mov ax, [Arquivos.JanelaPrincipal+2] 
    mov es, ax
    cs mov di, [Arquivos.JanelaPrincipal]
    cs call far [Interface.ExibeRemoto]
    .fim:
    retf

inicial:
    cs call far [Arquivos]

        cs mov di, [Arquivos.JanelaPrincipal]
        cs mov ax, [Arquivos.JanelaPrincipal+2]
        mov es, ax
        ;cs call far [Interface.OcultaRemoto]
        ;
        ; VER PQ NAO TA GRAVANDO O ABAIXO
        ;
        ; se tivesse um abaixo ele deveria reexibir a tela como ta ali
        es cmp word [di+ObjControle.PtrAbaixo+2],0
        je .loop
            mov cx, 10
            .tmp:
                cs call far [HUSIS.ProximaTarefa]
                loop .tmp
            ;cs call far [Interface.ExibeRemoto]
    .loop:
        cs call far [HUSIS.ProximaTarefa]
        jmp .loop
    retf