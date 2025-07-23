.code16
.align 16

.section .text
.global _start
_start:
    # Initialize the DS register and stack
    xor %ax, %ax
    movw %ax, %ds  # DS = 0
    movw %ax, %ss  # Stack starts at 0
    movw %ax, %gs  # GS = 0 (used for setting the IVT)
    movw $0x9c00, %sp  # Stack pointer starts 2000h 

    cld

    # =============================================================
    # Setup the IVT
    cli

    # Set up for PIT interrupts
    mov $0x20, %bx  # Hardware interrupt no# x 4 (int 8)
    movw $pit_handler, %gs:(%bx)
    movw %ds, %gs:2(%bx)  # Segment location of ISR

    # Set up for keyboard interrupts
    mov $0x24, %bx  # Hardware interrupt no# x 4 (int 9)
    movw $keyhandler, %gs:(%bx)
    movw %ds, %gs:2(%bx)  # Segment location of ISR

    sti
    # Done setting up the IVT
    # =============================================================

    # =============================================================
    # Initialize the PIT to run at 60Hz on channel 0, using mode 2
    # Also set to lowbyte/hibyte
    movb $0x34, %al
    outb %al, $0x43

    movw $59659, %ax  # 1193182 / 20Hz = 59659
    outb %al, $0x40
    movb %ah, %al
    outb %al, $0x40
    # =============================================================


    # =============================================================
    # Disable the cursor blinking
    // movb $0x01, %ah
    // movb $1, %ch
    // movb $0, %cl
    // int $0x10
    # =============================================================

    # Setup the video memory pointer in ES
    movw $0xb800, %ax
    movw %ax, %es

    # =============================================================
    # Main game loop code
    movb $0, %cl
.game_loop:
    # Handle main logic over here
    call move_players  # Handle player movement

    andb $1, %cl
    jz .skip_frame
    call move_ball
.skip_frame:
    addb $1, %cl

    # Rendering code placed here
    movw $0, %ax
    call clear_screen

    movb player1_xpos, %bl
    movb player1_ypos, %bh
    call draw_player

    movb player2_xpos, %bl
    movb player2_ypos, %bh
    call draw_player

    call draw_ball

    call wait_for_tick

    jmp .game_loop

.include "vga_driver.s"
.include "keyboard.s"
.include "pit_handler.s"
.include "player.s"
.include "ball.s"

.ascii "Yo"  # Used as a marker to determine how much memory in the bootloader binary is remaining
    # Padding the end of the bootloader
    .fill 510 - (. - _start)
    .byte 0x55
    .byte 0xaa
