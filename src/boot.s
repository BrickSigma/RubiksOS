.code16
.align 16

.section .text
.global _start
_start:
    # Initialize the DS register and stack
    xor %ax, %ax
    movw %ax, %ds  # DS = 0
    movw %ax, %ss  # Stack starts at 0
    movw $0x9c00, %sp  # Stack pointer starts 2000h 

    cld

    # Setup the video memory pointer in ES
    movw $0xb800, %ax
    movw %ax, %es

    movw $msg, %si  # Move the address of the message into the src index register
    call sprint

    movw $msg2, %si
    call sprint

    movw $0x5e2f, reg16
    call printreg16

hang:
    jmp hang

.include "print.s"

# Data section
msg: .ascii "Hello World!\x0"
msg2: .ascii "This is being printed without BIOS interrupts! I also have a lot more text added to see if it'll wrap around the screen, let's see if it does it!!!\x0"

    # Padding the end of the bootloader
    .fill 510 - (. - _start)
    .byte 0x55
    .byte 0xaa
