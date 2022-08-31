Teclado: dw _teclado,0
    .Disponivel: dw _tecladoDisponivel,0
    .Leia: dw _tecladoLeia,0
    .Registra: dw _tecladoRegistra, 0
; USO INTERNO
    .PtrDisponivel: dw _tecladoDisponivel.inicio, 0
    .PtrLeia: dw _tecladoLeia.inicio, 0
    .PtrTabela: dw _tecladoTabela, 0
    dw 0
    .Extendido: dw 0

_teclado:
    push ax
    mov ax, 0x12ff
    int 0x16
    cmp al, 0xff
    je .fim
        cs mov word [Teclado.Extendido], 1
    .fim:
    pop ax
    retf

_tecladoDisponivel:
    cs jmp far [Teclado.PtrDisponivel]
    .inicio:
    push ax
    cs cmp word [Teclado.Extendido], 0
    je .xt
        mov ax, 0x1100
        int 0x16
        jz .nao
        jmp .sim
    .xt:
        mov ax, 0x100
        int 0x16
        jz .nao
        jmp .sim
    .nao:
        clc
        jmp .fim
    .sim:
        stc
    .fim:
    pop ax
    retf

_tecladoLeia:
    cs jmp far [Teclado.PtrLeia]
    .inicio:
    cs cmp word [Teclado.Extendido], 0
    je .xt
        mov ax, 0x1000
        int 0x16
        jmp .ok
    .xt:
        mov ax, 0x000
        int 0x16
    .ok:
        call __tecladoProcessar
    .fim:
    retf

_tecladoRegistra:
    retf

; ax = Scan code
__tecladoProcessar:
    push ds
    push si
    cs push word [Teclado.PtrTabela + 2]
    pop ds
    cs mov si, [Teclado.PtrTabela]
    .procura:
        cmp word [si+ObjTecla.SaidaAscii], ObjTecla._AsciiFimDaLista
        je .naoEncontrado
        cmp ax, [si+ObjTecla.ScanNormal]
        je .normal
        cmp ax, [si+ObjTecla.ScanShift]
        je .shift
        cmp ax, [si+ObjTecla.ScanCtrl]
        je .ctrl
        cmp ax, [si+ObjTecla.ScanAlt]
        je .alt
        add si, ObjTecla._Tam
        jmp .procura
        .normal:
            mov ax, [si+ObjTecla.SaidaAscii]
            mov bx, [si+ObjTecla.SaidaTeclaEspecial]
            mov cx, TipoTeclaAdicional.Nenhuma
            jmp .encontrado
        .shift:
            mov ax, [si+ObjTecla.SaidaAscii]
            mov bx, [si+ObjTecla.SaidaTeclaEspecial]
            mov cx, TipoTeclaAdicional.Shift
            jmp .encontrado
        .alt:
            mov ax, [si+ObjTecla.SaidaAscii]
            mov bx, [si+ObjTecla.SaidaTeclaEspecial]
            mov cx, TipoTeclaAdicional.Alt
            jmp .encontrado
        .ctrl:
            mov ax, [si+ObjTecla.SaidaAscii]
            mov bx, [si+ObjTecla.SaidaTeclaEspecial]
            mov cx, TipoTeclaAdicional.Ctrl
            jmp .encontrado
    .naoEncontrado:
        xor ax, ax
        xor bx, bx
        xor cx, cx
        clc
        jmp .fim
    .encontrado:
        stc
    .fim
    pop si
    pop ds
    ret

ObjTecla:
    ._AsciiFimDaLista: equ 0xffff
    .SaidaAscii: equ 0
    .SaidaTeclaEspecial: equ 2
    .ScanNormal: equ 4
    .ScanShift: equ 6
    .ScanCtrl: equ 8
    .ScanAlt: equ 10
    ._Tam: equ 12

