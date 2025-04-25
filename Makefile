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

KERNEL-ASMSOURCES:=$(wildcard src/kernel/*.asm)
KERNEL-ASMOBJECTS:=$(patsubst src/kernel/%.asm,build/asm/%.o,$(KERNEL-ASMSOURCES))
KERNEL-ASMOBJECT:=build/asm/kernel.o

KERNELLIB-ASMSOURCES:=$(wildcard src/kernel/lib/*.asm)
KERNELLIB-ASMOBJECTS:=$(patsubst src/kernel/lib/%.asm,build/libasm/%.o,$(KERNELLIB-ASMSOURCES))
KERNELLIB-ASMOBJECT:=build/libasm.o

KERNEL-CSOURCES:=$(wildcard src/kernel/*.c)
KERNEL-COBJECTS:=$(patsubst src/kernel/%.c,build/kernel/%.o,$(KERNEL-CSOURCES))
KERNEL-COBJECT:=build/kernel.o

KERNELLIB-CSOURCES:=$(wildcard src/kernel/lib/*.c)
KERNELLIB-COBJECTS:=$(patsubst src/kernel/lib/%.c,build/libc/%.o,$(KERNELLIB-CSOURCES))
KERNELLIB-COBJECT:=build/libc.o

KERNELLIB-OBJECT:=build/kernellib.o

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

build/kernel_main.o: $(KERNEL-ASMOBJECT) $(KERNEL-COBJECT) $(KERNELLIB-OBJECT)
	$(LD) $(LD-LFLAGS) -r $^ -o $@

build/asm/%.o: src/kernel/%.asm 
	$(ASM) $< $(ASM-LFLAGS) -o $@

build/libasm/%.o: src/kernel/lib/%.asm 
	$(ASM) $< $(ASM-LFLAGS) -o $@

build/kernel/%.o: src/kernel/%.c
	$(CC) $(CC-LFLAGS) -c $< -o $@

build/libc/%.o: src/kernel/lib/%.c
	$(CC) $(CC-LFLAGS) -c $< -o $@

$(KERNEL-COBJECT): $(KERNEL-COBJECTS)
	$(LD) $(LD-LFLAGS) -r $^ -o $@

$(KERNELLIB-COBJECT): $(KERNELLIB-COBJECTS)
	$(LD) $(LD-LFLAGS) -r $^ -o $@

$(KERNEL-ASMOBJECT): $(KERNEL-ASMOBJECTS)
	$(LD) $(LD-LFLAGS) -r $^ -o $@

$(KERNELLIB-ASMOBJECT): $(KERNELLIB-ASMOBJECTS)
	$(LD) $(LD-LFLAGS) -r $^ -o $@

$(KERNELLIB-OBJECT): $(KERNELLIB-ASMOBJECT) $(KERNELLIB-COBJECT)
	$(LD) $(LD-LFLAGS) -r $^ -o $@

build/kernel.o:

always:
	mkdir -p build/
	mkdir -p build/kernel
	mkdir -p build/libc
	mkdir -p build/libasm
	mkdir -p build/asm