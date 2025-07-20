/*
Simple VGA driver code
*/

/*
print_char_at - used to print a ascii character onto the screen at a specified location

INPUTS: (doesn't follow any calling convention)
AH = color attribute
AL = char to print
BH = y position to print to (between 0-25)
BL = x position to print to (between 0-79)
*/
print_char_at:
    # Save registers
    pusha

    movw %ax, %cx  # Save char/attribute
    movzxb %bh, %ax  # Load the y position into AX
    movw $160, %dx 
    mulw %dx
    movzxb %bl, %bx  # Load the x position int BX
    shlw $1, %bx

    movw %ax, %di  # Add the y offest
    addw %bx, %di  # Add the x offset

    movw %cx, %ax
    stosw  # Write the byte to ES:(DI)

    # Restore the registers
    popa
    ret

/*
Clear the screen with a character

INPUTS:
AH = Color attribute
AL = Character to fill screen
*/
clear_screen:
    pusha

    movw $2000, %cx  # Loop 80x25 cells
    movw $0, %di  # Start of video memory
    rep stosw

    popa
    ret