_tecladoTabela:
    dw 'a', TipoTeclaEspecial.Nenhuma, 0x1e61, 0x0000, 0x0000, 0x0000
    dw 'b', TipoTeclaEspecial.Nenhuma, 0x3062, 0x0000, 0x0000, 0x0000
    dw 'c', TipoTeclaEspecial.Nenhuma, 0x2E63, 0x0000, 0x0000, 0x0000
    dw 'd', TipoTeclaEspecial.Nenhuma, 0x2064, 0x0000, 0x0000, 0x0000
    dw 'e', TipoTeclaEspecial.Nenhuma, 0x1265, 0x0000, 0x0000, 0x0000
    dw 'f', TipoTeclaEspecial.Nenhuma, 0x2166, 0x0000, 0x0000, 0x0000
    dw 'g', TipoTeclaEspecial.Nenhuma, 0x2267, 0x0000, 0x0000, 0x0000
    dw 'h', TipoTeclaEspecial.Nenhuma, 0x2368, 0x0000, 0x0000, 0x0000
    dw 'i', TipoTeclaEspecial.Nenhuma, 0x1769, 0x0000, 0x0000, 0x0000
    dw 'j', TipoTeclaEspecial.Nenhuma, 0x246A, 0x0000, 0x0000, 0x0000
    dw 'k', TipoTeclaEspecial.Nenhuma, 0x256B, 0x0000, 0x0000, 0x0000
    dw 'l', TipoTeclaEspecial.Nenhuma, 0x266C, 0x0000, 0x0000, 0x0000
    dw 'm', TipoTeclaEspecial.Nenhuma, 0x326D, 0x0000, 0x0000, 0x0000
    dw 'n', TipoTeclaEspecial.Nenhuma, 0x316E, 0x0000, 0x0000, 0x0000
    dw 'o', TipoTeclaEspecial.Nenhuma, 0x186F, 0x0000, 0x0000, 0x0000
    dw 'p', TipoTeclaEspecial.Nenhuma, 0x1970, 0x0000, 0x0000, 0x0000
    dw 'q', TipoTeclaEspecial.Nenhuma, 0x1071, 0x0000, 0x0000, 0x0000
    dw 'r', TipoTeclaEspecial.Nenhuma, 0x1372, 0x0000, 0x0000, 0x0000
    dw 's', TipoTeclaEspecial.Nenhuma, 0x1F73, 0x0000, 0x0000, 0x0000
    dw 't', TipoTeclaEspecial.Nenhuma, 0x1474, 0x0000, 0x0000, 0x0000
    dw 'u', TipoTeclaEspecial.Nenhuma, 0x1675, 0x0000, 0x0000, 0x0000
    dw 'v', TipoTeclaEspecial.Nenhuma, 0x2F76, 0x0000, 0x0000, 0x0000
    dw 'w', TipoTeclaEspecial.Nenhuma, 0x1177, 0x0000, 0x0000, 0x0000
    dw 'x', TipoTeclaEspecial.Nenhuma, 0x2D78, 0x0000, 0x0000, 0x0000
    dw 'y', TipoTeclaEspecial.Nenhuma, 0x1579, 0x0000, 0x0000, 0x0000
    dw 'z', TipoTeclaEspecial.Nenhuma, 0x2C7A, 0x0000, 0x0000, 0x0000
    dw 'A', TipoTeclaEspecial.Nenhuma, 0x0000, 0x1E41, 0x1E01, 0x1E00
    dw 'B', TipoTeclaEspecial.Nenhuma, 0x0000, 0x3042, 0x3002, 0x3000
    dw 'C', TipoTeclaEspecial.Nenhuma, 0x0000, 0x2E42, 0x2E03, 0x2E00
    dw 'D', TipoTeclaEspecial.Nenhuma, 0x0000, 0x2044, 0x2004, 0x2000
    dw 'E', TipoTeclaEspecial.Nenhuma, 0x0000, 0x1245, 0x1205, 0x1200
    dw 'F', TipoTeclaEspecial.Nenhuma, 0x0000, 0x2146, 0x2106, 0x2100
    dw 'G', TipoTeclaEspecial.Nenhuma, 0x0000, 0x2247, 0x2207, 0x2200
    dw 'H', TipoTeclaEspecial.Nenhuma, 0x0000, 0x2348, 0x2308, 0x2300
    dw 'I', TipoTeclaEspecial.Nenhuma, 0x0000, 0x1749, 0x1709, 0x1700
    dw 'J', TipoTeclaEspecial.Nenhuma, 0x0000, 0x244A, 0x240A, 0x2400
    dw 'K', TipoTeclaEspecial.Nenhuma, 0x0000, 0x254B, 0x250B, 0x2500
    dw 'L', TipoTeclaEspecial.Nenhuma, 0x0000, 0x264C, 0x260C, 0x2600
    dw 'M', TipoTeclaEspecial.Nenhuma, 0x0000, 0x324D, 0x320D, 0x3200
    dw 'N', TipoTeclaEspecial.Nenhuma, 0x0000, 0x314E, 0x310E, 0x3100
    dw 'O', TipoTeclaEspecial.Nenhuma, 0x0000, 0x184F, 0x180F, 0x1800
    dw 'P', TipoTeclaEspecial.Nenhuma, 0x0000, 0x1950, 0x1910, 0x1900
    dw 'Q', TipoTeclaEspecial.Nenhuma, 0x0000, 0x1051, 0x1011, 0x1000
    dw 'R', TipoTeclaEspecial.Nenhuma, 0x0000, 0x1352, 0x1312, 0x1300
    dw 'S', TipoTeclaEspecial.Nenhuma, 0x0000, 0x1F53, 0x1F13, 0x1F00
    dw 'T', TipoTeclaEspecial.Nenhuma, 0x0000, 0x1454, 0x1414, 0x1400
    dw 'U', TipoTeclaEspecial.Nenhuma, 0x0000, 0x1655, 0x1615, 0x1600
    dw 'V', TipoTeclaEspecial.Nenhuma, 0x0000, 0x2F56, 0x2F16, 0x2F00
    dw 'W', TipoTeclaEspecial.Nenhuma, 0x0000, 0x1157, 0x1117, 0x1100
    dw 'X', TipoTeclaEspecial.Nenhuma, 0x0000, 0x2D58, 0x2D18, 0x2D00
    dw 'Y', TipoTeclaEspecial.Nenhuma, 0x0000, 0x1559, 0x1519, 0x1500
    dw 'Z', TipoTeclaEspecial.Nenhuma, 0x0000, 0x2C5A, 0x2C1A, 0x2C00

    dw '1', TipoTeclaEspecial.Nenhuma, 0x0231, 0x0000, 0x0000, 0x7800
    dw '2', TipoTeclaEspecial.Nenhuma, 0x0332, 0x0000, 0x0300, 0x7900
    dw '3', TipoTeclaEspecial.Nenhuma, 0x0433, 0x0000, 0x0000, 0x7A00
    dw '4', TipoTeclaEspecial.Nenhuma, 0x0534, 0x0000, 0x0000, 0x7B00
    dw '5', TipoTeclaEspecial.Nenhuma, 0x0635, 0x0000, 0x0000, 0x7C00
    dw '6', TipoTeclaEspecial.Nenhuma, 0x0736, 0x0000, 0x071E, 0x7D00
    dw '7', TipoTeclaEspecial.Nenhuma, 0x0837, 0x0000, 0x0000, 0x7E00
    dw '8', TipoTeclaEspecial.Nenhuma, 0x0938, 0x0000, 0x0000, 0x7F00
    dw '9', TipoTeclaEspecial.Nenhuma, 0x0A39, 0x0000, 0x0000, 0x8000
    dw '0', TipoTeclaEspecial.Nenhuma, 0x0B30, 0x0000, 0x0000, 0x8100

    dw '!', TipoTeclaEspecial.Nenhuma, 0x0000, 0x0221, 0x0000, 0x0000
    dw '@', TipoTeclaEspecial.Nenhuma, 0x0000, 0x0340, 0x0000, 0x0000
    dw '#', TipoTeclaEspecial.Nenhuma, 0x0000, 0x0423, 0x0000, 0x0000
    dw '$', TipoTeclaEspecial.Nenhuma, 0x0000, 0x0524, 0x0000, 0x0000
    dw '%', TipoTeclaEspecial.Nenhuma, 0x0000, 0x0625, 0x0000, 0x0000
    dw '^', TipoTeclaEspecial.Nenhuma, 0x0000, 0x075E, 0x0000, 0x0000
    dw '&', TipoTeclaEspecial.Nenhuma, 0x0000, 0x0826, 0x0000, 0x0000
    dw '*', TipoTeclaEspecial.Nenhuma, 0x0000, 0x092A, 0x0000, 0x0000
    dw '(', TipoTeclaEspecial.Nenhuma, 0x0000, 0x0A28, 0x0000, 0x0000
    dw ')', TipoTeclaEspecial.Nenhuma, 0x0000, 0x0B29, 0x0000, 0x0000

    dw '-', TipoTeclaEspecial.Nenhuma, 0x0C2D, 0x0000, 0x0C1F, 0x8200
    dw '=', TipoTeclaEspecial.Nenhuma, 0x0D3D, 0x0000, 0x0000, 0x8300
    dw '[', TipoTeclaEspecial.Nenhuma, 0x1A5B, 0x0000, 0x1A1B, 0x1A00
    dw ']', TipoTeclaEspecial.Nenhuma, 0x1B5D, 0x0000, 0x1B1D, 0x1B00
    dw ';', TipoTeclaEspecial.Nenhuma, 0x273B, 0x0000, 0x0000, 0x2700
    dw "'", TipoTeclaEspecial.Nenhuma, 0x2827, 0x0000, 0x0000, 0x0000
    dw '`', TipoTeclaEspecial.Nenhuma, 0x2960, 0x0000, 0x0000, 0x0000
    dw '\', TipoTeclaEspecial.Nenhuma, 0x2B5C, 0x0000, 0x0000, 0x0000
    dw ',', TipoTeclaEspecial.Nenhuma, 0x332C, 0x0000, 0x0000, 0x0000
    dw '.', TipoTeclaEspecial.Nenhuma, 0x342E, 0x0000, 0x0000, 0x0000
    dw '/', TipoTeclaEspecial.Nenhuma, 0x352F, 0x0000, 0x0000, 0x0000

    dw '_', TipoTeclaEspecial.Nenhuma, 0x0000, 0x0C5F, 0x0000, 0x0000
    dw '+', TipoTeclaEspecial.Nenhuma, 0x0000, 0x0D2B, 0x0000, 0x0000
    dw '{', TipoTeclaEspecial.Nenhuma, 0x0000, 0x1A7B, 0x0000, 0x0000
    dw '}', TipoTeclaEspecial.Nenhuma, 0x0000, 0x1B7D, 0x0000, 0x0000
    dw ':', TipoTeclaEspecial.Nenhuma, 0x0000, 0x273A, 0x0000, 0x0000
    dw '"', TipoTeclaEspecial.Nenhuma, 0x0000, 0x2822, 0x0000, 0x0000
    dw '~', TipoTeclaEspecial.Nenhuma, 0x0000, 0x297E, 0x0000, 0x0000
    dw '|', TipoTeclaEspecial.Nenhuma, 0x0000, 0x2B7C, 0x0000, 0x0000
    dw '<', TipoTeclaEspecial.Nenhuma, 0x0000, 0x333C, 0x0000, 0x0000
    dw '>', TipoTeclaEspecial.Nenhuma, 0x0000, 0x343E, 0x0000, 0x0000
    dw '?', TipoTeclaEspecial.Nenhuma, 0x0000, 0x353F, 0x0000, 0x0000

    dw 0, TipoTeclaEspecial.F1, 0x3B00, 0x5400, 0x5E00, 0x6800
    dw 0, TipoTeclaEspecial.F2, 0x3C00, 0x5500, 0x5F00, 0x6900
    dw 0, TipoTeclaEspecial.F3, 0x3D00, 0x5600, 0x6000, 0x6A00
    dw 0, TipoTeclaEspecial.F4, 0x3E00, 0x5700, 0x6100, 0x6B00
    dw 0, TipoTeclaEspecial.F5, 0x3F00, 0x5800, 0x6200, 0x6C00
    dw 0, TipoTeclaEspecial.F6, 0x4000, 0x5900, 0x6300, 0x6D00
    dw 0, TipoTeclaEspecial.F7, 0x4100, 0x5A00, 0x6400, 0x6E00
    dw 0, TipoTeclaEspecial.F8, 0x4200, 0x5B00, 0x6500, 0x6F00
    dw 0, TipoTeclaEspecial.F9, 0x4300, 0x5C00, 0x6600, 0x7000
    dw 0, TipoTeclaEspecial.F10, 0x4400, 0x5D00, 0x6700, 0x7100
    dw 0, TipoTeclaEspecial.F11, 0x8500, 0x8700, 0x8900, 0x8B00
    dw 0, TipoTeclaEspecial.F12, 0x8600, 0x8800, 0x8A00, 0x8C00

    dw 8, TipoTeclaEspecial.BackSpace, 0x0E08, 0x0000, 0x0E7F, 0x0E00
    dw 0, TipoTeclaEspecial.Delete, 0x5300, 0x532E, 0x9300, 0xA300
    dw 0, TipoTeclaEspecial.SetaAcima, 0x4800, 0x4838, 0x8D00, 0x8D00
    dw 0, TipoTeclaEspecial.SetaAbaixo, 0x5000, 0x5032, 0x9100, 0xA000
    dw 0, TipoTeclaEspecial.SetaEsquerda, 0x4B00, 0x4B34, 0x7300, 0x9B00
    dw 0, TipoTeclaEspecial.SetaDireita, 0x4D00, 0x4D36, 0x7400, 0x9D00
    dw 0, TipoTeclaEspecial.SetaAcima, 0x48E0, 0x0000, 0x0000, 0x0000
    dw 0, TipoTeclaEspecial.SetaAbaixo, 0x50E0, 0x0000, 0x0000, 0x0000
    dw 0, TipoTeclaEspecial.SetaEsquerda, 0x4BE0, 0x0000, 0x0000, 0x0000
    dw 0, TipoTeclaEspecial.SetaDireita, 0x4DE0, 0x0000, 0x0000, 0x0000
    dw 0, TipoTeclaEspecial.Esc, 0x011B, 0x011B, 0x011B, 0x0100
    dw 10, TipoTeclaEspecial.Enter, 0x1C0D, 0x0000, 0x1C0A, 0xA600
    dw 0, TipoTeclaEspecial.Home, 0x4700, 0x4737, 0x7700, 0x9700
    dw 0, TipoTeclaEspecial.End, 0x4F00, 0x4F31, 0x7500, 0x9F00
    dw 0, TipoTeclaEspecial.Ins, 0x5200, 0x5230, 0x9200, 0xA200
    dw '5', TipoTeclaEspecial.Nenhuma, 0x0000, 0xA200, 0x8F00, 0x0000
    dw '-', TipoTeclaEspecial.Nenhuma, 0x4A2D, 0x4A2D, 0x8E00, 0x4A00
    dw '*', TipoTeclaEspecial.Nenhuma, 0x372A, 0x0000, 0x9600, 0x3700
    dw '+', TipoTeclaEspecial.Nenhuma, 0x4E2B, 0x4E2B, 0x0000, 0x4E00
    dw '/', TipoTeclaEspecial.Nenhuma, 0x352F, 0x352F, 0x9500, 0xA400
    dw 0, TipoTeclaEspecial.PageUp, 0x4900, 0x4939, 0x8400, 0x9900
    dw 0, TipoTeclaEspecial.PageDown, 0x5100, 0x5133, 0x7600, 0xA100
    dw 0, TipoTeclaEspecial.PrintScreen, 0x0000, 0x0000, 0x7200, 0x0000
    dw ' ', TipoTeclaEspecial.Nenhuma, 0x3920, 0x0000, 0x0000, 0x0000
    dw 9, TipoTeclaEspecial.Tab, 0x0F09, 0x0F00, 0x9400, 0xA500
    dw 0xffff
