section     .text
global      _start                              ;must be declared for linker (ld)

extern print_string

_start:                                         ;tell linker entry point

    push msg
    
    call print_string 

    add esp, 4

    ;return
    mov     eax,1                               ;system call number (sys_exit)
    int     0x80                                ;call kernel

section     .data

msg     db  'Hello, world!',0x0A, 0x00        ;our dear string
len     equ $ - msg                             ;length of our dear string
