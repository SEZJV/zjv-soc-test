IMG_DIR ?= $(CURDIR)/../build/img


all: $(IMG)
	$(CC) -march=rv64g -mabi=lp64 -nostdlib -nostartfiles $(INCLUDE_DIR) -T zjv-soc.ld -DIMG='"$(IMG)"' load.S -o $(IMG_DIR)/$(notdir $(IMG))