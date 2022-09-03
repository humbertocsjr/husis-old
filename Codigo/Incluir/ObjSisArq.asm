
ObjSisArq:
    .Id: equ 0
    .Tipo: equ 4
    .Raiz: equ 6
    .Reservado: equ 8
    .SubItem: equ 10
        ; es:di = ObjSisArq
        ; cx = Posicao
        ; ret: cf = 1=Encontrado | 0=Nao encontrado OU fim da lista
        ;      ds:si = Aloca e retorna um objeto ObjSisArqItem
    .Fechar: equ 14
        ; Fecha um item ja aberto e libera a memoria do ObjSisArq
        ; es:di = ObjSisArq
        ; ret: cf = 1=Fechado | 0=Operacao invalida
    .Leia: equ 18
        ; es:di = ObjSisArq
        ; ds:si = Origem
        ; cx = Qtd de Bytes
        ; ret: cf = 1=Lido | 0=Nao lido
        ;      cx = Qtd de Bytes lidos
    .Escreva: equ 22
        ; es:di = ObjSisArq
        ; ds:si = Origem
        ; cx = Qtd de Bytes
        ; ret: cf = 1=Escrito | 0=Nao escrito
        ;      cx = Qtd de Bytes escritos
    .Exclui: equ 26
        ; es:di = ObjSisArq
        ; ret: cf = 1=Excluido | 0=Nao excluido
    .CriaDiretorio: equ 30
        ; es:di = ObjSisArq
        ; ds:si = Nome do novo diretorio
        ; ret: cf = 1=Criado | 0=Nao criado
    .CriaArquivo: equ 34
        ; es:di = ObjSisArq
        ; ds:si = Nome do novo arquivo
        ; ret: cf = 1=Criado | 0=Nao criado
    .Ejeta: equ 38
        ; OBS: Existe apenas na raiz
        ; bx = Unidade
        ; ret: cf = 1=Ejetado | 0=Nao ejetado
    .Unidade: equ 42
    .IdAcima: equ 44
    .Status: equ 48
        ; Codigo do erro do ultimo comando
    .LeiaLinha: equ 50
        ; es:di = ObjSisArq
        ; ds:si = Origem
        ; cx = Qtd de Bytes
        ; ret: cf = 1=Lido | 0=Nao lido
        ;      cx = Qtd de Bytes lidos
    .CalculaTamanho: equ 54
        ; es:di = ObjSisArq
        ; ret: cf = 1=Lido | 0=Nao lido
        ;      dx:ax = Bytes
    .CalculaQtdItens: equ 58
        ; es:di = ObjSisArq
        ; ret: cf = 1=Encontrado | 0=Nao encontrado OU fim da lista
        ;      cx = Qtd Itens no diretorio
    ._Tam: equ 64

ObjSisArqItem:
    .Id: equ 0
        ; Identificador unico no sistema de arquivos (Ate 8 Bytes)
    .Acima: equ 8
        ; Segmento onde esta o ObjSisArq (Acima)
    .Abrir: equ 12
        ; Abre um item e cria um ObjSisArq para ele
        ; ds:si = ObjSisArqItem
        ; ret: cf = 1=Aberto | 0=Nao foi possivel abrir
        ;      es:di = ObjSisArq
    .Nome: equ 16
        ; Nome do arquivo
    .Zero: equ 255
    ._CapacidadeNome: equ .Zero - .Nome
    ._Tam: equ 256

TipoSisArq:
    .Desconhecido: equ 0
    .Arquivo: equ 0x10
    .Diretorio: equ 0x20

StatusSisArq:
    .Desconhecido: equ 0
    .NaoExiste: equ 0x10
    .SemEspaco: equ 0x20
    .ApenasLeitura: equ 0x30