/*
Marked as old for now.
Will probably re-implement it in C once in protected mode.
*/

.code16
.align 16

.section .text
.global sprint
sprint:
    # Save registers
    pusha

    jmp sprint_loop
dochar:
    call cprint  # Print one character
sprint_loop:
    lodsb  # String into AL
    cmp $0, %al  # Check if at end of string
    jne dochar
    addb $1, ypos  # Move to the next line in video memory
    cmpb $25, ypos
    jb sprint_end  # Check if ypos >= 25
    movb $24, ypos  # Set ypos to 24 and scroll the screen
    call scroll_screen
sprint_end:
    movb $0, xpos  # Move left

    # Restore registers
    popa
    ret

cprint:
    pusha

    movb $0x0f, %ah
    movb xpos, %bl
    movb ypos, %bh
    call print_char_at

    addb $1, xpos
    cmpb $80, xpos
    jb cprint_end
    # If the xpos goes beyond the screen, go to the next line.
    movb $0, xpos
    addb $1, ypos  # Move to the next line in video memory
    cmpb $25, ypos
    jb cprint_end  # Check if ypos >= 25
    movb $24, ypos  # Set ypos to 24 and scroll the screen
    call scroll_screen

cprint_end:
    popa
    ret


# Used to scroll the screen one line up on new lines
# Should only be called in sprint/cprint
scroll_screen:
    pusha
    push %ds

    movw $0xb800, %ax
    movw %ax, %ds

    movw $160, %si  # One row bellow video memory
    movw $0, %di

    movw $1920, %cx  # Loop 80x24 times for each character, expect the last row
scroll_screen_loop:
    movsw
    loop scroll_screen_loop

    # Clear the last line of the buffer as well
    movw $0, %ax
    movw $80, %cx
clear_last_line:
    stosw
    loop clear_last_line

    pop %ds
    popa
    ret

.global printreg16
printreg16:
    # Save register values
    pusha

    movw $outstr16, %di  # Load the pointer for the output string
    movw reg16, %ax  # Copy the value of reg16 into AX
    movw $hexstr, %si  # Load the pointer of hexstr
    movw $4, %cx  # Used to loop over every hex character
hexloop:
    rol $4, %ax  # Get the leftmost bits (5E2F --> E2F5)
    movw %ax, %bx
    andw $0x0f, %bx  # Get only the last 4 bits/the last hex value (E2F5 --> 0005)
    movb (%bx,%si), %bl  # Index into hexstr and store the character in AL
    movb %bl, (%di)
    inc %di
    decw %cx
    jnz hexloop

    movw $outstr16, %si
    call sprint

    # Restore register values
    popa

    ret

/*
print_char_at - used to print a ascii character onto the screen at a specified location

INPUTS: (doesn't follow any calling convention)
AH = color attribute
AL = char to print
BH = y position to print to (between 0-25)
BL = x position to print to (between 0-79)

*/
.global print_char_at
print_char_at:
    # Save registers
    pusha

    movw %ax, %cx  # Save char/attribute
    movzxb %bh, %ax  # Load the y position into AX
    movw $160, %dx 
    mulw %dx
    movzxb %bl, %bx  # Load the x position int BX
    shlw $1, %bx

    movw $0, %di
    addw %ax, %di  # Add the y offest
    addw %bx, %di  # Add the x offset

    movw %cx, %ax
    stosw  # Write the byte to ES:(DI)

    # Restore the registers
    popa

    ret

# Internal data variables
xpos: .byte 0
ypos: .byte 0

hexstr: .ascii "0123456789ABCDEF"
outstr16: .asciz "0000"  # Hold the string value of the register value

.global reg16
reg16: .word 0  # Used for passing values to printreg16
