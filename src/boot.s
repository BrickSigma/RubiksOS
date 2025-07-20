.code16
.align 16

.section .text
.global _start
_start:
    # Initialize the DS register and stack
    xor %ax, %ax
    movw %ax, %ds  # DS = 0
    movw %ax, %ss  # Stack starts at 0
    movw $0x9c00, %sp  # Stack pointer starts 2000h 

    cld

    # Set up the IVT for keyboard interrupts
    cli
    mov $0x09, %bx  # Hardware interrupt no#
    shlw $2, %bx  # Multiply by 4 (4 bytes per entry in the IVT)
    xor %ax, %ax
    movw %ax, %gs
    movw $keyhandler, %gs:(%bx)
    movw %ds, %gs:2(%bx)  # Segment location of ISR
    sti

    # Disable the cursor blinking
    movb $0x01, %ah
    movb $1, %ch
    movb $0, %cl
    int $0x10

    # Disable text mode blink
    movw $0x3da, %dx
    inb %dx, %al  # Reset the latch

    movb $0x30, %al
    movw $0x3c0, %dx
    outb %al, %dx  # Set the register index for port 0x3C0

    movw $0x3c1, %dx
    inb %dx, %al  # Read the port's data
    andb $0xf7, %al  # Disable blinking
    movb %al, %bl # Save the value

    movw $0x3da, %dx
    inb %dx, %al  # Reset the latch

    movb $0x30, %al
    movw $0x3c0, %dx
    outb %al, %dx  # Set the register index for port 0x3C0

    movb %bl, %al
    movw $0x3c0, %dx
    outb %al, %dx

    # Setup the video memory pointer in ES
    movw $0xb800, %ax
    movw %ax, %es

    movb $0, %cl
    movb $0, %ch
game_loop:
    # Run at 1FPS
    incb %ch
    cmpb $60, %ch
    jb continue_loop

    movb $0, %ch

    addb $0x10, %cl

continue_loop:
    # VSYNC
    movw $0x3da, %dx
vsync_enter_wait:  # Wait for the screen to enter vsync
    inb %dx, %al
    andb $0x08, %al;
    jz vsync_enter_wait

    # Rendering code placed here
    movb %cl, %ah
    movb $0, %al
    call clear_screen
    # ============================

vsync_exit_wait:  # Wait for the screen to exit vsync and render the screen
    inb %dx, %al
    andb $0x08, %al;
    jnz vsync_exit_wait

    jmp game_loop

.include "vga_driver.s"
.include "keyboard.s"

    # Padding the end of the bootloader
    .fill 510 - (. - _start)
    .byte 0x55
    .byte 0xaa
