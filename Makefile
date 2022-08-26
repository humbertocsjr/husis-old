all: 
	@make -C ./Codigo all
	@make imagem

imagem:
	@echo " -= Gerar imagem inicializavel =-"
	@Ferramentas/minixfs mkfs ./ptbr.img -s 1440 -i 256 -n 30 -1
	@cp ptbr.img enus.img
	@Ferramentas/minixfs add ./ptbr.img Temp/HUSISPtBr HUSIS
	@Ferramentas/minixfs add ./enus.img Temp/HUSISEnUs HUSIS
	@Ferramentas/minixfs mkdir ./ptbr.img Sistema
	@Ferramentas/minixfs mkdir ./enus.img System
	@Ferramentas/minixfs add ./ptbr.img ConfigPtBr.cfg Sistema/Config.cfg
	@Ferramentas/minixfs add ./enus.img ConfigEnUs.cfg System/Config.cfg
	@Ferramentas/minixfs mkdir ./ptbr.img Sistema/Extensoes
	@Ferramentas/minixfs mkdir ./enus.img System/Extensions
	@Ferramentas/minixfs add ./ptbr.img Temp/Interface Sistema/Extensoes/Interface
	@Ferramentas/minixfs add ./enus.img Temp/Interface System/Extensions/Interface
	@Ferramentas/minixfs add ./ptbr.img Temp/Serial Sistema/Extensoes/Serial
	@Ferramentas/minixfs add ./enus.img Temp/Serial System/Extensions/Serial
	@Ferramentas/minixfs add ./ptbr.img Temp/PS2 Sistema/Extensoes/PS2
	@Ferramentas/minixfs add ./enus.img Temp/PS2 System/Extensions/PS2
	@Ferramentas/minixfs add ./ptbr.img Temp/Video Sistema/Extensoes/Video
	@Ferramentas/minixfs add ./enus.img Temp/Video System/Extensions/Video
	@Ferramentas/minixfs add ./ptbr.img Temp/CGA Sistema/Extensoes/CGA
	@Ferramentas/minixfs add ./enus.img Temp/CGA System/Extensions/CGA
	@Ferramentas/minixfs mkdir ./ptbr.img Programas
	@Ferramentas/minixfs mkdir ./enus.img Programs
	@Ferramentas/minixfs add ./ptbr.img Temp/ArquivosPtBr Programas/Arquivos
	@Ferramentas/minixfs add ./enus.img Temp/ArquivosEnUs Programs/Files
	@dd if=Temp/Inicial of=ptbr.img conv=notrunc
	@dd if=Temp/Inicial of=enus.img conv=notrunc
	@echo " -= Imagens geradas =-"
	@ls -l ptbr.img
	@ls -l Temp/*

ptbr:
	@make all
	@qemu-system-i386 -fda ptbr.img
enus:
	@make all
	@qemu-system-i386 -fda enus.img