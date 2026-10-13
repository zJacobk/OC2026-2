%include "../../lib/pc_io.inc"   ; incluir declaraciones de procedimiento externos
section .data ;valores incializados
    bskey equ 0x7F ;equ significa equivale, en este caso bskey equivale a 0x7F
    benter equ 10   ;enter
    lencadena equ 255
    ln equ 0x0A ;salto de linea
    nline db ln,0 ;cadena que contiene salto de linea y terminador 0
    msg1 db ln,'Captura: ', 0
    msg2 db ln,'Cadena: ', 0
    msg3 db ln,ln,'Escoge una opcion',ln,'(1) - Capturar cadena',ln,'(2) - Minus a Mayus',ln,'(3) - Mayus a minus',ln,'(4) - Terminar programa',ln,'Escoge una opcion: ',0
    msg4 db ln,ln,'Cambio: ',0
    
section .bss ;valores no inicializados
    cadena resb lencadena

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
.case2:     mov edx, cadena
            call mayus 
            mov edx, msg4
            call puts

            mov edx, cadena 
            call puts       ;imprime
            jmp .switch
;------------------------------------------------------------

;------------------------------------------------------------
.case3:     mov edx, cadena
            call minus 
            mov edx, msg4
            call puts

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
    mayus:
            push ax

.ciclo:     mov al, [edx]
            cmp al, 0   
            je .terminar
            cmp al, 97
            jl .iterar
            cmp al, 122
            jg .iterar
            sub byte[edx], 32               ;aqui empieza la logica, este es el offset 
            jmp .iterar

.iterar:

            inc edx
            jmp .ciclo


.terminar:  pop ax
            ret
    
;------------------------------------------------------------


;------------------------------------------------------------
    minus:
            push ax

.ciclo:     mov al, [edx]
            cmp al, 0
            je .terminar
            cmp al, 65
            jl .iterar
            cmp al, 90
            jg .iterar
            add byte[edx], 32               ;aqui empieza la logica, este es el offset 
            jmp .iterar

.iterar:

            inc edx
            jmp .ciclo


.terminar:  pop ax
            ret
    
;------------------------------------------------------------

