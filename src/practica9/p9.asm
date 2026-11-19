global maximo
global minimo
global sumatoria

%macro WHILE 2
    %push ciclo
%$inicio:
    cmp %1, %2
    jge %$fin
%endmacro

%macro ENDWHILE 0
    jmp %$inicio
%$fin:
    %pop
%endmacro

section .text

    maximo:
        push ebp
        mov ebp, esp

        mov edx, [ebp + 8] ;arreglo direccion
        mov eax, [edx] ;primer elemento en eax (inicial)
        mov ecx, 1 ;indice 1

        WHILE ecx, [ebp + 12]

        cmp eax, [edx + ecx*4]
        jge .siguiente
        mov eax, [edx + ecx*4]

        .siguiente:
        inc ecx

        ENDWHILE

        pop ebp
        ret

    minimo:
        push ebp
        mov ebp, esp

        mov edx, [ebp + 8]       
        mov eax, [edx]           
        mov ecx, 1               

        WHILE ecx, [ebp + 12]

        cmp eax, [edx + ecx*4]
        jle .siguiente
        mov eax, [edx + ecx*4]

    .siguiente:
        inc ecx

    ENDWHILE

    pop ebp
    ret

    sumatoria:
        push ebp
        mov ebp, esp

        mov edx, [ebp + 8]       
        mov eax, 0       ; Suma inicial
        mov ecx, 0               

        WHILE ecx, [ebp + 12]

        add eax, [edx + ecx*4]
        inc ecx

        ENDWHILE

        pop ebp
        ret


