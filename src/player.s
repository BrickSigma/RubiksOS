/*
Code related to player drawing
*/
.code16
.align 16

player1_xpos: .byte 2
player1_ypos: .byte 10

player2_xpos: .byte 76
player2_ypos: .byte 10

.equ player_height, 5
.equ player_width, 2

/*
Draw player function
BH = y position
BL = x position
*/
draw_player:
    pusha

    movb %bl, %dl  # Save the x position when looping
    movw $0x0fdb, %ax  # White on black, solid character
    
    movb $player_height, %ch
height_loop:
    movb $player_width, %cl
width_loop:
    call print_char_at  # Print the character
    incb %bl
    decb %cl
    jnz width_loop

    movb %dl, %bl
    incb %bh
    decb %ch
    jnz height_loop

    popa
    ret
