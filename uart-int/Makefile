export
CROSS_=riscv64-unknown-elf-
GCC=${CROSS_}gcc
LD=${CROSS_}ld
OBJCOPY=${CROSS_}objcopy

ISA=rv64imafd
ABI=lp64

INCLUDE = -I ../common -I ../libmin
CF =  -O3 -march=$(ISA) -mabi=$(ABI) -mcmodel=medany -ffunction-sections -fdata-sections -nostartfiles -nostdlib -nostdinc -static -lgcc -Wl,--nmagic -Wl,--gc-sections -g 
CFLAG = ${CF} ${INCLUDE}

arc_src            = $(sort $(wildcard ./*.c)) $(sort $(wildcard ../libmin/*.c))	
asm_src            = $(sort $(wildcard ./*.S))	
obj                = $(patsubst %.S,%.o,$(asm_src)) $(patsubst %.c,%.o,$(arc_src))

%.o: %.c
	$(GCC) $(CFLAG) -c $< -o $@

%.o: %.S
	$(GCC) $(CFLAG) -c $< -o $@


all: $(obj)
	${LD} -T vmlinux.lds $(obj)  -o vmlinux



clean:
	rm *.o ../libmin/*.o vmlinux

