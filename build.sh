#!/bin/bash

CC_LFLAGS="-ffreestanding -m32 -nostdlib -fno-pie -fno-pic"
LD_LFLAGS="-m elf_i386 -nostdlib -Tlinker.ld"

mkdir -p build

# Assemble bootloader
nasm src/bootloader/boot.asm -f bin -o build/boot.bin

# Compile all .c files in src/kernel/
for file in src/kernel/*.c; do
    filename=$(basename "$file" .c)
    gcc $CC_LFLAGS -c "$file" -o "build/$filename.o"
done

# Link all .o files
ld $LD_LFLAGS build/*.o -o build/kernel.bin

# Create disk image
cat build/boot.bin build/kernel.bin > aureum.img

# Clean up build dir
rm -rf build

# Run in QEMU
qemu-system-x86_64 -drive if=floppy,file=aureum.img,format=raw
