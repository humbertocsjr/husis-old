; ================
;  Fonte 'Pipoca'
; ================
;
; Prototipo........: 2017 (Criacao da fonte)
; Versao Inicial...: 20/08/2022 (Migrada para este projeto)
; Autor............: Humberto Costa dos Santos Junior
;
; Funcao...........: Fonte de largura variavel
;
; Limitacoes.......: Apenas 1 byte de largura por caractere
;
; Historico........:
;
; - ??/??/2017 - Humberto - Criacao dos caracteres diretamente em Asm
;                           Utilizado em um projeto chamado HCSO
; - 19/11/2020 - Humberto - Restauro do codigo fonte armazenado em Disquete
;                           e copiado para nuvem para armazenamento permanente
; - 20/08/2022 - Humberto - Conversão parcial para o HUSIS
;
; Licenciamento....: (Original do Projeto HCSO)
;
; Copyright (c) 2017-2020 Humberto Costa dos Santos Junior. 
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without 
; modification, are permitted provided that the following conditions are met:
;
;    1. Redistributions of source code must retain the above copyright notice, 
;       this list of conditions and the following disclaimer.
;    2. Redistributions in binary form must reproduce the above copyright 
;       notice, this list of conditions and the following disclaimer in the 
;       documentation and/or other materials provided with the distribution.
;    3. Neither the name of the copyright holder nor the names of its 
;       contributors may be used to endorse or promote products derived from 
;       this software without specific prior written permission.
;    4. Redistributions of any form whatsoever must retain the following 
;       acknowledgment: 'This product includes software developed by the 
;       "Humberto Costa dos Santos Junior" (http://github.com/humbertocsjr).'
;
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
; LIABLE FOR ANY DIRECT,  INDIRECT,  INCIDENTAL,  SPECIAL,  EXEMPLARY,  OR 
; CONSEQUENTIAL DAMAGES  (INCLUDING,  BUT NOT LIMITED TO,  PROCUREMENT OF 
; SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
; INTERRUPTION)  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,  WHETHER IN 
; CONTRACT,  STRICT LIABILITY,  OR TORT ( INCLUDING NEGLIGENCE OR OTHERWISE) 
; ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
; POSSIBILITY OF SUCH DAMAGE.

FontePipoca: db 'FONTE',0
    dw ._Fim
    .Altura: dw 11
    .Largura: dw 8
    .BytesPorCaractere: dw 12
    .PrimeiroCaractere: dw 32
    .Inicio: dw .Dados


    .Dados:


    ;32
    db 5
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b

    ;33
    db 6
    db 00000000b
    db 00000000b
    db 00011000b
    db 00011000b
    db 00011000b
    db 00011000b
    db 00011000b
    db 00000000b
    db 00011000b
    db 00000000b
    db 00000000b

    ;34
    db 8
    db 00000000b
    db 00000000b
    db 00100100b
    db 00100100b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b

    ;35
    db 8
    db 00000000b
    db 00000000b
    db 00000000b
    db 00100100b
    db 01111110b
    db 00100100b
    db 00100100b
    db 01111110b
    db 00100100b
    db 00000000b
    db 00000000b

    ;36
    db 8
    db 00000000b
    db 00000000b
    db 00001000b
    db 00111100b
    db 01001010b
    db 00111000b
    db 00010100b
    db 01010010b
    db 00111100b
    db 00010000b
    db 00000000b

    ;37
    db 8
    db 00000000b
    db 00000000b
    db 00000000b
    db 00110010b
    db 01010100b
    db 01111000b
    db 00011110b
    db 00101010b
    db 01001100b
    db 00000000b
    db 00000000b

    ;38
    db 8
    db 00000000b
    db 00000000b
    db 00111000b
    db 01000100b
    db 00100100b
    db 00111001b
    db 01001010b
    db 01000100b
    db 00111010b
    db 00000000b
    db 00000000b

    ;39
    db 8
    db 00000000b
    db 00000000b
    db 00010000b
    db 00010000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b

    ;40
    db 8
    db 00000000b
    db 00000000b
    db 00001000b
    db 00010000b
    db 00100000b
    db 00100000b
    db 00100000b
    db 00010000b
    db 00001000b
    db 00000000b
    db 00000000b

    ;41
    db 8
    db 00000000b
    db 00000000b
    db 00100000b
    db 00010000b
    db 00001000b
    db 00001000b
    db 00001000b
    db 00010000b
    db 00100000b
    db 00000000b
    db 00000000b

    ;42
    db 8
    db 00000000b
    db 00010000b
    db 01010100b
    db 00111000b
    db 01010100b
    db 00010000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b

    ;43
    db 8
    db 00000000b
    db 00000000b
    db 00000000b
    db 00010000b
    db 00010000b
    db 01111100b
    db 00010000b
    db 00010000b
    db 00000000b
    db 00000000b
    db 00000000b

    ;44
    db 4
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00100000b
    db 00100000b
    db 01000000b
    db 00000000b

    ;45
    db 8
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 01111100b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b

    ;46
    db 4
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 01000000b
    db 00000000b
    db 00000000b

    ;47
    db 8
    db 00000000b
    db 00000000b
    db 00000000b
    db 00001000b
    db 00001000b
    db 00010000b
    db 00010000b
    db 00100000b
    db 00100000b
    db 00000000b
    db 00000000b

    ;48
    db 8
    db 00000000b
    db 00000000b
    db 00111000b
    db 01000100b
    db 01000100b
    db 01010100b
    db 01000100b
    db 01000100b
    db 00111000b
    db 00000000b
    db 00000000b

    ;49
    db 8
    db 00000000b
    db 00000000b
    db 00010000b
    db 00110000b
    db 00010000b
    db 00010000b
    db 00010000b
    db 00010000b
    db 01111100b
    db 00000000b
    db 00000000b

    ;50
    db 8
    db 00000000b
    db 00000000b
    db 00111000b
    db 01000100b
    db 00000100b
    db 00001000b
    db 00010000b
    db 00100000b
    db 01111100b
    db 00000000b
    db 00000000b

    ;51
    db 8
    db 00000000b
    db 00000000b
    db 01111100b
    db 00000100b
    db 00001000b
    db 00111000b
    db 00000100b
    db 01000100b
    db 00111000b
    db 00000000b
    db 00000000b

    ;52
    db 8
    db 00000000b
    db 00010000b
    db 00010100b
    db 00010100b
    db 00100100b
    db 01111110b
    db 00000100b
    db 00000100b
    db 00000100b
    db 00000000b
    db 00000000b

    ;53
    db 8
    db 00000000b
    db 00000000b
    db 01111100b
    db 01000000b
    db 01111000b
    db 01000100b
    db 00000100b
    db 01000100b
    db 00111000b
    db 00000000b
    db 00000000b

    ;54
    db 8
    db 00000000b
    db 00000000b
    db 00001000b
    db 00010000b
    db 00100000b
    db 01111000b
    db 01000100b
    db 01000100b
    db 00111000b
    db 00000000b
    db 00000000b

    ;55
    db 8
    db 00000000b
    db 00000000b
    db 01111100b
    db 00001000b
    db 00001000b
    db 00010000b
    db 00010000b
    db 00100000b
    db 00100000b
    db 00000000b
    db 00000000b

    ;56
    db 8
    db 00000000b
    db 00000000b
    db 00111000b
    db 01000100b
    db 00111000b
    db 01000100b
    db 01000100b
    db 01000100b
    db 00111000b
    db 00000000b
    db 00000000b

    ;57
    db 8
    db 00000000b
    db 00000000b
    db 00111000b
    db 01000100b
    db 01000100b
    db 00111100b
    db 00000100b
    db 01000100b
    db 00111000b
    db 00000000b
    db 00000000b

    ;58
    db 4
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00100000b
    db 00000000b
    db 00000000b
    db 00100000b
    db 00000000b
    db 00000000b
    db 00000000b

    ;59
    db 4
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00100000b
    db 00000000b
    db 00000000b
    db 00100000b
    db 00100000b
    db 01000000b
    db 00000000b

    ;60
    db 6
    db 00000000b
    db 00000000b
    db 00001000b
    db 00010000b
    db 00100000b
    db 01000000b
    db 00100000b
    db 00010000b
    db 00001000b
    db 00000000b
    db 00000000b

    ;61
    db 8
    db 00000000b
    db 00000000b
    db 00000000b
    db 01111110b
    db 00000000b
    db 00000000b
    db 01111110b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b

    ;62
    db 6
    db 00000000b
    db 00000000b
    db 01000000b
    db 00100000b
    db 00010000b
    db 00001000b
    db 00010000b
    db 00100000b
    db 01000000b
    db 00000000b
    db 00000000b

    ;63
    db 8
    db 00000000b
    db 00000000b
    db 00111000b
    db 01000100b
    db 00001000b
    db 00010000b
    db 00010000b
    db 00000000b
    db 00010000b
    db 00000000b
    db 00000000b

    ;64
    db 8
    db 00000000b
    db 00000000b
    db 00011100b
    db 00100010b
    db 01001110b
    db 01010010b
    db 01011110b
    db 01000000b
    db 00111100b
    db 00000000b
    db 00000000b

    ;65
    db 8
    db 00000000b
    db 00000000b
    db 00111100b
    db 01000010b
    db 01000010b
    db 01111110b
    db 01000010b
    db 01000010b
    db 01000010b
    db 00000000b
    db 00000000b

    ;66
    db 8
    db 00000000b
    db 00000000b
    db 01111100b
    db 01000010b
    db 01000010b
    db 01111100b
    db 01000010b
    db 01000010b
    db 01111100b
    db 00000000b
    db 00000000b

    ;67
    db 8
    db 00000000b
    db 00000000b
    db 00111100b
    db 01000010b
    db 01000000b
    db 01000000b
    db 01000000b
    db 01000010b
    db 00111100b
    db 00000000b
    db 00000000b

    ;68
    db 8
    db 00000000b
    db 00000000b
    db 01111100b
    db 01000010b
    db 01000010b
    db 01000010b
    db 01000010b
    db 01000010b
    db 01111100b
    db 00000000b
    db 00000000b

    ;69
    db 8
    db 00000000b
    db 00000000b
    db 01111110b
    db 01000000b
    db 01000000b
    db 01111000b
    db 01000000b
    db 01000000b
    db 01111110b
    db 00000000b
    db 00000000b

    ;70
    db 8
    db 00000000b
    db 00000000b
    db 01111110b
    db 01000000b
    db 01000000b
    db 01111000b
    db 01000000b
    db 01000000b
    db 01000000b
    db 00000000b
    db 00000000b

    ;71
    db 8
    db 00000000b
    db 00000000b
    db 00111100b
    db 01000010b
    db 01000000b
    db 01001110b
    db 01000010b
    db 01000010b
    db 00111100b
    db 00000000b
    db 00000000b


    db 8
    db 00000000b
    db 00000000b
    db 01000010b
    db 01000010b
    db 01000010b
    db 01111110b
    db 01000010b
    db 01000010b
    db 01000010b
    db 00000000b
    db 00000000b


    db 3
    db 00000000b
    db 00000000b
    db 01000000b
    db 01000000b
    db 01000000b
    db 01000000b
    db 01000000b
    db 01000000b
    db 01000000b
    db 00000000b
    db 00000000b


    db 8
    db 00000000b
    db 00000000b
    db 00000010b
    db 00000010b
    db 00000010b
    db 00000010b
    db 00000010b
    db 01000010b
    db 00111100b
    db 00000000b
    db 00000000b


    db 8
    db 00000000b
    db 00000000b
    db 01000010b
    db 01000100b
    db 01001000b
    db 01110000b
    db 01001000b
    db 01000100b
    db 01000010b
    db 00000000b
    db 00000000b


    db 8
    db 00000000b
    db 00000000b
    db 01000000b
    db 01000000b
    db 01000000b
    db 01000000b
    db 01000000b
    db 01000000b
    db 01111110b
    db 00000000b
    db 00000000b


    db 8
    db 00000000b
    db 00000000b
    db 01000010b
    db 01100110b
    db 01011010b
    db 01000010b
    db 01000010b
    db 01000010b
    db 01000010b
    db 00000000b
    db 00000000b


    db 8
    db 00000000b
    db 00000000b
    db 01000010b
    db 01100010b
    db 01010010b
    db 01001010b
    db 01000110b
    db 01000010b
    db 01000010b
    db 00000000b
    db 00000000b


    db 8
    db 00000000b
    db 00000000b
    db 00111100b
    db 01000010b
    db 01000010b
    db 01000010b
    db 01000010b
    db 01000010b
    db 00111100b
    db 00000000b
    db 00000000b


    db 8
    db 00000000b
    db 00000000b
    db 01111100b
    db 01000010b
    db 01000010b
    db 01111100b
    db 01000000b
    db 01000000b
    db 01000000b
    db 00000000b
    db 00000000b


    db 8
    db 00000000b
    db 00000000b
    db 00111100b
    db 01000010b
    db 01000010b
    db 01000010b
    db 01001010b
    db 01000100b
    db 00111010b
    db 00000000b
    db 00000000b


    db 8
    db 00000000b
    db 00000000b
    db 01111100b
    db 01000010b
    db 01000010b
    db 01111100b
    db 01000100b
    db 01000010b
    db 01000010b
    db 00000000b
    db 00000000b


    db 8
    db 00000000b
    db 00000000b
    db 00111100b
    db 01000010b
    db 01000000b
    db 00111100b
    db 00000010b
    db 01000010b
    db 00111100b
    db 00000000b
    db 00000000b


    db 7
    db 00000000b
    db 00000000b
    db 01111100b
    db 00010000b
    db 00010000b
    db 00010000b
    db 00010000b
    db 00010000b
    db 00010000b
    db 00000000b
    db 00000000b


    db 8
    db 00000000b
    db 00000000b
    db 01000010b
    db 01000010b
    db 01000010b
    db 01000010b
    db 01000010b
    db 01000010b
    db 00111100b
    db 00000000b
    db 00000000b


    db 8
    db 00000000b
    db 00000000b
    db 01000010b
    db 01000010b
    db 01000010b
    db 00100100b
    db 00100100b
    db 00100100b
    db 00011000b
    db 00000000b
    db 00000000b


    db 8
    db 00000000b
    db 00000000b
    db 01000001b
    db 01000001b
    db 01001001b
    db 01001001b
    db 01001001b
    db 01001001b
    db 00110110b
    db 00000000b
    db 00000000b


    db 8
    db 00000000b
    db 00000000b
    db 01000010b
    db 01000010b
    db 00100100b
    db 00011000b
    db 00100100b
    db 01000010b
    db 01000010b
    db 00000000b
    db 00000000b


    db 8
    db 00000000b
    db 00000000b
    db 01000010b
    db 01000010b
    db 01000010b
    db 00111110b
    db 00000010b
    db 01000010b
    db 00111100b
    db 00000000b
    db 00000000b


    db 8
    db 00000000b
    db 00000000b
    db 01111110b
    db 00000010b
    db 00000100b
    db 00011000b
    db 00100000b
    db 01000000b
    db 01111110b
    db 00000000b
    db 00000000b


    db 8
    db 00000000b
    db 00000000b
    db 00011000b
    db 00010000b
    db 00010000b
    db 00010000b
    db 00010000b
    db 00010000b
    db 00011000b
    db 00000000b
    db 00000000b


    db 8
    db 00000000b
    db 00000000b
    db 00100000b
    db 00100000b
    db 00010000b
    db 00010000b
    db 00010000b
    db 00001000b
    db 00001000b
    db 00000000b
    db 00000000b


    db 8
    db 00000000b
    db 00000000b
    db 00011000b
    db 00001000b
    db 00001000b
    db 00001000b
    db 00001000b
    db 00001000b
    db 00011000b
    db 00000000b
    db 00000000b


    db 8
    db 00010000b
    db 00101000b
    db 01000100b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b


    db 8
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 01111110b
    db 00000000b


    db 8
    db 01000000b
    db 00100000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b


    db 6
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00111000b
    db 00000100b
    db 00111100b
    db 01000100b
    db 00110100b
    db 00000000b
    db 00000000b


    db 6
    db 00000000b
    db 00000000b
    db 01000000b
    db 01000000b
    db 01111000b
    db 01000100b
    db 01000100b
    db 01000100b
    db 01111000b
    db 00000000b
    db 00000000b


    db 6
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00111000b
    db 01000100b
    db 01000000b
    db 01000100b
    db 00111000b
    db 00000000b
    db 00000000b


    db 6
    db 00000000b
    db 00000000b
    db 00000100b
    db 00000100b
    db 00111100b
    db 01000100b
    db 01000100b
    db 01000100b
    db 00111000b
    db 00000000b
    db 00000000b


    db 6
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00111000b
    db 01000100b
    db 01111000b
    db 01000000b
    db 00111100b
    db 00000000b
    db 00000000b


    db 6
    db 00000000b
    db 00000000b
    db 00111000b
    db 01000100b
    db 01000000b
    db 01110000b
    db 01000000b
    db 01000000b
    db 01000000b
    db 00000000b
    db 00000000b


    db 6
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00111100b
    db 01000100b
    db 01000100b
    db 01000100b
    db 00111100b
    db 00000100b
    db 01111000b


    db 6
    db 00000000b
    db 00000000b
    db 01000000b
    db 01000000b
    db 01011000b
    db 01100100b
    db 01000100b
    db 01000100b
    db 01000100b
    db 00000000b
    db 00000000b


    db 4
    db 00000000b
    db 00000000b
    db 00100000b
    db 00000000b
    db 00100000b
    db 00100000b
    db 00100000b
    db 00100000b
    db 00100000b
    db 00000000b
    db 00000000b


    db 7
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000100b
    db 00000000b
    db 00000100b
    db 00000100b
    db 00110100b
    db 01001110b
    db 01000100b
    db 00111000b


    db 6
    db 00000000b
    db 00000000b
    db 01000000b
    db 01000100b
    db 01000100b
    db 01111000b
    db 01000100b
    db 01000100b
    db 01000100b
    db 00000000b
    db 00000000b


    db 6
    db 00000000b
    db 00000000b
    db 00010000b
    db 00010000b
    db 00010000b
    db 00010000b
    db 00010000b
    db 00010000b
    db 00010000b
    db 00000000b
    db 00000000b


    db 8
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 01111100b
    db 00101010b
    db 00101010b
    db 00101010b
    db 00101010b
    db 00000000b
    db 00000000b


    db 6
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 01111000b
    db 00100100b
    db 00100100b
    db 00100100b
    db 00100100b
    db 00000000b
    db 00000000b


    db 6
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00111000b
    db 01000100b
    db 01000100b
    db 01000100b
    db 00111000b
    db 00000000b
    db 00000000b


    db 6
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 01111000b
    db 01000100b
    db 01000100b
    db 01000100b
    db 01011000b
    db 01000000b
    db 01000000b


    db 6
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00111100b
    db 01000100b
    db 01000100b
    db 01000100b
    db 00110100b
    db 00000100b
    db 00000100b


    db 6
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 01011100b
    db 01100000b
    db 01000000b
    db 01000000b
    db 01000000b
    db 00000000b
    db 00000000b


    db 6
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00111100b
    db 01000000b
    db 00111000b
    db 00000100b
    db 01111000b
    db 00000000b
    db 00000000b


    db 6
    db 00000000b
    db 00000000b
    db 00100000b
    db 00100000b
    db 01111000b
    db 00100000b
    db 00100000b
    db 00100000b
    db 00011000b
    db 00000000b
    db 00000000b


    db 6
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 01000100b
    db 01000100b
    db 01000100b
    db 01001100b
    db 00110100b
    db 00000000b
    db 00000000b


    db 6
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 01000100b
    db 01000100b
    db 00101000b
    db 00101000b
    db 00010000b
    db 00000000b
    db 00000000b


    db 6
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 01000100b
    db 01010100b
    db 01010100b
    db 01010100b
    db 00101000b
    db 00000000b
    db 00000000b


    db 6
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 01000100b
    db 00101000b
    db 00010000b
    db 00101000b
    db 01000100b
    db 00000000b
    db 00000000b


    db 6
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 01000100b
    db 01000100b
    db 01000100b
    db 00111100b
    db 00000100b
    db 01000100b
    db 00111000b


    db 6
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 01111100b
    db 00001000b
    db 00010000b
    db 00100000b
    db 01111100b
    db 00000000b
    db 00000000b


    db 6
    db 00000000b
    db 00000000b
    db 00001000b
    db 00010000b
    db 00010000b
    db 00100000b
    db 00010000b
    db 00010000b
    db 00001000b
    db 00000000b
    db 00000000b


    db 6
    db 00000000b
    db 00000000b
    db 00010000b
    db 00010000b
    db 00010000b
    db 00010000b
    db 00010000b
    db 00010000b
    db 00010000b
    db 00000000b
    db 00000000b


    db 6
    db 00000000b
    db 00000000b
    db 00100000b
    db 00010000b
    db 00010000b
    db 00001000b
    db 00010000b
    db 00010000b
    db 00100000b
    db 00000000b
    db 00000000b


    db 6
    db 00000000b
    db 00100100b
    db 01010100b
    db 01001000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b


    db 6
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b

    db 8
    db 00000000b
    db 00000000b
    db 00111100b
    db 01000010b
    db 01000000b
    db 01000000b
    db 01000000b
    db 01000010b
    db 00111100b
    db 00001000b
    db 00010000b

    db 6
    db 00000000b
    db 00000000b
    db 01000100b
    db 00000000b
    db 01000100b
    db 01000100b
    db 01000100b
    db 01001100b
    db 00110100b
    db 00000000b
    db 00000000b

    db 6
    db 00000000b
    db 00001000b
    db 00010000b
    db 00000000b
    db 00111000b
    db 01000100b
    db 01111000b
    db 01000000b
    db 00111100b
    db 00000000b
    db 00000000b

    db 6
    db 00000000b
    db 00010000b
    db 00101000b
    db 00000000b
    db 00111000b
    db 00000100b
    db 00111100b
    db 01000100b
    db 00110100b
    db 00000000b
    db 00000000b

    db 6
    db 00000000b
    db 00000000b
    db 00101000b
    db 00000000b
    db 00111000b
    db 00000100b
    db 00111100b
    db 01000100b
    db 00110100b
    db 00000000b
    db 00000000b

    db 6
    db 00000000b
    db 00100000b
    db 00010000b
    db 00000000b
    db 00111000b
    db 00000100b
    db 00111100b
    db 01000100b
    db 00110100b
    db 00000000b
    db 00000000b

    db 6
    db 00000000b
    db 00010000b
    db 00101000b
    db 00010000b
    db 00111000b
    db 00000100b
    db 00111100b
    db 01000100b
    db 00110100b
    db 00000000b
    db 00000000b

    db 6
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00111000b
    db 01000100b
    db 01000000b
    db 01000100b
    db 00111000b
    db 00010000b
    db 00100000b

    db 6
    db 00000000b
    db 00010000b
    db 00101000b
    db 00000000b
    db 00111000b
    db 01000100b
    db 01111000b
    db 01000000b
    db 00111100b
    db 00000000b
    db 00000000b

    db 6
    db 00000000b
    db 00000000b
    db 00101000b
    db 00000000b
    db 00111000b
    db 01000100b
    db 01111000b
    db 01000000b
    db 00111100b
    db 00000000b
    db 00000000b

    db 6
    db 00000000b
    db 00100000b
    db 00010000b
    db 00000000b
    db 00111000b
    db 01000100b
    db 01111000b
    db 01000000b
    db 00111100b
    db 00000000b
    db 00000000b

    db 4
    db 00000000b
    db 00000000b
    db 01010000b
    db 00000000b
    db 00100000b
    db 00100000b
    db 00100000b
    db 00100000b
    db 00100000b
    db 00000000b
    db 00000000b

    db 4
    db 00000000b
    db 00100000b
    db 01010000b
    db 00000000b
    db 00100000b
    db 00100000b
    db 00100000b
    db 00100000b
    db 00100000b
    db 00000000b
    db 00000000b


    db 4
    db 00000000b
    db 01000000b
    db 00100000b
    db 00000000b
    db 00100000b
    db 00100000b
    db 00100000b
    db 00100000b
    db 00100000b
    db 00000000b
    db 00000000b


    db 8
    db 00100100b
    db 00000000b
    db 00111100b
    db 01000010b
    db 01000010b
    db 01111110b
    db 01000010b
    db 01000010b
    db 01000010b
    db 00000000b
    db 00000000b

    db 8
    db 00011000b
    db 00100100b
    db 00111100b
    db 01000010b
    db 01000010b
    db 01111110b
    db 01000010b
    db 01000010b
    db 01000010b
    db 00000000b
    db 00000000b



    db 8
    db 00000100b
    db 00001000b
    db 01111110b
    db 01000000b
    db 01000000b
    db 01111000b
    db 01000000b
    db 01000000b
    db 01111110b
    db 00000000b
    db 00000000b
    ._Fim: