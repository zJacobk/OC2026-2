	extern canonical_off 
	extern canonical_on

section .data
    bskey equ 127
    benter equ 10
    lencadena equ 255
    ln equ 10
    nline db ln,0
    menu db ln,"---Menu---",ln,"(1) - Capturar cadena",ln,"(2) - Mayus a minus",ln,"(3) - Minus a mayus",ln,"Escoge una opcion: ",0
    capturac db ln,"Captura una cadena: ",0
    capturada db ln,"Cadena: ",0
    resultado db ln,"Resultado: ",0

section .bss
    cadena resb 255

section .text
    global _start

    _start:
   
        .switch:
            push menu
            call puts
            add esp,4

            call getche
            cmp al, "1"
            je .case1
            cmp al, "2"
            je .case2
            cmp al, "3"
            je .case3
            cmp al, "4"
            je .case4
            jmp .switch


        .case1:
            push capturac
            call puts
            add esp, 4


            mov edi, cadena
            call captura

            jmp .switch

        .case2:
            mov edi, cadena
            call mayus

            push resultado
            call puts 
            add esp, 4


            push edi
            call puts
            add esp, 4

            mov al, 10
            call putchar
            jmp .switch

        .case3:
            mov edi, cadena
            call minus

            push resultado
            call puts 
            add esp, 4

            push edi 
            call puts
            add esp, 4

            mov al, 10
            call putchar
            jmp .switch

        .case4:
            ;-- Terminar programa--
            mov eax, 1
            xor ebx, ebx
            int 0x80


        putchar:
                push eax
                push ebx
                push ecx
                push edx


                    mov eax, 4
                    mov ebx, 1
                    lea ecx, [esp + 12]
                    mov edx, 1
                    int 0x80

                pop edx
                pop ecx
                pop ebx
                pop eax
                ret

            


        puts:

                push ebp        ; se guarda ebp en la pila
                push ebx
                push esi

                mov ebp, esp    ; ebp ahora tiene la direccion de la cima

                xor edx, edx    ; inicializar contador
                mov esi, [ebp + 16] 

            .contador:

                cmp byte [esi + edx], 0
                je .imprimir
                inc edx
                jmp .contador

            
            .imprimir:

                mov eax, 4
                mov ebx, 1
                lea ecx, [esi]   ; esi = direccion de memoria, al poner LEA ECX, [ESI] I386 pasa el contenido directo a ECX
                ; Si se pone mov ecx, esi es lo mismo. Pero LEA permite jugar con la memoria al hacer cosas como [ESI + 5], direccion de memoria de esi + 5 
            
                int 0x80

                pop esi
                pop ebx
                pop ebp
                ret

        getch:

            call canonical_off

            push eax
            push ebx
            push ecx

                mov eax, 3
                mov ebx, 0
                lea ecx, [esp + 8]
                mov edx, 1
                int 0x80

            cmp eax, 1
            jne .error
            jmp .restaurar

            .error:
                mov byte[esp + 0], 0

            .restaurar:
                call  canonical_on 

            pop ecx
            pop ebx
            pop eax
            ret

        getche:
            call getch
            call putchar
        ret

        captura:
            push ebx
            push ecx

            xor ecx, ecx

            .ciclo:
            
                cmp ecx, lencadena
                je .terminador
        
                call getche 
                cmp al, 10
                je .terminador
                cmp al, 0x7F
                je .borrar
                mov byte [edi + ecx], al
                inc ecx
                jmp .ciclo

            .terminador:
                mov byte [edi + ecx], 0
                inc ecx
                jmp .fin

            .borrar:
                
                cmp ecx, 0
                je .ciclo

                push ax

                mov al, 8
                call putchar
                mov al, " "
                call putchar
                mov al, 8
                call putchar

                pop ax
                dec ecx

                jmp .ciclo
            
            .fin:
                pop ecx
                pop ebx
                ret

        mayus:
            push eax
            push ebx
            push ecx
            push edx

            xor ecx, ecx

            .ciclo:
                cmp byte [edi + ecx],0
                je .fin

                cmp byte [edi + ecx], 65
                jb .iterar

                cmp byte [edi + ecx], 90
                ja .iterar

                add byte [edi + ecx], 32

                inc ecx
                jmp .ciclo


            .iterar:
                inc ecx
                jmp .ciclo

            .fin:

                pop edx
                pop ecx
                pop ebx
                pop eax
                ret


       minus:
            push eax
            push ebx
            push ecx
            push edx

            xor ecx, ecx

            .ciclo:
                cmp byte [edi + ecx],0
                je .fin

                cmp byte [edi + ecx], 97
                jb .iterar

                cmp byte [edi + ecx], 122
                ja .iterar

                sub byte [edi + ecx], 32

                inc ecx
                jmp .ciclo


            .iterar:
                inc ecx
                jmp .ciclo

            .fin:

                pop edx
                pop ecx
                pop ebx
                pop eax
                ret