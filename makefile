AS := as
LD := ld

SRC := src

LDFILE := $(SRC)/linker.ld

BOOT := $(SRC)/boot
BOOTBIN := chippyos.bin

.PHONY: all clean run

all : $(BOOTBIN)

$(BOOTBIN) : $(BOOT).o
	$(LD) -T $(LDFILE) -o $@ $^

$(BOOT).o : $(BOOT).s
	$(AS) $^ -o $@

clean:
	rm -rf */*.o *.bin

run:
	qemu-system-i386 -hda $(BOOTBIN)