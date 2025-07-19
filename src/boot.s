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

    # Set up the IVT for keyboard interrupts
    cli
    mov $0x09, %bx  # Hardware interrupt no#
    shlw $2, %bx  # Multiply by 4 (4 bytes per entry in the IVT)
    xor %ax, %ax
    movw %ax, %gs
    movw $keyhandler, %gs:(%bx)
    movw %ds, %gs:2(%bx)  # Segment location of ISR
    sti

    # Disable the cursor blinking
    movb $0x01, %ah
    movb $1, %ch
    movb $0, %cl
    int $0x10

    # Setup the video memory pointer in ES
    movw $0xb800, %ax
    movw %ax, %es

    movw $msg, %si  # Move the address of the message into the src index register
    call sprint

hang:
    jmp hang

.include "print.s"
.include "keyboard.s"

# Data section
msg: .ascii "Hello World!\x0"

    # Padding the end of the bootloader
    .fill 510 - (. - _start)
    .byte 0x55
    .byte 0xaa
