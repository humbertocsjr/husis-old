; ==================
;  Controlador PS/2
; ==================
;
; Prototipo........: 24/08/2022
; Versao Inicial...: 24/08/2022
; Autor............: Humberto Costa dos Santos Junior
;
; Funcao...........: Controla os dispositivos PS/2
;
; Limitacoes.......: 
;
; Historico........:
;
; - 24/08/2022 - Humberto - Prototipo inicial
%include '../../Incluir/Prog.asm'

nome: db 'PS2',0
versao: dw 0,1,1
tipo: dw TipoProg.Executavel
modulos:
    dw PS2
    dw 0



importar:
    %include '../../Incluir/Texto.asm'
    %include '../../Incluir/Memoria.asm'
    %include '../../Incluir/HUSIS.asm'
    dw 0
exportar:
    dw PS2
    db 'PS2',0
    dw 0

PS2: dw _ps2, 0
    .Envia: dw _ps2Envia,0
        ; dx = Porta
        ; al = Valor
        ; ret: cf = 1=Enviado | 0=Indisponivel
    .Disponivel: dw _ps2Disponivel,0
        ; dx = Porta
        ; ret: cf = 1=Dados disponiveis | 0=Indisponivel
    .PodeEnviar: dw _ps2PodeEnviar,0
        ; dx = Porta
        ; ret: cf = 1=Canal aberto | 0=Indisponivel
    dw 0
    .QtdPortas: dw 0
    .Simultaneos: dw 1
    .TipoPorta1: dw TipoPS2.Desconhecido
    .TipoPorta2: dw TipoPS2.Desconhecido

TipoPS2:
    .Desconhecido: equ 0
    .Teclado: equ 1
    .Mouse: equ 2

TipoPorta:
    .Dados: equ 0x60
    .Status: equ 0x64
    .Comando: equ 0x64

TipoComando:
    .LeByte00: equ 0x20
    .LeByte01: equ 0x21
    .LeByte02: equ 0x22
    .LeByte03: equ 0x23
    .LeByte04: equ 0x24
    .LeByte05: equ 0x25
    .LeByte06: equ 0x26
    .LeByte07: equ 0x27
    .LeByte08: equ 0x28
    .LeByte09: equ 0x29
    .LeByte0a: equ 0x2a
    .LeByte0b: equ 0x2b
    .LeByte0c: equ 0x2c
    .LeByte0d: equ 0x2d
    .LeByte0e: equ 0x2e
    .LeByte0f: equ 0x2f
    .LeByte10: equ 0x30
    .LeByte11: equ 0x31
    .LeByte12: equ 0x32
    .LeByte13: equ 0x33
    .LeByte14: equ 0x34
    .LeByte15: equ 0x35
    .LeByte16: equ 0x36
    .LeByte17: equ 0x37
    .LeByte18: equ 0x38
    .LeByte19: equ 0x39
    .LeByte1a: equ 0x3a
    .LeByte1b: equ 0x3b
    .LeByte1c: equ 0x3c
    .LeByte1d: equ 0x3d
    .LeByte1e: equ 0x3e
    .LeByte1f: equ 0x3f
    .GravaByte00: equ 0x60
    .GravaByte01: equ 0x61
    .GravaByte02: equ 0x62
    .GravaByte03: equ 0x63
    .GravaByte04: equ 0x64
    .GravaByte05: equ 0x65
    .GravaByte06: equ 0x66
    .GravaByte07: equ 0x67
    .GravaByte08: equ 0x68
    .GravaByte09: equ 0x69
    .GravaByte0a: equ 0x6a
    .GravaByte0b: equ 0x6b
    .GravaByte0c: equ 0x6c
    .GravaByte0d: equ 0x6d
    .GravaByte0e: equ 0x6e
    .GravaByte0f: equ 0x6f
    .GravaByte10: equ 0x70
    .GravaByte11: equ 0x71
    .GravaByte12: equ 0x72
    .GravaByte13: equ 0x73
    .GravaByte14: equ 0x74
    .GravaByte15: equ 0x75
    .GravaByte16: equ 0x76
    .GravaByte17: equ 0x77
    .GravaByte18: equ 0x78
    .GravaByte19: equ 0x79
    .GravaByte1a: equ 0x7a
    .GravaByte1b: equ 0x7b
    .GravaByte1c: equ 0x7c
    .GravaByte1d: equ 0x7d
    .GravaByte1e: equ 0x7e
    .GravaByte1f: equ 0x7f
    .DesativaPorta1: equ 0xad
    .AtivaPorta1: equ 0xae
    .DesativaPorta2: equ 0xa7
    .AtivaPorta2: equ 0xa8
    .TestaControlador: equ 0xaa
    .TestaPorta1: equ 0xab
    .LeiaEntrada: equ 0xc0
    .EscrevaSaida: equ 0xd0
    .CopiaBits0a3EmStatus4a7: equ 0xc1
    .CopiaBits4a7EmStatus4a7: equ 0xc2
    .EnviaViaPorta2: equ 0xd4
    .PulsaLinhaReset: equ 0xf0

