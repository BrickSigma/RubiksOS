.code16

.section .text
.global _start
_start:
    # Initialize the DS register
    xor %ax, %ax
    mov %ax, %ds

    mov $msg, %si  # Move the address of the message into the src index register
    cld  # Set the direction flag to 0

ch_loop:
    lodsb  # Load the character in SI into AL
    or %al, %al
    jz hang  # Exit the loop when the 0 is read (Null terminating character)

    # Prepare a BIOS interrupt function call to write a character to the screen
    mov $0x0e, %ah  # 0x0e is the function number for writting
    mov $0, %bh
    int $0x10  # Call the BIOS interrupt
    jmp ch_loop

hang:
    jmp hang

# Data section
msg: .ascii "Hello World!\x0"

    # Padding the end of the bootloader
    .fill 510 - (. - _start)
    .byte 0x55
    .byte 0xaa
