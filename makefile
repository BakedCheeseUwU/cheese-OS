ASM = nasm

SRC_DIR = src
BUILD_DIR = build

#Rule to build the floppy disk image
#Take the binary file previously build and fill it with 0 until it has 1.44mb
$(BUILD_DIR)/main_floppy.img: $(BUILD_DIR)/main.bin
	cp $(BUILD_DIR)/main.bin $(BUILD_DIR)/main_floppy.img
	truncate -s 1440k $(BUILD_DIR)/main_floppy.img

# Rule to build the main.asm file using nasm and output in binary format
$(BUILD_DIR)/main.bin: $(SRC_DIR)/main.asm
	$(ASM) $(SRC_DIR)/main.asm -f bin -o $(BUILD_DIR)/main.bin
