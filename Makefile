all: 
	@make -C ./Codigo all
	@make imagem

imagem:
	@echo " -= Gerar imagem inicializavel =-"
	@Ferramentas/minixfs mkfs ./disco.img -s 1440 -i 256 -n 30 -1
	@Ferramentas/minixfs add ./disco.img Temp/HUSIS HUSIS
	@Ferramentas/minixfs mkdir ./disco.img Sistema
	@Ferramentas/minixfs add ./disco.img Config.cfg Sistema/Config.cfg
	@Ferramentas/minixfs mkdir ./disco.img Sistema/Extensoes
	@Ferramentas/minixfs add ./disco.img Temp/Interface Sistema/Extensoes/Interface
	@dd if=Temp/Inicial of=disco.img conv=notrunc
	@echo " -= Imagens geradas =-"
	@ls -l disco.img
	@ls -l Temp/HUSIS

qemu:
	@make all
	@qemu-system-i386 -fda disco.img