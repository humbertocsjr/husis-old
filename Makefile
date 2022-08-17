all: 
	@make -C ./Codigo all
	@make imagem

imagem:
	@echo " -= Gerar imagem inicializavel =-"
	@Ferramentas/minixfs mkfs ./disco.img -s 1440 -i 256 -n 14 -1
	@Ferramentas/minixfs add ./disco.img Temp/HUSIS HUSIS
	@dd if=Temp/Inicial of=disco.img conv=notrunc
	@echo " -= Imagens geradas =-"
	@ls -l disco.img

qemu:
	@make all
	@qemu-system-i386 -fda disco.img