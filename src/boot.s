.code16
.align 16

.section .text
.global _start
_start:
    # Initialize the DS register and stack
    xor %ax, %ax
    mov %ax, %ds  # DS = 0
    mov %ax, %ss  # Stack starts at 0
    mov $0x9c00, %sp  # Stack pointer starts 2000h 

    cld

    # Setup the video memory pointer in ES
    mov $0xb800, %ax
    mov %ax, %es

    mov $msg, %si  # Move the address of the message into the src index register
    call sprint

    mov $msg2, %si
    call sprint

hang:
    jmp hang

.include "print.s"

# Data section
msg: .ascii "Hello World!\x0"
msg2: .ascii "This is being printed without BIOS interrupts!\x0"

    # Padding the end of the bootloader
    .fill 510 - (. - _start)
    .byte 0x55
    .byte 0xaa
