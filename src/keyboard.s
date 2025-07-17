.code16
.align 16

.section .text
.global keyhandler
keyhandler:
    inb $0x60, %al  # Get key data
    mov %al, %bl  # Save it
    mov %al, port60

    # The block bellow resets the keyboards internal state.
    # It also acknowledges the keyboard interrupt by flipping bit 7
    inb $0x61, %al  # Keyboard control byte
    mov %al, %ah
    or $0x80, %al  # Disable bit 7
    outb %al, $0x61  # Send it back
    xchgb %al, %ah  # Get the original value and send it back
    outb %al, $0x61

    mov $0x20, %al  # Send the EOI (End of Interrupt signal) for the master controller
    outb %al, $0x20

    and $0x80, %bl  # Skip any scan codes indicating a key release
    jnz done

    # Print out the scan code in hexadecimal
    mov port60, %ax
    mov %ax, reg16
    call printreg16

done:
    iret

port60: .word 0
