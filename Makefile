all: 
	@make -C ./Codigo all
	@make imagem

conteudo_imagem:
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
	@Ferramentas/minixfs add ./ptbr.img Temp/CGAAceleradora Sistema/Extensoes/CGAAceleradora
	@Ferramentas/minixfs add ./enus.img Temp/CGAAceleradora System/Extensions/CGAAccelerator
	@Ferramentas/minixfs add ./ptbr.img Temp/EGA Sistema/Extensoes/EGA
	@Ferramentas/minixfs add ./enus.img Temp/EGA System/Extensions/EGA
	@Ferramentas/minixfs add ./ptbr.img Temp/VGA Sistema/Extensoes/VGA
	@Ferramentas/minixfs add ./enus.img Temp/VGA System/Extensions/VGA
	@Ferramentas/minixfs mkdir ./ptbr.img Programas
	@Ferramentas/minixfs mkdir ./enus.img Programs
	@Ferramentas/minixfs add ./ptbr.img Temp/ArquivosPtBr Programas/Arquivos
	@Ferramentas/minixfs add ./enus.img Temp/ArquivosEnUs Programs/Files

imagem:
	@echo " -= Gerar imagem inicializavel =-"
	@Ferramentas/minixfs mkfs ./ptbr.img -s 360 -i 256 -n 30 -1
	@dd if=Temp/Inicial360 of=ptbr.img conv=notrunc
	@cp ptbr.img enus.img
	@make conteudo_imagem
	@mv -f ptbr.img ptbr360.img
	@mv -f enus.img enus360.img
	@Ferramentas/minixfs mkfs ./ptbr.img -s 1440 -i 256 -n 30 -1
	@dd if=Temp/Inicial1440 of=ptbr.img conv=notrunc
	@cp ptbr.img enus.img
	@make conteudo_imagem
	@mv -f ptbr.img ptbr1440.img
	@mv -f enus.img enus1440.img
	@echo " -= Imagens geradas =-"
	@ls -l Temp/*

ptbr:
	@make all
	@qemu-system-i386 -fda ptbr1440.img
enus:
	@make all
	@qemu-system-i386 -fda enus1440.img