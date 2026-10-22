%include "../../lib/pc_io.inc"   ; incluir declaraciones de procedimiento externos
section .data ;valores incializados
    bskey equ 0x7F ;equ significa equivale, en este caso bskey equivale a 0x7F
    benter equ 10   ;enter
    lencadena equ 255
    ln equ 0x0A ;salto de linea
    nline db ln,0 ;cadena que contiene salto de linea y terminador 0
    msg1 db ln,'Captura: ', 0
    msg2 db ln,'Cadena: ', 0
    msg3 db ln,ln,'Escoge una opcion',ln,'(1) - Capturar cadena',ln,'(2) - ATOI Cadena a numero entero',ln,'(3) - ITOA Numero entero a cadena',ln,'(4) - Terminar programa',ln,'Escoge una opcion: ',0
    msg4 db ln,ln,'Cambio: ',0
    
section .bss ;valores no inicializados
    cadena resb lencadena
    respuesta resb lencadena

section .text
    global _start         ; referencia para inicio de programa
    
_start:   
   
.switch     mov edx, msg3
            call puts
            call getche        ;devuelve ascii 
            cmp al, '1'
            je .case1
            cmp al, '2'
            je .case2
            cmp al, '3'
            je .case3
            cmp al, '4'
            je .fin_programa
            jmp .switch


.case1:     mov edx, msg1      ; imprimir "captura"
            call puts

            mov edx, cadena
            mov esi, cadena     ;inicio de la cadena para que la funcion capturar sea mas generica, eso si se hace pop de esi
            mov ax, lencadena
            call captura   


            mov edx, msg2         ; imprimir "Cadena: "
            call puts

            mov edx, cadena       ; imprime la cadena
            call puts   
            jmp .switch
;------------------------------------------------------------

;------------------------------------------------------------
.case2:     
            mov edx, cadena
            call ascii_numero
            
            jmp .switch
;------------------------------------------------------------

;------------------------------------------------------------
.case3:    
   
            mov esi, cadena

            add ebx, 123
            call numero_ascii


            mov al, 10
            call putchar
            
            mov edx, cadena
            call puts       ;imprime
            jmp .switch
;------------------------------------------------------------
     
    ; --- FIN DE PROGRAMA ---
    .fin_programa: 
        mov edx, nline    
        call puts     
        call puts     
        mov eax, 1            ; Llamada sys_exit
	    xor ebx, ebx          ; return 0
        int 0x80              ; Fin de programa

;------------------------------------------------------------
    captura:
            push ax        ;se pone en la pila

    .ciclo: call getch     ;toma un caracter y lo deja en AL
            cmp al, bskey   ;comparar para ver si no es backspace, si no es backspace brinca a comparacion2
            jne .scomp       ;si no son iguales entonces salta
            call borrar
            jmp .ciclo
    .scomp: cmp al, benter  
            je .enter           ;si es igual a enter brinca a .enter
            mov byte[edx], al
            inc edx
            call putchar   ;toma el byte el byte de al y lo imprime
            jmp .ciclo

    .enter: mov byte[edx], 0
            pop ax         ;saca de la pila ax
            ret            ;saca de la pila 4 bytes de la direccion de la llamada call

    borrar:
        push ax 
        cmp edx, esi ;compara si edx es el inicio de la cadena de esi, para no borrar de mas
        je .terminar

        mov al,0x8  
        call putchar        ;se mueve una posicion hacia atras (control)
        mov al,' '
        call putchar        ;se mueve una posicion hacia adelante imprimiendo espacio
        mov al,0x8           
        call putchar        ;se mueve una posicion hacia atras (control)
        dec edx
.terminar   pop ax              
            ret 
;------------------------------------------------------------




;------------------------------------------------------------
    
    ascii_numero:
        push eax
        push ecx
        push esi

        ;INICIALIZACIONES

        mov ebx, 0 
        mov eax, 0
        mov ecx, 0


        cmp byte [edx + ecx], 32
        je .espacios
        cmp byte [edx + ecx], 9
        je .espacios

        jmp .signos


            .ciclo:
                cmp byte [edx + ecx], 48
                jb .prefin

                cmp byte [edx + ecx], 57
                ja .prefin

                movzx eax, byte [edx + ecx]
                sub eax, "0"

                imul ebx, 10
                add ebx, eax

                inc ecx
                jmp .ciclo

        .espacios:
            inc ecx
            cmp byte [edx + ecx], 32
            je .espacios
            cmp byte [edx + ecx], 9
            je .espacios
            jmp .signos


        .negativo:
            inc ecx
            mov esi, 1
            jmp .ciclo

        .positivo:
            inc ecx
            mov esi, 0
            jmp .ciclo


        .signos:
            cmp byte [edx + ecx], "-"
            je .negativo

            cmp byte [edx + ecx], "+"
            je .positivo

            mov esi, 0 ;SI no encuentra ningun signo, se da por hecho que es POSITIVO

            jmp .ciclo

        .negar:
            neg ebx
            jmp .fin

        .prefin:

            cmp esi, 1
            je .negar
            jmp .fin  ;fin explicito

        .fin:
            pop esi
            pop ecx
            pop eax
            ret




    numero_ascii:

        push eax
        push ebx
        push ecx
        push edx

        mov ecx, 0
        mov eax, ebx ;numero que quiero dividir
        mov ebx, 10
        xor edx, edx ;parte alta 

        cmp eax, 0
        jl .es_negativo

        .ciclo:
            div ebx
            add edx, "0"
            mov byte [esi + ecx], dl ;CADA DIRECCION DE MEMORIA ES 1 BYTE
            inc ecx
            cmp eax, 0
            je .agregar_0
            xor edx, edx
            jmp .ciclo

        .es_negativo:
            mov byte [esi + ecx], "-"
            inc ecx
            neg eax ;SE CONVIERTE EBX EN POSITIVO, PARA TRABAJAR CON ASCII
            jmp .ciclo

        .agregar_0:
            mov byte[esi + ecx], 0
            xor eax,eax
            cmp byte[esi], "-"
            sete al

            xor ebx, ebx
            dec ecx
            jmp .intercambiar
        
        .intercambiar:
            cmp eax, ecx
            jae .fin

            mov dl, byte [esi + ecx]
            mov bl, byte[esi + eax]

            mov byte[esi + eax], dl
            mov byte[esi + ecx], bl

            inc eax
            dec ecx
        jmp .intercambiar

        .fin:
                pop edx
                pop ecx
                pop ebx
                pop eax
                ret
