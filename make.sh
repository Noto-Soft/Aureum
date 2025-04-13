rm -rf build
mkdir -p build
yasm src/boot/boot.asm -f bin -o build/boot.bin
yasm src/kernel/entry.asm -f elf32 -o build/kernel_entry.o
gcc -ffreestanding -m32 -nostdlib -fno-pie -fno-pic -c src/kernel/kernel.c -o build/kernel_main.o
ld -m elf_i386 -nostdlib -Tlinker.ld build/kernel_entry.o build/kernel_main.o -o build/kernel.bin
cat build/boot.bin build/kernel.bin > build/os.img
truncate -s 1440k build/os.img
qemu-system-i386 -drive file=build/os.img,if=floppy,format=raw -name NS-Au