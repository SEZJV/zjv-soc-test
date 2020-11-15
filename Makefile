SRC_DIR      := $(CURDIR)
DEST_DIR     ?= $(CURDIR)/build
ELF_DIR		 := $(DEST_DIR)/elf
BIN_DIR      := $(DEST_DIR)/bin
IMG_DIR      := $(DEST_DIR)/img


## XXX_test_src XXX_test_target
include $(CURDIR)/rv64si/Makefile
include $(CURDIR)/rv64ui/Makefile
include $(CURDIR)/rv64ua/Makefile
include $(CURDIR)/rv64um/Makefile
include $(CURDIR)/rv64mi/Makefile
include $(CURDIR)/uart/Makefile

RISCV_PREFIX   := riscv64-unknown-elf
LINK_SCRIPT    := -T$(CURDIR)/common/zjv.ld 
INCLUDE_DIR    := -I$(CURDIR)/common
RISCV_ISA      := -march=rv64g -mabi=lp64
CXX_FLAGS      := $(RISCV_ISA) -nostdlib -nostartfiles 

ifeq (, $(shell which $(RISCV_PREFIX)-gcc))
$(error "No riscv-toolchain in $$PATH")
endif

default: all

define compile_template

$$($(1)_test_target): %: $$(SRC_DIR)/$(1)/%.S
	$$(RISCV_PREFIX)-gcc $$(CXX_FLAGS) $$(INCLUDE_DIR) $$(LINK_SCRIPT) $$< -o $$(ELF_DIR)/$(1)_$$@
	$$(RISCV_PREFIX)-objcopy -O binary $$(ELF_DIR)/$(1)_$$@ $$(BIN_DIR)/$(1)_$$@
	$$(MAKE) -C loader IMG=$$(BIN_DIR)/$(1)_$$@ CC=$$(RISCV_PREFIX)-gcc IMG_DIR=$$(IMG_DIR) INCLUDE_DIR=$$(INCLUDE_DIR)

.PHONY: $(1)
tests += $$($(1)_test_target)

endef

$(DEST_DIR) $(IMG_DIR) $(ELF_DIR) $(BIN_DIR):
	mkdir -p $(DEST_DIR) $(IMG_DIR) $(ELF_DIR) $(BIN_DIR)

$(eval $(call compile_template,rv64si))
$(eval $(call compile_template,rv64ui))
$(eval $(call compile_template,rv64ua))
$(eval $(call compile_template,rv64um))
$(eval $(call compile_template,rv64mi))
$(eval $(call compile_template,uart))

all: $(DEST_DIR) $(IMG_DIR) $(ELF_DIR) $(BIN_DIR) $(tests)

clean:
	rm -rf build