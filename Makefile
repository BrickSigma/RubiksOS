CC := i686-elf-gcc
AS := nasm
LD := i686-elf-ld

CFLAGS := -std=gnu99 -ffreestanding -O2 -Wall -Wextra
ASFLAGS := -felf32
LDFLAGS := -ffreestanding -O2 -nostdlib

BUILD_DIR = build
OUT = RubiksOS

boot:
	mkdir -p $(BUILD_DIR)
	$(AS) $(ASFLAGS) src/boot.s -o $(BUILD_DIR)/boot.o
	$(CC) -c src/kernel.c -o $(BUILD_DIR)/kernel.o $(CFLAGS)
	$(CC) -T src/linker.ld -o $(BUILD_DIR)/$(OUT).bin $(LDFLAGS) $(BUILD_DIR)/*.o -lgcc



	mkdir -p $(BUILD_DIR)/isodir/boot/grub
	cp src/grub.cfg $(BUILD_DIR)/isodir/boot/grub
	cp $(BUILD_DIR)/$(OUT).bin $(BUILD_DIR)/isodir/boot
	grub2-mkrescue -o $(BUILD_DIR)/$(OUT).iso $(BUILD_DIR)/isodir


.PHONY: clean

clean:
	rm -rf $(BUILD_DIR)
