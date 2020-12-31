section     .text
global      timer_int_handler                        ;must be declared for linker (ld)
global      init_timer

%define PORTA_DATA 0xB000_0C00
%define PORTA_DIRE 0xB000_0C04
%define BIT24 0x100_0000

%define TIMER1_LOAD1 0xB000_0800
%define TIMER1_LOAD2 0xB000_08B0
%define TIMER1_CONTR 0xB000_0808
%define TIMER1_EOI   0xB000_080C
%define PIC_EOI      0xFEE0_00B0
%define IDT_BASE     0x0028_1E40
%define IDT_SIZE     0x01A0
%define HANDLER      0x0018_00E0
%define INT_WINDOW   0xFEC0_0000
%define INT_DATA     0xFEC0_0010

%define TIMER_INT_MASK 0xB080_0470

%define TIMER_INT 43
%define IDT_OFF   (TIMER_INT * 8)

init_timer:
    push    ebp
    mov     ebp, esp

    push eax
    push ebx
    push ecx

    sub     esp, 6 

    cli

    mov eax, TIMER1_EOI
    mov ebx, [eax]
    mov eax, PIC_EOI
    mov ebx, 0x00
    mov [eax], ebx

    mov eax, TIMER_INT_MASK
    mov ebx, [eax]
    and ebx, 0xFFFF_FFFE
    mov [eax], ebx

    mov eax, TIMER1_LOAD1
    mov ebx, 0x00F4_2400
    mov [eax], ebx
    mov eax, TIMER1_LOAD2
    mov [eax], ebx

    mov  eax, esp
    mov  ebx, IDT_SIZE
    mov  [eax], ebx
    add  eax, 0x02
    mov  ebx, IDT_BASE
    mov  [eax], ebx

    mov  eax, ebx
    add  eax, IDT_OFF ; get address of interrupt gate
    mov  ebx, [eax]   ; get lower 4 bytes of interrupt gate
    and  ebx, 0x0000_0000
    mov  ecx, HANDLER
    and  ecx, 0x0000_FFFF
    or   ebx, ecx
    or   ebx, 0x0008_0000
    mov  [eax], ebx

    add  eax, 0x04
    mov  ebx, [eax]
    and  ebx, 0x0000_0000
    mov  ecx, HANDLER
    and  ecx, 0xFFFF_0000
    or   ebx, ecx
    or   ebx, 0x0000_8E00
    mov  [eax], ebx

    lidt [esp]

    mov eax, INT_WINDOW
    mov ebx, 0x0026
    mov [eax], ebx
    mov eax, INT_DATA
    mov ebx, 0x00
    mov [eax], ebx
    
    mov eax, TIMER1_CONTR
    mov ebx, 0x03
    mov [eax], ebx

    sti

    add esp, 6

    pop  ecx
    pop  ebx
    pop  eax

    mov esp, ebp
    pop ebp
    ret

timer_int_handler:                                   ;tell linker entry point

    mov eax, TIMER1_EOI
    mov edx, [eax]
    mov eax, PIC_EOI
    mov ebx, 0x00
    mov [eax], ebx

    mov eax, PORTA_DATA    
    mov edx, [eax]
    xor edx, BIT24
    mov [eax], edx

    iret
