.align 16

.section .text
.global _start
_start:
    jmp _start

    .fill 510 - (. - _start)
    .byte 0x55
    .byte 0xaa
    