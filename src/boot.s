.code16

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


dochar:
    call cprint  # Print one character
sprint:
    lodsb  # String into AL
    cmp $0, %al  # Check if at end of string
    jne dochar
    addb $1, ypos  # Move to the next line in video memory
    movb $0, xpos  # Move left
    ret

cprint:
    movb $0x0f, %ah  # Color attribute, for white on black
    movw %ax, %cx  # Save char/attribute
    movzxb ypos, %ax  # Load the ypos into AX
    movw $160, %dx 
    mulw %dx
    movzxb xpos, %bx
    shlw $1, %bx

    movw $0, %di
    addw %ax, %di  # Add the y offest
    addw %bx, %di  # Add the x offset

    movw %cx, %ax
    stosw
    addb $1, xpos

    ret


# Data section
xpos: .byte 0
ypos: .byte 0
msg: .ascii "Hello World!\x0"
msg2: .ascii "This is being printed without BIOS interrupts!\x0"

    # Padding the end of the bootloader
    .fill 510 - (. - _start)
    .byte 0x55
    .byte 0xaa
