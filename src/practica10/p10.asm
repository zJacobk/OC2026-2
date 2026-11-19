global get_bit
global set_bit

%macro GETBIT 2
    movzx ecx, byte %2     
    mov eax, 1
    shl eax, cl            
    test %1, eax         
%endmacro

%macro SETBIT 2
    movzx ecx, byte %2     
    mov eax, 1
    shl eax, cl            
    or %1, al              ; encender bit
%endmacro

section .text


get_bit:
    push ebp
    mov ebp, esp

    movzx edx, byte [ebp + 8] ; valor recibido

    GETBIT edx, [ebp + 12]

    jz .apagado

    mov eax, 1
    jmp .fin

.apagado:
    mov eax, 0

.fin:
    pop ebp
    ret



set_bit:
    push ebp
    mov ebp, esp

    mov edx, [ebp + 8]        

    SETBIT byte [edx], [ebp + 12]

    pop ebp
    ret