TipoRespostaTesteControlador:
    .Ok: equ 0x55
    .Falha: equ 0xfc

TipoRespostaTestePorta:
    .Ok: equ 0
    .FalhaFrequenciaEmBaixa: equ 1
    .FalhaFrequenciaEmAlta: equ 2
    .FalhaDadosEmBaixa: equ 3
    .FalhaDadosEmAlta: equ 4

MascaraConfig:
    .IntPorta1:        equ 0b00000001
    .IntPorta2:        equ 0b00000010
    .Sistema:          equ 0b00000100
    .FrequenciaPorta1: equ 0b00010000
    .FrequenciaPorta2: equ 0b00100000
    .TraducaoPorta1:   equ 0b01000000
    .LimpaSempreZero:  equ 0b01110111
    .ConfLimpa:        equ 0b00110100

_ps2:
    cs mov word [PS2.Simultaneos], 1
    ; Descarta dados na entrada
    mov cx, 15
    mov dx, TipoPorta.Dados
    .lePortaDados:
        in al, dx
        loop .lePortaDados
    ; Desativa portas
    mov dx, TipoPorta.Comando
    mov al, TipoComando.DesativaPorta1
    out dx, al
    mov al, TipoComando.DesativaPorta2
    out dx, al
    ; Descarta dados na entrada
    mov cx, 15
    mov dx, TipoPorta.Dados
    .lePortaDados2:
        in al, dx
        loop .lePortaDados2
    ; Le configuracao
    mov dx, TipoPorta.Comando
    mov al, TipoComando.LeByte00
    out dx, al
    mov dx, TipoPorta.Dados
    in al, dx
    ; Configura desativando portas e traducao
    and al, MascaraConfig.LimpaSempreZero
    mov ah, MascaraConfig.IntPorta1
    not ah
    and al, ah
    mov ah, MascaraConfig.IntPorta2
    not ah
    and al, ah
    or al, MascaraConfig.FrequenciaPorta1
    or al, MascaraConfig.FrequenciaPorta2
    mov ah, MascaraConfig.TraducaoPorta1
    not ah
    and al, ah
    ; Guarda para enviar depois
    mov ah, al
    ; Envia o comando para substituir a config
    mov dx, TipoPorta.Comando
    mov al, TipoComando.GravaByte00
    out dx, al
    ; Envia a config
    mov al, ah
    mov dx, TipoPorta.Dados
    out dx, al
    ; Descarta dados na entrada
    mov cx, 15
    mov dx, TipoPorta.Dados
    .lePortaDados3:
        in al, dx
        loop .lePortaDados3
    ; Verifica Controladora
    mov al, TipoComando.TestaControlador
    mov dx, TipoPorta.Comando
    out dx, al
    mov dx, TipoPorta.Dados
    in al, dx
    cmp al, TipoRespostaTesteControlador.Ok
    je .controladoraOk
        mov al, TipoComando.GravaByte00
        mov dx, TipoPorta.Comando
        out dx, al
        mov dx, TipoPorta.Dados
        mov al, MascaraConfig.ConfLimpa
        out dx, al
    .controladoraOk:
    ; Descarta dados na entrada
    mov cx, 15
    mov dx, TipoPorta.Dados
    .lePortaDados4:
        in al, dx
        loop .lePortaDados4
    ; Valida a porta 2 
    mov dx, TipoPorta.Comando
    mov al, TipoComando.DesativaPorta2
    out dx, al
    ; Le configuracao
    mov dx, TipoPorta.Comando
    mov al, TipoComando.LeByte00
    out dx, al
    mov dx, TipoPorta.Dados
    in al, dx
    cs mov word [PS2.QtdPortas], 1
    and al, MascaraConfig.FrequenciaPorta2
    jne .ignoraPorta2
        cs mov word [PS2.QtdPortas], 2
        mov dx, TipoPorta.Comando
        mov al, TipoComando.AtivaPorta2
        out dx, al
    .ignoraPorta2:
    mov dx, TipoPorta.Comando
    mov al, TipoComando.AtivaPorta1
    out dx, al
    cs mov word [PS2.Simultaneos], 0


    retf

