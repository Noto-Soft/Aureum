rm -rf build
mkdir -p build
yasm src/boot/boot.asm -f bin -o build/boot.bin
yasm src/kernel/kernel.asm -f bin -o build/kernel.bin
cat build/boot.bin build/kernel.bin > build/os.img
truncate -s 1440k build/os.img
qemu-system-i386 -drive file=build/os.img,if=floppy,format=raw -name NS-Au