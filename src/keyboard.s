.code16
.align 16

.section .text
.global keyhandler
keyhandler:
    pusha

    inb $0x60, %al  # Get key data

    movb $1, %cl  # Set CL to 1 if it is a key press
    testb $0x80, %al
    jz keyhandler_continue
    decb %cl  # Set CL to 0 if it is a key release
    andb $0x7f, %al  # Remove the key release flag

keyhandler_continue:
    cmpb $0x48, %al
    je up_key
    cmpb $0x50, %al
    je down_key
    cmpb $0x11, %al
    je w_key
    cmpb $0x1f, %al
    je s_key
    jmp end_keyhandler

up_key:
    movb $0x01, %al
    jmp handle_bit
down_key:
    movb $0x02, %al
    jmp handle_bit
w_key:
    movb $0x04, %al
    jmp handle_bit
s_key:
    movb $0x08, %al
    jmp handle_bit

handle_bit:
    testb %cl, %cl  # Check if CL is 0
    jz clear_keybuffer_bit

set_keybuffer_bit:
    orb %al, keybuffer
    jmp end_keyhandler

clear_keybuffer_bit:
    notb %al  # Invert the bitmask
    andb %al, keybuffer  # Clear the bit

end_keyhandler:
    mov $0x20, %al  # Send the EOI (End of Interrupt signal) for the master controller
    outb %al, $0x20

    # Restore register values
    popa
    iret

/*
Main key buffer to hold the current state of keys

    +---+---+---+---+---+---+---+---+
bit | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
    +---+---+---+---+---+---+---+---+
key | - | - | p |sp | s | w |dn |up |
    +---+---+---+---+---+---+---+---+
*/
.global keybuffer
keybuffer: .byte 0
