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
	@dd if=Temp/Inicial of=ptbr.img conv=notrunc
	@dd if=Temp/Inicial of=enus.img conv=notrunc
	@echo " -= Imagens geradas =-"
	@ls -l ptbr.img
	@ls -l Temp/HUSISPtBr

ptbr:
	@make all
	@qemu-system-i386 -fda ptbr.img
enus:
	@make all
	@qemu-system-i386 -fda enus.img