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
.equ player_speed, 1

/*
Player movement code:
handles movement for both players in one function.
*/
move_players:
    pusha

    movb keybuffer, %al
    movb player1_ypos, %bl
    movb player2_ypos, %bh

    # Handle player 1 movement (W/S keys)
    testb $0b00000100, %al  # Test if W key is down
    jnz player_1_up
    testb $0b00001000, %al  # Test if S key is down
    jnz player_1_down
    jmp move_player_1_done

player_1_up:
    decb %bl
    cmpb $0, %bl
    jge move_player_1_done
    movb $0, %bl  # If player 1 goes beyond the screen, reset it's position
    jmp move_player_1_done
player_1_down:
    incb %bl
    cmpb $20, %bl
    jle move_player_1_done
    movb $20, %bl  # If player 1 goes beyond the screen, reset it's position
    jmp move_player_1_done

move_player_1_done:

    # Handle player 2 movement (up/down keys)
    testb $0b00000001, %al  # Test if UP key is down
    jnz player_2_up
    testb $0b00000010, %al  # Test if DOWN key is down
    jnz player_2_down
    jmp move_player_2_done

player_2_up:
    decb %bh
    cmpb $0, %bh
    jge move_player_2_done
    movb $0, %bh  # If player 2 goes beyond the screen, reset it's position
    jmp move_player_2_done
player_2_down:
    incb %bh
    cmpb $20, %bh
    jle move_player_2_done
    movb $20, %bh  # If player 2 goes beyond the screen, reset it's position
    jmp move_player_2_done

move_player_2_done:

    # Save the new player positions
    movb %bl, player1_ypos
    movb %bh, player2_ypos

    popa
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
