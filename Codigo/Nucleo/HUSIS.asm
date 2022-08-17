cpu 8086
org 0x100

Inicial:
    mov ah, 0xe
    mov al, '0'
    int 0x10
    retf
