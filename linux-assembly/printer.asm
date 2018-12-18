%include "asm_io.inc"

segment .data
prompt db '==========', 0
segment .bss

segment .text
    global asm_main
asm_main:
    enter 0, 0
    pusha

    dump_regs 1
    
    mov eax, prompt
    call print_string

    mov eax, 0x02
    in byte eax, 0x64

    dump_regs 1

    popa
    mov eax, 0
    leave
    ret

