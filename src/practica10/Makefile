build:
	gcc -m32 -c holaa.c -o holaa.o
	nasm -f elf32 p10.asm -o p10.o
	gcc -m32 holaa.o p10.o -no-pie -z noexecstack -o practica10

run: build
	./practica10

clean:
	rm -f holaa.o p10.o practica10