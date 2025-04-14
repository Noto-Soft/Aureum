ASM=yasm
CC=gcc
LD=ld
QEMU=qemu-system-i386

ASM-FFLAGS:=-f bin

ASM-LFLAGS:=-f elf32
CC-LFLAGS:=-ffreestanding -m32 -nostdlib -fno-pie -fno-pic
LD-LFLAGS:=-m elf_i386 -nostdlib
LD-FLFLAGS:=$(LD-LFLAGS) -Tlinker.ld

QEMU-DFLAGS:=-drive file=build/os.img,if=floppy,format=raw

QEMU-MFLAGS:=-name NS-Au

KERNEL-ASMSOURCES:=src/kernel/entry.asm $(filter-out src/kernel/entry.asm, $(wildcard src/kernel/*.asm))
KERNEL-ASMOBJECTS:=$(patsubst src/kernel/%.asm,build/asm/%.o,$(KERNEL-ASMSOURCES))

KERNEL-CSOURCES:=$(wildcard src/kernel/*.c)
KERNEL-COBJECTS:=$(patsubst src/kernel/%.c,build/%.o,$(KERNEL-CSOURCES))

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

build/kernel.bin: build/kernel_main.o
	$(LD) $(LD-FLFLAGS) $^ -o $@

build/kernel_main.o: $(KERNEL-ASMOBJECTS) $(KERNEL-COBJECTS)
	$(LD) $(LD-LFLAGS) -r $^ -o $@

build/asm/%.o: src/kernel/%.asm 
	$(ASM) $< $(ASM-LFLAGS) -o $@

build/%.o: src/kernel/%.c
	$(CC) $(CC-LFLAGS) -c $< -o $@

always:
	mkdir -p build/asm