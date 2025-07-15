.code16
.align 16

.section .text
.global sprint
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

# Internal data variables
xpos: .byte 0
ypos: .byte 0
