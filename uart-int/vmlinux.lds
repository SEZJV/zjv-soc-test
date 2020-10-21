BASE_ADDR = 0x80000000;
SECTIONS
{
	. = BASE_ADDR;
	.text : {
		*(.text.init)
		*(.text.entry)
		*(.text)
	 }
	.rodata : { *(.rodata) }
	.data : { *(.data) }
	bss_start = .;
	.bss : { *(.bss) }
	bss_end = .;
	. += 0x8000;
	. = ALIGN(0x1000);
	stack_top = .;
	_end = .;
}
