.code16
.align 16

.section .text
.global keyhandler
keyhandler:
    pusha

    inb $0x60, %al  # Get key data
    mov %al, %bl  # Save it
    mov %al, port60

    mov $0x20, %al  # Send the EOI (End of Interrupt signal) for the master controller
    outb %al, $0x20

    and $0x80, %bl  # Skip any scan codes indicating a key release
    jnz done

    # Print out the scan code in hexadecimal
    mov port60, %ax
    mov %ax, reg16
    call printreg16

done:
    # Restore register values
    popa
    iret

port60: .word 0
