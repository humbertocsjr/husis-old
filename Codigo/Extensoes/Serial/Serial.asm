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

; Cabecalho do executavel

nome: db 'Serial',0
versao: dw 0,1,1
tipo: dw TipoProg.Executavel
modulos:
    dw Serial
    dw 0



importar:
    %include '../../Incluir/Texto.asm'
    %include '../../Incluir/Memoria.asm'
    %include '../../Incluir/HUSIS.asm'
    dw 0
exportar:
    dw Serial
    db 'Serial',0
    dw 0

; Enumeradores usados

TipoConexaoSerial:
    .Trans8SemPariedade1Parada:       equ 0xb00000011
    .Trans8PariedadeImpar1Parada:     equ 0xb00001011
    .Trans8PariedadePar1Parada:       equ 0xb00011011
    .Trans8PariedadeAlta1Parada:      equ 0xb00101011
    .Trans8PariedadeBaixa1Parada:     equ 0xb00111011
    .Trans8SemPariedade2Parada:       equ 0xb00000111
    .Trans8PariedadeImpar2Parada:     equ 0xb00001111
    .Trans8PariedadePar2Parada:       equ 0xb00011111
    .Trans8PariedadeAlta2Parada:      equ 0xb00101111
    .Trans8PariedadeBaixa2Parada:     equ 0xb00111111
    .Trans7SemPariedade1Parada:       equ 0xb00000010
    .Trans7PariedadeImpar1Parada:     equ 0xb00001010
    .Trans7PariedadePar1Parada:       equ 0xb00011010
    .Trans7PariedadeAlta1Parada:      equ 0xb00101010
    .Trans7PariedadeBaixa1Parada:     equ 0xb00111010
    .Trans7SemPariedade2Parada:       equ 0xb00000110
    .Trans7PariedadeImpar2Parada:     equ 0xb00001110
    .Trans7PariedadePar2Parada:       equ 0xb00011110
    .Trans7PariedadeAlta2Parada:      equ 0xb00101110
    .Trans7PariedadeBaixa2Parada:     equ 0xb00111110

; Modulos exportados

Serial: dw _serial, 0
    .IniciaPorta: dw _serialIniciaPorta,0
        ; dx = Porta (1-4)
        ; ax = Velocidade (300,1200,2400,4800,9600,14400,19200,38400,57600)
        ; bx = TipoConexaoSerial
    .Envia: dw _serialEnvia,0
        ; dx = Porta
        ; al = Valor
        ; ret: cf = 1=Enviado | 0=Indisponivel
    .Recebe: dw _serialRecebe,0
        ; dx = Porta
        ; ret: cf = 1=Recebido | 0=Indisponivel
        ;      ah = 0
        ;      al = valor
    .Disponivel: dw _serialDisponivel,0
        ; dx = Porta
        ; ret: cf = 1=Dados disponiveis | 0=Indisponivel
    .PodeEnviar: dw _serialPodeEnviar,0
        ; dx = Porta
        ; ret: cf = 1=Canal aberto | 0=Indisponivel
    dw 0
    ._CapacidadePortas: equ 4
    .Portas:
        dw 0x3f8
        dw 0x2F8
        dw 0x3E8
        dw 0x2E8

; Rotinas do modulo Serial

_serial:
    retf

_serialIniciaPorta:
    push ax
    push bx
    push cx
    push dx
    push si
    dec dx
    cmp dx, Serial._CapacidadePortas
    jb .ok
        clc
        jmp .fim
    .ok:
    cmp ax, 300
    je .v300
    cmp ax, 1200
    je .v1200
    cmp ax, 2400
    je .v2400
    cmp ax, 4800
    je .v4800
    cmp ax, 9600
    je .v9600
    cmp ax, 14400
    je .v14400
    cmp ax, 19200
    je .v19200
    cmp ax, 38400
    je .v38400
    cmp ax, 57600
    je .v57600
    clc
    jmp .fim
    .v300:
        mov cx, 384
        jmp .continua
    .v1200:
        mov cx, 96
        jmp .continua
    .v2400:
        mov cx, 48
        jmp .continua
    .v4800:
        mov cx, 24
        jmp .continua
    .v9600:
        mov cx, 12
        jmp .continua
    .v14400:
        mov cx, 8
        jmp .continua
    .v19200:
        mov cx, 6
        jmp .continua
    .v38400:
        mov cx, 3
        jmp .continua
    .v57600:
        mov cx, 2
        jmp .continua
    .continua:
    mov si, dx
    add si, dx
    add si, Serial.Portas
    push bx
    cs mov bx, [si]
    ; Desativa interrupcoes
    mov dx, bx
    add dx, 1
    mov ax, 0
    out dx, al
    ; Ativa dlab para definir a velocidade
    mov dx, bx
    add dx, 3
    mov ax, 0x80
    out dx, al
    ; Envia a velocidade cl
    mov dx, bx
    mov al, cl
    out dx, al
    ; Envia a velocidade ch
    mov dx, bx
    add dx, 1
    mov al, ch
    out dx, al
    ; Envia o tipo
    mov dx, bx
    add dx, 3
    pop bx
    mov al, bl
    cs mov bx, [si]
    out dx, al
    ; Ativa fifo de 14 bytes e limpa o conteudo
    mov dx, bx
    add dx, 2
    mov al, 0xc7
    out dx, al
    
    mov dx, bx
    add dx, 4
    mov al, 0x0b
    out dx, al

    mov al, 0x1e
    out dx, al
    
    mov dx, bx
    mov al, 0xae
    out dx, al

    in al, dx
    cmp al, 0xae
    je .sucesso
        clc
        jmp .fim
    .sucesso:
    mov dx, bx
    add dx, 4
    mov al, 0x0f
    out dx, al
    stc
    .fim:
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    retf

_serialEnvia:
    push dx
    push si
    cs call far [Serial.PodeEnviar]
    jnc .fim
        dec dx
        mov si, dx
        add si, dx
        add si, Serial.Portas
        cs mov dx, [si]
        out dx, al
        stc
    .fim:
    pop si
    pop dx
    retf

_serialRecebe:
    push dx
    push si
    cs call far [Serial.Disponivel]
    jnc .fim
        dec dx
        mov si, dx
        add si, dx
        add si, Serial.Portas
        cs mov dx, [si]
        xor ax, ax
        in al, dx
        stc
    .fim:
    pop si
    pop dx
    retf

_serialDisponivel:
    push ax
    push dx
    push si
    dec dx
    cmp dx, Serial._CapacidadePortas
    jb .ok
        clc
        jmp .fim
    .ok:
    mov si, dx
    add si, dx
    add si, Serial.Portas
    cs mov dx, [si]
    add dx, 5
    in al, dx
    and al, 1
    cmp al, 1
    je .sim
        clc 
        jmp .fim
    .sim:
    stc
    .fim:
    pop si
    pop dx
    pop ax
    retf

_serialPodeEnviar:
    push ax
    push dx
    push si
    dec dx
    cmp dx, Serial._CapacidadePortas
    jb .ok
        clc
        jmp .fim
    .ok:
    mov si, dx
    add si, dx
    add si, Serial.Portas
    cs mov dx, [si]
    add dx, 5
    in al, dx
    and al, 0x20
    cmp al, 0x20
    je .sim
        clc 
        jmp .fim
    .sim:
    stc
    .fim:
    pop si
    pop dx
    pop ax
    retf


; Rotina principal
inicial:
    cs call far [Serial]
    cs call far [HUSIS.EntraEmModoBiblioteca]
    retf

Trad: