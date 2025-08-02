AS := as
LD := ld

SRCDIR := src
OBJDIR := objects

SRCS =  $(SRCDIR)/boot.s #$(wildcard $(SRCDIR)/*.s)
OBJS = $(patsubst $(SRCDIR)/%.s, $(OBJDIR)/%.o, $(SRCS))

LDFLAGS := -T linker.ld

ASFLAGS := -I$(SRCDIR)

BOOTBIN := steineros.bin

.PHONY: all clean run

all : $(BOOTBIN)

$(BOOTBIN) : $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $^

$(OBJDIR)/%.o : $(SRCDIR)/%.s | $(OBJDIR)
	$(AS) $^ -o $@ $(ASFLAGS)

$(OBJDIR) :
	mkdir -p $(OBJDIR)

clean:
	rm -rf $(OBJS) *.bin

run:
	qemu-system-i386 -hda $(BOOTBIN)