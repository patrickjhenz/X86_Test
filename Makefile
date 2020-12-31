blinky.bin: blinky
	dd if=blinky of=blinky.bin skip=8

blinky: blinky.o int_handler.o 
	ld -m elf_i386 -o blinky blinky.o int_handler.o

blinky.o: blinky.nasm
	nasm -f elf -g blinky.nasm

int_handler.o: int_handler.nasm
	nasm -f elf -g int_handler.nasm
