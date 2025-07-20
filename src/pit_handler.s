/*
Programmable Interface Timer (PIT) interrupt handler code
*/
.code16
.align 16

# Tick counter used for tracking frames
tick_count: .word 0

pit_handler:
    pusha

    cli
    incw tick_count
    sti

    mov $0x20, %al  # Send the EOI (End of Interrupt signal) for the master controller
    outb %al, $0x20

    popa
    iret

# Function used to delay code until the next frame
wait_for_tick:
    push %ax

    cli
    movw tick_count, %ax
    sti

.wait_for_tick_loop:
    cmpw tick_count, %ax
    je .wait_for_tick_loop

    pop %ax
    ret
