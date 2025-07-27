/*
Programmable Interface Timer (PIT) interrupt handler code
*/
.code16

# Tick counter used for tracking frames
tick_count: .word 0

pit_handler:
    pusha

    # cli  # Previously used to allow atomic writes, but removed to save memory
    incw tick_count
    # sti

    mov $0x20, %al  # Send the EOI (End of Interrupt signal) for the master controller
    outb %al, $0x20

    popa
    iret

# Function used to delay code until the next frame
wait_for_tick:
    # push %ax  # No need to push AX as it is reset in the next game loop

    # cli  # Previously used to allow atomic access to tick_count, but to save memory I've removed it
    movw tick_count, %ax
    # sti

.wait_for_tick_loop:
    cmpw tick_count, %ax
    je .wait_for_tick_loop

    # pop %ax
    ret
