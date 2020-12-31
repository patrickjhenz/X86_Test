section     .text
global      _start                              ;must be declared for linker (ld)
extern      init_timer

%define PORTA_DATA 0xB000_0C00
%define PORTA_DIRE 0xB000_0C04 
%define BIT24 0x100_0000

_start:                                         ;tell linker entry point
  mov eax, PORTA_DIRE
  mov ebx, BIT24
  mov [eax], ebx 

  mov eax, PORTA_DATA
  mov ebx, 0x00
  mov [eax], ebx 

  call init_timer

loop:
  ;add ebx, 0x01
  ;cmp ebx, ecx
  ;jne loop
  ;mov ebx, 0x00
  ;call timer_int_handler
  jmp loop

section     .data
