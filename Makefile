###############################################################################
#	makefile
#	 by Alex Chadwick
#
#	A makefile script for generation of raspberry pi kernel images.
###############################################################################

# The toolchain to use. arm-none-eabi works, but there does exist 
# arm-bcm2708-linux-gnueabi.
ARMGNU ?= arm-none-eabi

# The intermediate directory for compiled object files.
BUILD = build

# The directory in which source files are stored.
SOURCE = source

# The name of the output file to generate.
TARGET = kernel.img

# The name of the assembler listing file to generate.
LIST = kernel.list

# The name of the map file to generate.
MAP = kernel.map

# The name of the linker script to use.
LINKER = PilotDeuce.ld

# The names of all object files that must be generated. Deduced from the 
# assembly code files in source.
OBJECTSASM := $(patsubst $(SOURCE)/%.asm,$(BUILD)/%.o,$(wildcard $(SOURCE)/*.asm))

# The names of all object files that must be generated. Deduced from the 
# C files in source.
OBJECTSC := $(patsubst $(SOURCE)/%.c,$(BUILD)/%.o,$(wildcard $(SOURCE)/*.c))

# Rule to make everything.
all: $(TARGET) $(LIST)

# Rule to remake everything. Does not include clean.
rebuild: all

# Rule to make the listing file.
$(LIST) : $(BUILD) $(BUILD)/output.elf
	$(ARMGNU)-objdump -d $(BUILD)/output.elf > $(LIST)

# Rule to make the image file.
$(TARGET) : $(BUILD)/output.elf
	$(ARMGNU)-objcopy $(BUILD)/output.elf -O binary $(TARGET) 

# Rule to make the elf file.
$(BUILD)/output.elf : $(OBJECTSASM) $(OBJECTSC) $(LINKER)
	$(ARMGNU)-ld --no-undefined $(OBJECTSASM) $(OBJECTSC) -Map $(MAP) -o $(BUILD)/output.elf -T $(LINKER)

# Rule to make the object files.
$(BUILD)/%.o: $(SOURCE)/%.asm $(BUILD)
	$(ARMGNU)-as --version	
	$(ARMGNU)-as -I $(SOURCE) $< -o $@


# Rule to make the object files.
# arm-none-eabi-gcc -ggdb -c -mcpu=arm926ej-s -g test.c -o test.o
$(BUILD)/%.o: $(SOURCE)/%.c $(BUILD)
	$(ARMGNU)-gcc -ggdb -c -mcpu=arm926ej-s -g $(SOURCE) $< -o $@


$(BUILD):
	mkdir $@

# Rule to clean files.
clean : 
	-rm -rf $(BUILD)
	-rm -f $(TARGET)
	-rm -f $(LIST)
	-rm -f $(MAP)
