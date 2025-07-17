.code16
.align 16

.section .text
.global sprint
sprint:
    push %cx  # save CX
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

    pop %cx  # Restore CX
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
    ret


# Used to scroll the screen one line up on new lines
# Should only be called in sprint/cprint
scroll_screen:
    push %ds  # Save DS
    push %si  # Save SI (no need to save DI since cprint always overwrites it again)

    movw $0xb800, %ax
    movw %ax, %ds

    movw $160, %si  # One row bellow video memory
    movw $0, %di

    movw $1920, %cx  # Loop 80x24 times for each character, expect the last row
scroll_screen_loop:
    movsw
    loop scroll_screen_loop

    pop %si  # Restore SI
    pop %ds  # Restore DS
    ret

.global printreg16
printreg16:
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

    ret

# Internal data variables
xpos: .byte 0
ypos: .byte 0

hexstr: .ascii "0123456789ABCDEF"
outstr16: .asciz "0000"  # Hold the string value of the register value

.global reg16
reg16: .word 0  # Used for passing values to printreg16
