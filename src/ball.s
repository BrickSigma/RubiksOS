/*
Contains logic for handling the ball, like its position, drawing, and physics.
*/

.code16

ball_x: .byte 40
ball_y: .byte 12
ball_x_vel: .byte 2
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
    ret
.reverse_left_part:
    movb $1, %bl
    jmp .reverse_vel
.reverse_right_part:
    movb %cl, %bl
.reverse_vel:
    negb %bh

    ret

# Handles ball movement and collision detection
move_ball:
    pusha

    # Move the ball along the x-axis
    movb ball_x, %bl
    movb ball_x_vel, %bh
    movb $79, %cl
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

    popa
    ret

# Draws the ball onto the screen
draw_ball:
    pusha

    movb ball_x, %bl
    movb ball_y, %bh
    decb %bl
    decb %bh

    movw $0x0fdb, %ax  # White on black, solid character

    # Loop unrolling used for drawing the four parts of the ball
    # to help save memory
    call print_char_at
    incb %bl
    call print_char_at
    decb %bl
    incb %bh
    call print_char_at
    incb %bl
    call print_char_at

    popa
    ret
