SRC_DIR      	:= $(CURDIR)
DEST_DIR     	?= $(CURDIR)/build
SIM_ELF_DIR		:= $(DEST_DIR)/sim-elf
SIM_BIN_DIR     := $(DEST_DIR)/sim-bin
SIM_HEX_DIR     := $(DEST_DIR)/sim-hex
SOC_ELF_DIR		:= $(DEST_DIR)/soc-elf
SOC_BIN_DIR     := $(DEST_DIR)/soc-bin
SOC_HEX_DIR     := $(DEST_DIR)/soc-hex

TARGET_DIR		:= $(DEST_DIR) $(SIM_ELF_DIR) $(SIM_BIN_DIR) $(SIM_HEX_DIR) $(SOC_ELF_DIR) $(SOC_BIN_DIR) $(SOC_HEX_DIR) 

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
	$$(RISCV_PREFIX)-gcc $$(CXX_FLAGS) $$(INCLUDE_DIR) $$(LINK_SCRIPT) $$< -o $$(SIM_ELF_DIR)/$(1)_$$@
	$$(RISCV_PREFIX)-objcopy -O binary $$(SIM_ELF_DIR)/$(1)_$$@ $$(SIM_BIN_DIR)/$(1)_$$@
	od -v -An -tx8 $$(SIM_BIN_DIR)/$(1)_$$@ > $$(SIM_HEX_DIR)/$(1)_$$@
	$$(MAKE) -C loader IMG=$$(SIM_ELF_DIR)/$(1)_$$@ CC=$$(RISCV_PREFIX)-gcc DEST_DIR=$$(SOC_ELF_DIR) INCLUDE_DIR=$$(INCLUDE_DIR)
	$$(RISCV_PREFIX)-objcopy -O binary $$(SOC_ELF_DIR)/$(1)_$$@ $$(SOC_BIN_DIR)/$(1)_$$@
	od -v -An -tx8 $$(SOC_BIN_DIR)/$(1)_$$@ > $$(SOC_HEX_DIR)/$(1)_$$@

.PHONY: $(1)
tests += $$($(1)_test_target)

endef

$(TARGET_DIR):
	mkdir -p $(TARGET_DIR)

$(eval $(call compile_template,rv64si))
$(eval $(call compile_template,rv64ui))
$(eval $(call compile_template,rv64ua))
$(eval $(call compile_template,rv64um))
$(eval $(call compile_template,rv64mi))
$(eval $(call compile_template,uart))

all: $(TARGET_DIR) $(tests)
	$(MAKE) -C loader  CC=$(RISCV_PREFIX)-gcc DEST_DIR=$(SOC_ELF_DIR) INCLUDE_DIR=$(INCLUDE_DIR) TARGET=$(SOC_ELF_DIR)/empty
	$(RISCV_PREFIX)-objcopy -O binary $(SOC_ELF_DIR)/empty $(SOC_BIN_DIR)/empty
	od -v -An -tx8 $(SOC_BIN_DIR)/empty > $(SOC_HEX_DIR)/empty

clean:
	rm -rf build