arm-none-eabi-as -mcpu=arm926ej-s -g source\ace.asm -o startup.o
arm-none-eabi-gcc -ggdb -c -mcpu=arm926ej-s -g test.c -o test.o
arm-none-eabi-ld -T test.ld test.o startup.o -o test.elf
arm-none-eabi-objcopy -O binary test.elf test.bin