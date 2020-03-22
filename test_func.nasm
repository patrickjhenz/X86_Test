section     .text
global      print_string                        ;must be declared for linker (ld)

print_string:                                   ;tell linker entry point
    push    ebp
    mov     ebp, esp
    mov     edx,1                               ;message length
    mov     ecx,[ebp + 8]                       ;message to write
    mov     esi,0x00
    mov     ebx,1                               ;file descriptor (stdout)
loop:
    mov     eax,4                               ;system call number (sys_write)
    int     0x80                                ;call kernel
    add     ecx,0x01
    mov     edi,[ecx]
    and     edi,0x0FF
    cmp     edi,esi
    jne     loop

    mov esp, ebp
    pop ebp
    ret
