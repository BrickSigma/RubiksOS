.code16
.align 16

.section .text
.global keyhandler
keyhandler:
    pusha

    inb $0x60, %al  # Get key data
    mov %al, %bl  # Save it to port60
    mov %al, port60

    and $0x80, %bl  # Skip any scan codes indicating a key release
    jnz done    

done:
    mov $0x20, %al  # Send the EOI (End of Interrupt signal) for the master controller
    outb %al, $0x20

    # Restore register values
    popa
    iret

port60: .word 0

/*
Main key buffer to hold the current state of keys

    +---+---+---+---+---+---+---+---+
bit | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
    +---+---+---+---+---+---+---+---+
key | - | - | p |sp | w | s |dn |up |
    +---+---+---+---+---+---+---+---+
*/
.global keybuffer
keybuffer: .byte 0
