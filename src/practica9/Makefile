build:
	gcc -m32 -c hola.c -o hola.o
	nasm -f elf32 p9.asm -o p9.o
	gcc -m32 hola.o p9.o -no-pie -z noexecstack -o practica9

run: build
	./practica9

clean:
	rm -f hola.o p9.o practica9