__ps2AguardaExclusivo:
    pushf
    cli
    cs cmp word [PS2.Simultaneos], 0
    je .ok
        popf
        cs call far [HUSIS.ProximaTarefa]
        jmp __ps2AguardaExclusivo
    .ok:
    cs inc word [PS2.Simultaneos]
    popf
    ret

__ps2LiberaExclusivo:
    pushf
    cs dec word [PS2.Simultaneos]
    popf
    ret

_ps2Envia:
    call __ps2AguardaExclusivo
    push dx
    push cx
    push si
    cs cmp dx, [PS2.QtdPortas]
    jbe .ok
        clc
        jmp .fim
    .ok:
    mov cx, 10
    .espera:
        cs call far [PS2.PodeEnviar]
        jc .envia
        cs call far [HUSIS.ProximaTarefa]
        loop .espera
    clc
    jmp .fim
    .envia:
        cmp dx, 2
        jne .ignoraPorta2
            push ax
            mov dx, TipoPorta.Comando
            mov al, TipoComando.EnviaViaPorta2
            out dx, al
            pop ax 
        .ignoraPorta2:
        mov dx, TipoPorta.Dados
        out dx, al
        stc
    .fim:
    pop si
    pop cx
    pop dx
    call __ps2LiberaExclusivo
    retf


_ps2Disponivel:
    call __ps2AguardaExclusivo
    push ax
    push dx
    push si
    cs cmp dx, [PS2.QtdPortas]
    jbe .ok
        clc
        jmp .fim
    .ok:
    mov dx, TipoPorta.Status
    in al, dx
    and al, 1
    cmp al, 1
    je .pode
        clc
        jmp .fim
    .pode:
        stc
    .fim:
    pop si
    pop dx
    pop ax
    call __ps2LiberaExclusivo
    retf

_ps2PodeEnviar:
    call __ps2AguardaExclusivo
    push ax
    push dx
    push si
    cs cmp dx, [PS2.QtdPortas]
    jbe .ok
        clc
        jmp .fim
    .ok:
    mov dx, TipoPorta.Status
    in al, dx
    and al, 2
    cmp al, 0
    je .pode
        clc
        jmp .fim
    .pode:
        stc
    .fim:
    pop si
    pop dx
    pop ax
    call __ps2LiberaExclusivo
    retf

inicial:
    cs call far [PS2]
    cs call far [HUSIS.EntraEmModoBiblioteca]
    retf

Trad: