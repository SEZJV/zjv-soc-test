DEST_DIR ?= $(CURDIR)/../build/soc-elf
TARGET	 ?= $(DEST_DIR)/$(notdir $(IMG))
CFLAG	 ?= -march=rv64g -mabi=lp64 -nostdlib -nostartfiles $(INCLUDE_DIR) -T zjv-soc.ld

ifneq ($(IMG),)
CFLAG += -DIMG='"$(IMG)"'
endif


all: $(IMG)
	$(CC) $(CFLAG) load.S -o $(TARGET)