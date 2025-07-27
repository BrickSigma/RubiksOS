/*
Code related to player drawing
*/
.code16

player1_xpos: .byte 2
player1_ypos: .byte 10

player2_xpos: .byte 76
player2_ypos: .byte 10

.equ player_height, 5
.equ player_width, 2
.equ player_speed, 1

/*
Handle player input function:
used to reduce redundant code for input/player logic

INPUTS:
AL = Keyboard buffer value
BL = Player y position
DL = Test byte for moving player up (tested against the keyboard buffer)
DH = Test byte for moving player down

RETURNS:
BL = Updated player y position
*/
handle_player:
    testb %dl, %al  # Test if up key for player is down
    jnz .player_up
    testb %dh, %al  # Test if down key for player is down
    jnz .player_down
    ret

.player_up:
    decb %bl
    cmpb $0, %bl
    jge .move_player_done
    xorb %bl, %bl  # If player goes beyond the screen, reset it's position
    ret
.player_down:
    incb %bl
    cmpb $20, %bl
    jle .move_player_done
    movb $20, %bl  # If player goes beyond the screen, reset it's position

.move_player_done:
    ret

/*
Player movement code:
handles movement for both players in one function.
*/
move_players:
    # pusha  # No need to preserve the registers as they are overwritten immediately

    movb keybuffer, %al

    # Handle player 1 movement (W/S keys)
    movb player1_ypos, %bl
    movb $0b00000100, %dl  # W key
    movb $0b00001000, %dh  # S key
    call handle_player
    movb %bl, player1_ypos

    # Handle player 2 movement (up/down keys)
    movb player2_ypos, %bl
    movb $0b00000001, %dl  # UP key
    movb $0b00000010, %dh  # Down key
    call handle_player
    movb %bl, player2_ypos

    # popa
    ret

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
.height_loop:
    movb $player_width, %cl
.width_loop:
    call print_char_at  # Print the character
    incb %bl
    decb %cl
    jnz .width_loop

    movb %dl, %bl
    incb %bh
    decb %ch
    jnz .height_loop

    popa
    ret
