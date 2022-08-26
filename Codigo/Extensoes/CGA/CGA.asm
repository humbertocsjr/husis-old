; =================
;  Controlador CGA
; =================
;
; Prototipo........: 25/08/2022
; Versao Inicial...: 25/08/2022
; Autor............: Humberto Costa dos Santos Junior
;
; Funcao...........: Controla dispositivo de video 
;
; Limitacoes.......: 
;
; Historico........:
;
; - 25/08/2022 - Humberto - Prototipo inicial
%include '../../Incluir/Prog.asm'

; Cabecalho do executavel

nome: db 'CGA',0
versao: dw 0,1,1
tipo: dw TipoProg.Executavel
modulos:
    dw 0

importar:
    %include '../../Incluir/Texto.asm'
    %include '../../Incluir/Memoria.asm'
    %include '../../Incluir/HUSIS.asm'
    %include '../../Incluir/Video.asm'
    dw 0
exportar:
    dw 0

; Rotinas Auxiliares

; Desenha um pixel
; ax = X
; bx = Y
; si = Cor
; ret: cf = 1=Ok | 0=Falha
Pixel:
    push ax
    push bx
    push cx
    push dx
    ; TEMPORARIO
    ; Faz uma chamada a BIOS, substituir pela escrita direta na memoria de 
    ; video
    mov cx, ax
    mov dx, bx
    mov ax, si
    mov ah, 0xc
    xor bx, bx
    int 0x10
    pop dx
    pop cx
    pop bx
    pop ax
    stc
    retf

; Rotina Principal

inicial:
    mov ax, 5
    int 0x10
    mov si, Pixel
    mov cx, 320
    mov dx, 200
    mov ax, 2
    cs call far [Video.RegistraVideo]
    cs call far [HUSIS.EntraEmModoBiblioteca]
    retf

Trad: