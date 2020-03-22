all: test.o test_func.o
	ld -m elf_i386 -s -o test test.o test_func.o

test.o: test.nasm
	nasm -f elf test.nasm

test_func.o: test_func.nasm
	nasm -f elf test_func.nasm
