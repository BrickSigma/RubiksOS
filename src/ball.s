/*
Contains logic for handling the ball, like its position, drawing, and physics.
*/

.code16

ball_x: .byte 40
ball_y: .byte 12
ball_x_vel: .byte 1
ball_y_vel: .byte 1

.equ ball_size, 2

/*
Handles a single vector component of the ball.

INPUTS:
BL = ball position (either X or Y)
BH = ball velocity (either X or Y)
CH = maximum value of position (78 for X, 23 for Y)

Updated BL and BH with new ball position and velocity.

NOTE: This function doesn't preserve any register values
*/
handle_vector:
    addb %bh, %bl

    cmpb $1, %bl
    jle .reverse_left_part
    cmpb %cl, %bl
    jge .reverse_right_part
    jmp .handle_vector_cont
.reverse_left_part:
    movb $1, %bl
    jmp .reverse_vel
.reverse_right_part:
    movb %cl, %bl
    jmp .reverse_vel
.reverse_vel:
    movb $-1, %al
    mulb %bh
    movb %al, %bh
.handle_vector_cont:
    ret

# Handles ball movement and collision detection
move_ball:
    pusha

    # Move the ball along the x-axis
    movb ball_x, %bl
    movb ball_x_vel, %bh
    movb $78, %cl
    call handle_vector
    movb %bl, ball_x
    movb %bh, ball_x_vel

    # Move the ball along the y-axis
    movb ball_y, %bl
    movb ball_y_vel, %bh
    movb $24, %cl
    call handle_vector
    movb %bl, ball_y
    movb %bh, ball_y_vel

    # Check if ball is colliding with player 1


    popa
    ret

# Draws the ball onto the screen
draw_ball:
    pusha

    movb ball_x, %bl
    movb ball_y, %bh
    decb %bl
    decb %bh

    movb %bl, %dl  # Save the x position when looping
    movw $0x0fdb, %ax  # White on black, solid character
    
    movb $ball_size, %ch
.ball_height_loop:
    movb $ball_size, %cl
.ball_width_loop:
    call print_char_at  # Print the character
    incb %bl
    decb %cl
    jnz .ball_width_loop

    movb %dl, %bl
    incb %bh
    decb %ch
    jnz .ball_height_loop

    popa
    ret
