ASM=nasm

SRC_DIR=src
BUILD_DIR=build

.PHONY: all floppy_image kernel bootloader clean always

#
#Floppy image
#
floppy_image: $(BUILD_DIR)/main_floppy.img

#This is each line explaination for the commands we're using in the bootloader.kernel
#generate the empty 1.44 MB file	
#Generating the file system using mkfs.fat
# Put the booatloader at the first sector of the disk
#to copy the kernal.bin files to the disk  we can use the mcopy command

$(BUILD_DIR)/main_floppy.img: bootloader kernel
	dd if=/dev/zero of=$(BUILD_DIR)/main_floppy.img bs=512 count=2880     				
	mkfs.fat -F 12 -n "NBOS" $(BUILD_DIR)/main_floppy.img		
	dd if=$(BUILD_DIR)/bootloader.bin of=$(BUILD_DIR)/main_floppy.img conv=notrunc						 
	mcopy -i $(BUILD_DIR)/main_floppy.img $(BUILD_DIR)/kernel.bin "::kernel.bin"
#dd if=/dev/zero of=$(BUILD_DIR)/main_floppy.img bs=512 count=2880     				
#mkfs.fat -F 12 -n "NBOS" $(BUILD_DIR)/main_floppy.img								 
#dd if=$(BUILD_DIR)/bootloader.bin of=$(BUILD_DIR)/main_floppy.img conv=notrunc
#mcopy -i "$(BUILD_DIR)/main_floppy.img" "$(BUILD_DIR)/kernel.bin" "::kernel.bin"
	
	

#
#Bootloader
#
bootloader: $(BUILD_DIR)/bootloader.bin


$(BUILD_DIR)/bootloader.bin: always
	$(ASM) $(SRC_DIR)/bootloader/boot.asm -f bin -o $(BUILD_DIR)/bootloader.bin


#
#kernel
#
kernel: $(BUILD_DIR)/kernel.bin

$(BUILD_DIR)/kernel.bin: always
	$(ASM) $(SRC_DIR)/kernel/main.asm -f bin -o $(BUILD_DIR)/kernel.bin

#
#Always
#
always:
	mkdir -p $(BUILD_DIR)

#
#Clean
#
Clean:
	rm -rf $(BUILD_DIR)/