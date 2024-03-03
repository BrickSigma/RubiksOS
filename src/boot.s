; Declare constants for the multiboot header.
MBALIGN  equ  1 << 0            ; align loaded modules on page boundaries
MEMINFO  equ  1 << 1            ; provide memory map
MBFLAGS  equ  MBALIGN | MEMINFO ; this is the Multiboot 'flag' field
MAGIC    equ  0x1BADB002        ; 'magic number' lets bootloader find the header
CHECKSUM equ -(MAGIC + MBFLAGS)   ; checksum of above, to prove we are multiboot

; Declare the multiboot header 
section .multiboot
align 4
	dd MAGIC
	dd MBFLAGS
	dd CHECKSUM

; Create the stack, aligned to 16 bytes and 16 kilobytes in size
section .bss
align 16
stack_bottom:
resb 16384 ; 16 KiB
stack_top:

; Now the main _start function can begin where the kernel is loaded up
section .text
global _start
_start:
	; The bootloader is loaded in 32-bit protected mode
	; Although interrupts are disabled, you can never be too sure...
	cli

	; Initialize the stack pointer
	mov esp, stack_top

	; Enable 4KiB paging
	; -------------------
	; mov eax, page_directory
	; mov cr3, eax
 
	; mov eax, cr0
	; or eax, 0x80000001
	; mov cr0, eax
	; --------------------

	; Call the high-level kernel
	extern kernel_main
	call kernel_main

	cli
.hang:
	hlt
	jmp .hang
.end:



