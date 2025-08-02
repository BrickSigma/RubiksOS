/*
Code related to player drawing
*/
.code16

.equ player1_xpos, 2
player1_ypos: .byte 10

.equ player2_xpos, 76
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
Handles the y axis collision detection for the player and ball.
Required to reduce memory size.

INPUTS:
AL = Velocity of ball if collision detected
BH = Player y position
*/
player_ball_collision_y_axis:
    # Check the y position of the ball and see if it's within the player
    movb ball_y, %bl
    incb %bl
    cmpb %bh, %bl  # ball_y >= player_y
    jb .player_ball_collision_y_axis_exit

    # Check the other end of the player
    subb $2, %bl
    addb $player_height, %bh
    cmp %bh, %bl
    ja .player_ball_collision_y_axis_exit

    # Handle the collision by flipping the ball's velocity
    movb %al, ball_x_vel

.player_ball_collision_y_axis_exit:
    ret

/*
Player-ball collision function
*/
player_ball_collision:
    # Check if the ball has passed player 1's x position first
    movb ball_x, %bl
    decb %bl
    cmp $4, %bl
    ja .no_collision1  # ball_x <= player_x

    # Check y axis collision
    movb $2, %al
    movb player1_ypos, %bh
    call player_ball_collision_y_axis

.no_collision1:

    # Check if the ball has passed player 2's position next
    movb ball_x, %bl
    incb %bl
    cmp $76, %bl
    jb .no_collision2  # ball_x >= player_x

    # Check y axis collision
    movb $-2, %al
    movb player2_ypos, %bh
    call player_ball_collision_y_axis

.no_collision2:

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
