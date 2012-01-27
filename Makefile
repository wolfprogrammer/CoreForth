all: lm3s811.bin qemu.bin

%.bin: %.elf
	arm-none-eabi-objcopy -Obinary $< $@

.s.o:
	arm-none-eabi-as -mcpu=cortex-m3 -o $@ $< 

lm3s811.o: CoreForth.s

qemu.o: CoreForth.s

qemu.o: lm3s811.s
	arm-none-eabi-as -mcpu=cortex-m3 -defsym UART_USE_INTERRUPTS=1 -o $@ $< 

lm3s811.elf: lm3s811.o
	arm-none-eabi-ld $< -o $@ -Tlm3s811.ld

qemu.elf: qemu.o
	arm-none-eabi-ld $< -o $@ -Tlm3s811.ld

clean:
	rm -f *.elf *.bin *.o

run: qemu.elf
	qemu-system-arm -M lm3s811evb -nographic -kernel qemu.elf; stty sane
