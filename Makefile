ASM=yasm
CC=gcc
LD=ld
QEMU=qemu-system-i386

ASM-FFLAGS:=-f bin

ASM-LFLAGS:=-f elf32
CC-LFLAGS:=-ffreestanding -m32 -nostdlib -fno-pie -fno-pic
LD-LFLAGS:=-m elf_i386 -nostdlib -Tlinker.ld

QEMU-DFLAGS:=-drive file=build/os.img,if=floppy,format=raw

QEMU-MFLAGS:=-name NS-Au

KERNEL-SOURCES:=$(wildcard src/kernel/*.c)
KERNEL-OBJECTS:=$(patsubst %.c,%.o,$(KERNEL-SOURCES))

.PHONY: default build always clean bootloader kernel image test

default: test

build: image

test: image
	$(QEMU) $(QEMU-DFLAGS) $(QEMU-MFLAGS)

image: always build/os.img

build/os.img: build/boot.bin build/kernel.bin
	cat $^ > $@
	truncate -s 1440k $@

build/boot.bin: src/boot/boot.asm
	$(ASM) $< $(ASM-FFLAGS) -o $@

build/kernel.bin: build/kernel_entry.o $(KERNEL-OBJECTS)
	$(LD) $(LD-LFLAGS) $^ -o $@

build/kernel_entry.o: src/kernel/entry.asm
	$(ASM) $< $(ASM-LFLAGS) -o $@

%.o: %.c
	$(CC) $(CC-LFLAGS) -c $< -o $@

always:
	mkdir -p build